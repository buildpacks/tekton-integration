
test-kind:
	./scripts/kind/full_run.sh

test-gke:
	./scripts/gke/full_run.sh

test-open-shift: export KUBECTL_CMD=oc
test-open-shift:
	./scripts/open-shift/full_run.sh
