# 同步 lily 源数据到 BigQuery

## 表结构

所有的 lily 表结构，均创建到 BigQuery 上的 lily-data 项目下的 lily 这个 dataset 中。如果某张表有 height 字段，则按30天的高度范围分区。

所有的 lily 表结构，均按照 lily TimescaleDB 中的结构创建。受限于 BigQuery 平台自身的实现限制，为了保证数据的完整写入，TimescaleDB 中的 NUMERIC 类型的字段，均改为 STRING 类型。

表结构创建的 DDL 语句，记录在 `schema/lily_on_bigquery.sql` 文件中。

## 同步程序

代码在 `procedures/pack_sync_lily_from_timescaledb_to_bigquery/sync_lily_from_timescaledb_to_bigquery` 。

每张 lily 表一个独立的同步过程，定义在 `sync_lily_from_timescaledb_to_bigquery/data_defs` 下。没有数据的表（即 lily software 不跑相应 task）或只有历史数据不再更新的表不同步。

