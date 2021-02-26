# ${DISPLAY_NAME}

${SUMMARY}

The lifecycle phases are run in separate containers to enable better security for untrusted builders. Specifically, registry credentials are hidden from the detect and build phases of the lifecycle, and the analyze, restore, and export phases (which require credentials) are run in the lifecycle image published by the [Cloud Native Buildpacks project]( https://hub.docker.com/u/buildpacksio).

See also [`buildpacks`](../buildpacks) for the combined version of this task, which uses the [creator binary](https://github.com/buildpacks/spec/blob/platform/0.4/platform.md#operations), to run all of the [lifecycle phases](https://buildpacks.io/docs/concepts/components/lifecycle/#phases). This task, in contrast, runs all of the phases separately.

## Compatibility

- **Tekton** v${TEKTON_MIN_VERSION} and above
- **[Platform API][platform-api]** ${PLATFORM_API_VERSION}
    - For other versions, see [previous versions](#previous-versions).

## Install

```
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/${TYPE}/${NAME}/${VERSION}/${NAME}.yaml
```

## Workspaces

${WORKSPACES}

## Parameters

${PARAMETERS}

## Builders

The following is only a subset of [builders](https://buildpacks.io/docs/concepts/components/builder/) available. These are the suggested builders from the Cloud Native Buildpacks projects.

${BUILDERS}

## Usage

See the following samples for usage:

- **[env-vars](samples/env-vars.yaml)**: A Pipeline configured to provide _build-time_ environment variables.
- **[lifecycle-image](samples/lifecycle-image.yaml)**: A Pipeline configured to use a specific image of the lifecycle.

## Previous Versions

For support of previous [Platform API][platform-api]s use a previous version of this task.

> Be sure to also supply a compatible builder image (`BUILDER_IMAGE` input) when running the task (i.e. one that has a lifecycle that supports the platform API).

| Version        | Platform API
|----            |-----
| [0.1](../0.1/) | [0.3][platform-api-0.3]

[platform-api]: https://buildpacks.io/docs/reference/spec/platform-api/
[platform-api-0.3]: https://github.com/buildpacks/spec/blob/platform/0.3/platform.md