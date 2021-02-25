# ${DISPLAY_NAME}

${SUMMARY}

## Dependencies

- [`git-clone` task](https://github.com/tektoncd/catalog/tree/master/task/git-clone) 0.2 or newer
- [`buildpacks` task](../../../task/buildpacks/) 0.3 or newer
- [`buildpacks-phases` task](../../../task/buildpacks-phases/) 0.2 or newer

## Compatibility

- **Tekton** v${TEKTON_MIN_VERSION} and above
- **[Platform API][platform-api]** ${PLATFORM_API_VERSION}

[platform-api]: https://buildpacks.io/docs/reference/spec/platform-api/

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

- **[cache-image](samples/cache-image.yaml)**: A PipelineRun configured to cache build artifacts in an image.
- **[cache-volume](samples/cache-volume.yaml)**: A PipelineRun configured to cache build artifacts in an volume.
- **[run-image](samples/run-image.yaml)**: A PipelineRun configured to specify an explicit run image.