lint:
	@echo "> Linting task/buildpacks/0.0/buildpacks.yaml..."
	catlin validate task/buildpacks/0.0/buildpacks.yaml
	@echo
	@echo "> Linting task/buildpacks-phases/0.0/buildpacks-phases.yaml..."
	catlin validate task/buildpacks-phases/0.0/buildpacks-phases.yaml

test-kind:
	./scripts/kind/full_run.sh

test-gke:
	./scripts/gke/full_run.sh

test-openshift: export KUBECTL_CMD=oc
test-openshift:
	./scripts/openshift/full_run.sh
