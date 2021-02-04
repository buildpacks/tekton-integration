# Tekton Integration

The purpose of this repository is to provide the means for testing and developing the integration between [Tekton][tekton] and Cloud Native Buildpack's [Lifecycle][lifecycle].

## Tasks


| task | source | description
|---   |---    |---
| buildpacks | [next (dev)](task/buildpacks) · [catalog][task-buildpacks] | Improved performance by executing entire build in the least amount of containers.
| buildpacks-phases | [next (dev)](task/buildpacks-phases) · [catalog][task-buildpacks-phases] | Improved security by isolating build phases to individual containers.

[lifecycle]: https://buildpacks.io/docs/concepts/components/lifecycle/
[task-buildpacks]: https://github.com/tektoncd/catalog/tree/master/task/buildpacks
[task-buildpacks-phases]: https://github.com/tektoncd/catalog/tree/master/task/buildpacks-phases
[tekton]: https://tekton.dev/

## Support

The [Buildpacks Community](http://buildpacks.io/community/) is always here to help. 

We can be found in our [discussion board][discussion-board] or [slack][slack] (`#tekton`).

## Contributing

We ❤ contributions.

- [CONTRIBUTING](https://github.com/buildpacks/.github/blob/main/CONTRIBUTING.md) - Learn what's necessary to start contributing.
- [DEVELOPMENT](DEVELOPMENT.md) - Get details to help you during development within this specific repo.


[discussion-board]: https://github.com/buildpacks/community/discussions
[slack]: https://slack.buildpacks.io