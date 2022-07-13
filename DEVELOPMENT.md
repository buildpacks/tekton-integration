## Samples

Samples require some bootstraping hence there are two scripts to assist in executing the samples.

##### Prerequisites

- `kubectl`
    - ... with configured context
- [Tekton Pipelines][tekton-install]
- Docker Registry
    - ... learn how to use a [local registry](./DEVELOPMENT.md#docker-registry)
    - ... other registries may require additional [auth configuration][tekton-docker-auth]

[tekton-install]: https://github.com/tektoncd/pipeline/blob/master/docs/install.md#installing-tekton-pipelines-on-kubernetes
[tekton-docker-auth]: https://github.com/tektoncd/pipeline/blob/master/docs/auth.md#configuring-authentication-for-docker

##### Run

```
./scripts/sample-run.sh <path/to/sample.yaml> <image-name>
```

Additional options (using `tkn`):

- To rerun a pipeline with the same parameters:
    ```
    tkn pipeline start buildpacks --last --showlog
    ```
- To rerun a pipeline while overriding last paramters (ie. `TRUST_BUILDER`):
    ```
    tkn pipeline start buildpacks --last --showlog  -p TRUST_BUILDER=false
    ```

##### Cleanup

```
./scripts/sample-cleanup.sh <path/to/sample.yaml>
```

## Linting

#### Dependencies

- [catlin](https://github.com/tektoncd/plumbing/tree/master/catlin)
- [yamllint](https://yamllint.readthedocs.io/en/stable/)

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
| `DIFFCMD` | `git diff --no-index` | Command to use for diff'ing task contents.

#### Usage

```shell
make diff
```

[platform-kind]: https://kind.sigs.k8s.io/
[platform-gke]: https://cloud.google.com/kubernetes-engine
[platform-openshift]: https://www.openshift.com/products/container-platform
[tekton-tests]: https://github.com/tektoncd/catalog/tree/master/test

## Docker Registry

Setting up a docker registry simplifies testing by not having to provide authentication to the tekton pipeline.

The following solution starts a local docker registry but routes it publically via ngrok so that communication can occur using https without having to deal with certificates.

##### Dependencies

- docker
- ngrok

##### Steps

1. Start docker registry
    ```shell
    docker run --rm -e REGISTRY_STORAGE_DELETE_ENABLED=true -d -p 5000:5000 registry:2
    ```
2. Forward port via ngrok
    ```
    ngrok http 5000
    ```
3. Reference images using the domain provided by ngrok (ie. `aebbf67b0993.ngrok.io`)
    ```
    aebbf67b0993.ngrok.io/myorg/myapp
    ```
