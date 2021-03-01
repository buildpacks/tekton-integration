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
kubectl apply -f https://raw.githubusercontent.com/buildpacks/tekton-integration/main/${TYPE}/${NAME}/${VERSION}/${NAME}.yaml
```

## Workspaces

${WORKSPACES}

## Parameters

${PARAMETERS}

## Builders

${BUILDERS}

## Usage

${SAMPLES}

## Support

${SUPPORT}

## Contributing

${CONTRIBUTING}
