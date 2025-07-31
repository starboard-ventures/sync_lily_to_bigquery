VMROOT ?= ENV
PYCMD := $(VMROOT)/bin/python
PIPCMD := $(VMROOT)/bin/pip
LINTCMD := $(VMROOT)/bin/ruff

init:
	@[ -d "$(VMROOT)" ] || { echo "You need to make a virtual environment named $(VMROOT) first!"; exit 1; }
	@test -d $(VMROOT) && $(PIPCMD) install -U build
	@test -d $(VMROOT) && $(PIPCMD) install -U wheel
	@test -d $(VMROOT) && $(PIPCMD) install .

clean:
	@find . -type f -name "*.whl" -delete || true
	@test -d dist && rm -rf dist || true

lint:
	$(LINTCMD) check --ignore F403 --ignore F405

wheel: lint
	@test -f *.whl && rm *.whl || true
	$(PYCMD) -m build
	@mv dist/*.whl ./
	@test -d build && rm -r build || true
	@test -d dist && rm -r dist || true
	@find . -type d -name "*.egg-info" -exec rm -r "{}" + || true

