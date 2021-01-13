# Tekton Integration

The purpose of this repository is solely to provide the means for testing and developing the integration between [Tekton][tekton] and the [Lifecycle][lifecycle].

The Tekton task definitions can be found in the Tekton Catalog as...

- [buildpacks](https://github.com/tektoncd/catalog/tree/master/task/buildpacks)
- [buildpacks-phases](https://github.com/tektoncd/catalog/tree/master/task/buildpacks-phases)

## Linting

#### Dependencies

- [catlin](https://github.com/tektoncd/plumbing/tree/master/catlin)

#### Usage

```shell
make lint
```

## Testing

#### Configuration

| Env | Default | Description
|---  |---      |---
| `TASKS` | Tasks in [task](task) directory | Tasks to test. (format: `<taskname:version>;<taskname:version>;...`)
| `KUBECTLCMD` | `kubectl` | Command to use instead of `kubectl`.

Tests may be ran on any of the following platforms via...

#### Ephemeral Environments

Running a _full test_ entails setting up an ephemeral environment. This may be done by running the associated Make target:

| Platform | Make target | Scripts
|---       |---          |---
| [GKE][platform-gke] | `test-gke` | [gke](scripts/platforms/gke/)
| [Kind][platform-kind] | `test-kind` | [kind](scripts/platforms/kind/)
| [OpenShift][platform-openshift] | `test-openshift` | [openshift](scripts/platforms/openshift/)

##### Example

```script
make test-kind
```

#### Pre-existing Environment

Running tests on a pre-existing environments may be done by choosing the right `kubeclt` context and executing the following scripts...

##### Scripts

- [`scripts/platforms/1_k8s_setup.sh`](scripts/platforms/1_k8s_setup.sh) → Install Tekton
- [`scripts/platforms/2_run_tests.sh`](scripts/platforms/2_run_tests.sh) → Run tests of our tasks using the same mechanism provided by the [Catalog][tekton-tests].

## Diffing

Compare tasks against latest version in Tekton Catalog.

#### Configuration

| Env | Default | Description
|---  |---      |---
| `TASKS` | Tasks in [task](task) directory | Tasks to compare. (format: `<taskname:version>;<taskname:version>;...`)
| `DIFFCMD` | `diff` | Command to use instead of `diff`.

#### Usage

```shell
make diff
```

[lifecycle]: https://buildpacks.io/docs/concepts/components/lifecycle/
[platform-kind]: https://kind.sigs.k8s.io/
[platform-gke]: https://cloud.google.com/kubernetes-engine
[platform-openshift]: https://www.openshift.com/products/container-platform
[tekton]: https://tekton.dev/
[tekton-tests]: https://github.com/tektoncd/catalog/tree/master/test
