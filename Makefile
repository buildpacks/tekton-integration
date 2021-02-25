.PHONY: lint
lint:
	@ls -1 pipeline/buildpacks*/*/*.yaml | xargs -I '{}' sh -c 'echo ">> Validating {}..."; catlin validate {}'
	@ls -1 task/buildpacks*/*/*.yaml | xargs -I '{}' sh -c 'echo ">> Validating {}..."; catlin validate {}'

.PHONY: test-kind
test-kind:
	@./scripts/platforms/kind/full_run.sh

.PHONY: test-gke
test-gke:
	@./scripts/platforms/gke/full_run.sh

.PHONY: test-openshift
test-openshift: export KUBECTLCMD=oc
test-openshift:
	@./scripts/platforms/openshift/full_run.sh

.PHONY: generate-docs
generate-docs:
	@find pipeline -type d | grep -e '[a-z\-]\+/[0-9]\+\.[0-9]\+$$' | xargs -I '{}' sh -c 'echo "\n\n>> Docs for {}...\n"; ./scripts/generate-docs.sh {}'
	@find task -type d | grep -e '[a-z\-]\+/[0-9]\+\.[0-9]\+$$' | xargs -I '{}' sh -c 'echo "\n\n>> Docs for {}...\n"; ./scripts/generate-docs.sh {}'

.PHONY: diff
diff:
	@./scripts/diff.sh

.PHONY: prepare-for-pr
prepare-for-pr: lint generate-docs test-kind
