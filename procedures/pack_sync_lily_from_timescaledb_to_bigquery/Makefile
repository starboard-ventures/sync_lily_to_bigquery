VMROOT ?= ENV
PYCMD := $(VMROOT)/bin/python
PIPCMD := $(VMROOT)/bin/pip
LINTCMD := $(VMROOT)/bin/ruff

init:
	@[ -d "$(VMROOT)" ] || { echo "You need to make a virtual environment named $(VMROOT) first!"; exit 1; }
	@export all_proxy=
	@export ALL_PROXY=
	@test -d $(VMROOT) && $(PIPCMD) install -r requirements.txt

clean:
	@find . -type f -name "*.whl" -delete || true

lint:
	$(LINTCMD) check --ignore F403 --ignore F405

wheel: lint
	@test -f *.whl && rm *.whl || true
	$(PYCMD) setup.py bdist_wheel
	@mv dist/*.whl ./
	@test -d build && rm -r build || true
	@test -d dist && rm -r dist || true
	@test -d *.egg-info && rm -r *.egg-info || true

