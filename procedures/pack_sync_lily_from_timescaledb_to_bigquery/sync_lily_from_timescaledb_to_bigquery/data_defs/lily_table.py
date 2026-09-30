
import datetime
import logging
import uuid
from abc import ABC, abstractmethod

# pyrefly: ignore  # import-error
from pyspark.dbutils import DBUtils
from pyspark.sql import DataFrame as spkDataFrame
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class LilyTable(ABC):

    def __init__(self, table_name: str, config):
        self.table_name = table_name
        self.config = config

        self.pg_table_name = f"public.{self.table_name}"

        self.bqy_table_name = f"lily-data.lily.{self.table_name}"
        self.bqy_table_if_overwrite = False


    def get_height_range(self, spark: SparkSession, stat_date: str) -> tuple[int, int]:
        # pyrefly: ignore  # unsupported-operation
        height_end = spark.sql(f"""
          SELECT height_end
            FROM lakehouse.dim_stat_date_series
           WHERE stat_date = to_date('{stat_date}')
        """).first()[0]

        height_start = height_end - 2880

        logger.info(f"Got height range : [{height_start}, {height_end}) for {self.table_name}")
        return (height_start, height_end)


    @abstractmethod
    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        pass


    def fetch_source_data_from_postgresql(self, spark: SparkSession, sql_query: str) -> spkDataFrame:
        dbutils = DBUtils(spark)
        src_url = dbutils.secrets.get(scope="databricks-starboard-jdbc", key="lily-starboard-url")
        src_username = dbutils.secrets.get(scope="databricks-starboard-jdbc", key="lily-starboard-username")
        src_password = dbutils.secrets.get(scope="databricks-starboard-jdbc", key="lily-starboard-password")
        src_properties = {"user": src_username,
                          "password": src_password}

        logger.info(f"Fetching data of {self.pg_table_name} from TimescaleDB")

        query_id = uuid.uuid3(uuid.NAMESPACE_URL, self.pg_table_name).hex
        sql_query_used = "(" + sql_query + " ) query_" + query_id.replace("-", '')

        df_src_data = (spark.read
          .jdbc(
            url=src_url,
            table=sql_query_used,
            properties=src_properties
          )
        )

        logger.info(f"Source data of {self.pg_table_name} from TimescaleDB fetched.")

        logger.info(f"   Schema => {df_src_data.schema}")
        if "height" in df_src_data.columns:
            # pyrefly: ignore  # unsupported-operation
            max_height_of_source_data = df_src_data.agg({"height": "max"}).first()[0]
            if max_height_of_source_data is not None:
                unixepoch_of_max_height = max_height_of_source_data * 30 + 1598306400
                timestamp_of_max_height = datetime.datetime.fromtimestamp(unixepoch_of_max_height, tz=datetime.UTC)
                logger.info(f"   Max value of height => {max_height_of_source_data} → {timestamp_of_max_height.isoformat()}")

        return df_src_data


    def make_target_data_clean_dml(self, height_start: int, height_end: int) -> str:
        return (f"""
          DELETE FROM {self.bqy_table_name}
                WHERE height >= {height_start}
                  AND height <  {height_end}
        """)


    @abstractmethod
    def make_target_data_schema(self,) -> StructType:
        pass


    def save_data_to_bigquery(self, spark: SparkSession, clean_dml: str, target_schema: StructType, df_inc_data: spkDataFrame) -> None:
        from google.cloud import bigquery

        bqy_project_id = self.config.get("bigquery", "bigquery_project_id")
        bqy_temp_gcs_bucket = self.config.get("bigquery", "gcs_temp_buckent_name")

        spark.conf.set("parentProject", bqy_project_id)

        df_to_write = spark.createDataFrame(df_inc_data.rdd, target_schema)

        if df_to_write.isEmpty():
            logger.info(f"Source data is empty, no data to write to {self.bqy_table_name} !")
            return

        if self.bqy_table_if_overwrite :
            logger.info(f"Overwriting data to {self.bqy_table_name} on BigQuery | project_id = {bqy_project_id} , temp_gcs_bucket = {bqy_temp_gcs_bucket}")
            (df_to_write.write
              .format("bigquery")
              .mode("overwrite")
              .option("temporaryGcsBucket", bqy_temp_gcs_bucket)
              .option("table", self.bqy_table_name)
              .save())
        else:
            path_to_private_key = self.config.get("dbfs", "bigquery_lily_sa_json")
            client = bigquery.Client.from_service_account_json(json_credentials_path=path_to_private_key)

            logger.info(f"Cleaning old data in {self.bqy_table_name} on BigQuery => {clean_dml}")
            query_job = client.query(clean_dml)
            _ = query_job.result()
            logger.info("Clean done.")

            logger.info(f"Appending data to {self.bqy_table_name} on BigQuery | project_id = {bqy_project_id} , temp_gcs_bucket = {bqy_temp_gcs_bucket}")
            (df_to_write.write
              .format("bigquery")
              .mode("append")
              .option("temporaryGcsBucket", bqy_temp_gcs_bucket)
              .option("table", self.bqy_table_name)
              .save())

        logger.info(f"Data to {self.bqy_table_name} on BigQuery done.")


    def process(self, spark: SparkSession, height_start: int, height_end: int) -> None:
        logger.info(f"» Start handling table {self.table_name}")

        query_dml = self.make_source_data_query(height_start, height_end)
        logger.info(f"» Used Query => {query_dml}")

        source_data = self.fetch_source_data_from_postgresql(spark, query_dml)
        logger.info(f"» Source data of {self.pg_table_name} fetched.")

        clean_dml = self.make_target_data_clean_dml(height_start, height_end)
        target_schema = self.make_target_data_schema()
        self.save_data_to_bigquery(spark, clean_dml, target_schema, source_data)
        logger.info(f"» Persisted table {self.bqy_table_name} on BigQuery")

        logger.info(f"» End handling table {self.table_name}")

