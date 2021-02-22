lint:
	@ls -1 task/buildpacks*/*/*.yaml | xargs -I '{}' sh -c 'echo ">> Validating {}..."; catlin validate {}'

test-kind:
	@./scripts/platforms/kind/full_run.sh

test-gke:
	@./scripts/platforms/gke/full_run.sh

test-openshift: export KUBECTLCMD=oc
test-openshift:
	@./scripts/platforms/openshift/full_run.sh

generate-docs:
	@find . -type d | grep -e '.*/pipeline/[a-z\-]\+/[0-9]\+\.[0-9]\+$$' -e '.*/task/[a-z\-]\+/[0-9]\+\.[0-9]\+$$' | xargs -I '{}' sh -c 'echo "\n\n>> Docs for {}...\n"; ./scripts/generate-docs.sh {}'

diff:
	@./scripts/diff.sh

.PHONY: lint test-kind test-gke test-openshift