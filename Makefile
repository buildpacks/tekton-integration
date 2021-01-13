lint:
	@echo "> Linting task/buildpacks/0.0/buildpacks.yaml..."
	catlin validate task/buildpacks/0.0/buildpacks.yaml
	@echo
	@echo "> Linting task/buildpacks-phases/0.0/buildpacks-phases.yaml..."
	catlin validate task/buildpacks-phases/0.0/buildpacks-phases.yaml

test-kind:
	@./scripts/platforms/kind/full_run.sh

test-gke:
	@./scripts/platforms/gke/full_run.sh

test-openshift: export KUBECTLCMD=oc
test-openshift:
	@./scripts/platforms/openshift/full_run.sh

diff:
	@./scripts/diff.sh

.PHONY: lint test-kind test-gke test-openshift