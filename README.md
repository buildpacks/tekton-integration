# tekton-integration

The purpose of this repository is solely to provide the means for testing the integration between [Tekton][tekton] and the [Lifecycle][lifecycle].

The Tekton task definition can be found at: https://github.com/tektoncd/catalog/blob/master/buildpacks

### Prerequisites

- Docker
- Git
- Go
- Kubectl

### Running tests

`go test -mod=vendor -v ./integration_test.go`

#### Configuration

Use the following environment variables to configure the test.

| Name | Default | Description |
|---   |---      |---          |
| SKIP_CLEANUP | false | Skips clean up. Great for troubleshooting.
| TASK_CONFIG | _[latest in Tekton catalog][tekton-task-config]_ | Task config applied for buildpacks task.  

[tekton]: https://tekton.dev/
[tekton-task-config]: https://raw.githubusercontent.com/tektoncd/catalog/master/buildpacks/buildpacks-v3.yaml
[lifecycle]: https://buildpacks.io/docs/concepts/components/lifecycle/