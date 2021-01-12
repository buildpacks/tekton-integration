# tekton-integration

The purpose of this repository is solely to provide the means for testing the integration between [Tekton][tekton] and the [Lifecycle][lifecycle].

The Tekton task definitions can be found in the Tekton Catalog as...

- [buildpacks](https://github.com/tektoncd/catalog/tree/master/task/buildpacks)
- [buildpacks-phases](https://github.com/tektoncd/catalog/tree/master/task/buildpacks-phases)

## Running tests

Tests may be ran on any of the following platforms via...

### Ephemeral Environments

Running a _full test_ entails setting up an ephemeral environment. This may be done by running the associated Make target:

| Platform | Make target | Scripts
|--- |--- |---
| [GKE][platform-gke] | `test-gke` | [gke](scripts/gke/)
| [Kind][platform-kind] | `test-kind` | [kind](scripts/kind/)
| [OpenShift][platform-openshift] | `test-openshift` | [openshift](scripts/openshift/)

#### Example

```script
make test-kind
```

### Pre-existing Environment

Running tests on a pre-existing environments may be done by choosing the right `kubeclt` context and executing [`scripts/2_run_tests.sh`](scripts/2_run_tests.sh).

#### Helper Scripts

- [`scripts/1_k8s_setup.sh`](scripts/1_k8s_setup.sh) → Install Tekton
- [`scripts/2_run_tests.sh`](scripts/2_run_tests.sh) → Run tests of our tasks using the same mechanism provided by the [Catalog][tekton-tests].

### Configuration

| Env | Default | Description
|---  |---      |---
| `TASKS` | Tasks in [tasks](tasks) directory | Tasks to test. (format: `<taskname:version>;<taskname:version>;...`)
| `KUBECTL_CMD` | `kubectl` | Command to use instead of `kubectl`.

[lifecycle]: https://buildpacks.io/docs/concepts/components/lifecycle/
[platform-kind]: https://kind.sigs.k8s.io/
[platform-gke]: https://cloud.google.com/kubernetes-engine
[platform-openshift]: https://www.openshift.com/products/container-platform
[tekton]: https://tekton.dev/
[tekton-tests]: https://github.com/tektoncd/catalog/tree/master/test
