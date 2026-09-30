UVCMD := uv

init:
	@command -v "$(UVCMD)" >/dev/null 2>&1 || { echo "You need to install the tool uv (https://docs.astral.sh/uv) first!"; exit 1; }
	@$(UVCMD) sync

clean:
	@find . -type f -name "*.whl" -delete || true
	@test -d build && rm -r build || true
	@test -d dist && rm -rf dist || true
	@find . -type d -name "*.egg-info" -exec rm -rf "{}" + || true

type-check:
	$(UVCMD) tool run pyrefly check

lint: type-check
	$(UVCMD) tool run ruff check \
		--ignore F403 \
		--ignore F405 \
		--ignore UP009

wheel: lint
	@test -f *.whl && rm *.whl || true
	$(UVCMD) build --wheel
	@mv dist/*.whl ./
	@test -d build && rm -r build || true
	@test -d dist && rm -r dist || true
	@find . -type d -name "*.egg-info" -exec rm -r "{}" + || true

