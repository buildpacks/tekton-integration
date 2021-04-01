# ${DISPLAY_NAME}

${SUMMARY}

## Dependencies

- [`git-clone` task](https://github.com/tektoncd/catalog/tree/master/task/git-clone) 0.3 or newer
- [`buildpacks` task](https://github.com/buildpacks/tekton-integration/tree/main/task/buildpacks/) 0.3 or newer
- [`buildpacks-phases` task](https://github.com/buildpacks/tekton-integration/tree/main/task/buildpacks-phases/) 0.2 or newer

## Compatibility

- **Tekton** v${TEKTON_MIN_VERSION} and above
- **[Platform API][platform-api]** ${PLATFORM_API_VERSION}

[platform-api]: https://buildpacks.io/docs/reference/spec/platform-api/

## Install

#### Install dependencies (if missing)

```shell
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.3/git-clone.yaml
kubectl apply -f https://raw.githubusercontent.com/buildpacks/tekton-integration/main/task/buildpacks/0.3/buildpacks.yaml
kubectl apply -f https://raw.githubusercontent.com/buildpacks/tekton-integration/main/task/buildpacks-phases/0.2/buildpacks-phases.yaml
```

#### Install pipeline

```shell
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
