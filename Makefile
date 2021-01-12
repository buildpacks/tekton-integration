
test-kind:
	./scripts/kind/full_run.sh

test-gke:
	./scripts/gke/full_run.sh

test-openshift: export KUBECTL_CMD=oc
test-openshift:
	./scripts/openshift/full_run.sh
