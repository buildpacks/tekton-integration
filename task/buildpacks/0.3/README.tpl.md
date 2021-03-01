# ${DISPLAY_NAME}

${SUMMARY}

See also [`buildpacks-phases`](../../buildpacks-phases) for the deconstructed version of this task, which runs each of the [lifecycle phases](https://buildpacks.io/docs/concepts/components/lifecycle/#phases) individually. This task uses the [creator binary](https://github.com/buildpacks/spec/blob/platform/0.4/platform.md#operations), which coordinates and runs all of the phases.

## Compatibility

- **Tekton** v${TEKTON_MIN_VERSION} and above
- **[Platform API][platform-api]** ${PLATFORM_API_VERSION}
    - For other versions, see [previous versions](#previous-versions).

## Install

```
kubectl apply -f https://raw.githubusercontent.com/buildpacks/tekton-integration/main/${TYPE}/${NAME}/${VERSION}/${NAME}.yaml
```

## Workspaces

${WORKSPACES}

## Parameters

${PARAMETERS}

## Results

${RESULTS}

## Builders

${BUILDERS}

## Usage

${SAMPLES}

## Support

${SUPPORT}

## Contributing

${CONTRIBUTING}

## Previous Versions

For support of previous [Platform API][platform-api]s use a previous version of this task.

> Be sure to also supply a compatible builder image (`BUILDER_IMAGE` input) when running the task (i.e. one that has a lifecycle that supports the platform API).

| Version        | Platform API
|----            |-----
| [0.2](../0.2/) | [0.3][platform-api-0.3]

[platform-api]: https://buildpacks.io/docs/reference/spec/platform-api/
[platform-api-0.3]: https://github.com/buildpacks/spec/blob/platform/0.3/platform.md