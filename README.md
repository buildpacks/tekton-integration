# Tekton Integration

The purpose of this repository is to provide the means for testing and developing the integration between [Tekton][tekton] and Cloud Native Buildpack's [Lifecycle][lifecycle].

## Pipeline

| Pipeline | Source | Description
|---       |---     |---
| buildpacks | [next (dev)](pipeline/buildpacks) · catalog (TBD) | Builds an application image from source stored in `git`.


## Tasks

| Task | Source | Description
|---   |---    |---
| buildpacks | [next (dev)](task/buildpacks) · [catalog][task-buildpacks] | Improved performance by executing entire build in the least amount of containers.
| buildpacks-phases | [next (dev)](task/buildpacks-phases) · [catalog][task-buildpacks-phases] | Improved security by isolating build phases to individual containers.

[lifecycle]: https://buildpacks.io/docs/concepts/components/lifecycle/
[task-buildpacks]: https://github.com/tektoncd/catalog/tree/master/task/buildpacks
[task-buildpacks-phases]: https://github.com/tektoncd/catalog/tree/master/task/buildpacks-phases
[tekton]: https://tekton.dev/


## Examples

There are a few examples through out this repo. Most require some bootstraping hence there are two scripts to assist in executing the examples.

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
./scripts/example-run.sh <path/to/sample.yaml> <image-name>
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
./scripts/example-cleanup.sh <path/to/sample.yaml>
```

## Support

The [Buildpacks Community](http://buildpacks.io/community/) is always here to help. 

We can be found in our [discussion board][discussion-board] or [slack][slack] (`#tekton`).

## Contributing

We ❤ contributions.

- [CONTRIBUTING](https://github.com/buildpacks/.github/blob/main/CONTRIBUTING.md) - Learn what's necessary to start contributing.
- [DEVELOPMENT](DEVELOPMENT.md) - Get details to help you during development within this specific repo.


[discussion-board]: https://github.com/buildpacks/community/discussions
[slack]: https://slack.buildpacks.io