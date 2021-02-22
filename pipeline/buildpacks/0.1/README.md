<!-- NOTE: This file is auto-generated. Do not manually update! -->
# Buildpacks

This pipeline builds source into a container image using [Cloud Native Buildpacks](https://buildpacks.io). To do that, it uses [builders](https://buildpacks.io/docs/concepts/components/builder/#what-is-a-builder) to run buildpacks against your application.

> _**What are Cloud Native Buildpacks?**_
> 
> _Cloud Native Buildpacks are pluggable, modular tools that transform application source code into OCI images. They replace Dockerfiles in the app development lifecycle, and enable for swift rebasing of images and modular control over images (through the use of builders), among other benefits._

## Dependencies

- [`git-clone` task](https://github.com/tektoncd/catalog/tree/master/task/git-clone) 0.2 or newer
- [`buildpacks` task](../../../task/buildpacks/) 0.3 or newer
- [`buildpacks-phases` task](../../../task/buildpacks-phases/) 0.2 or newer

## Compatibility

- **Tekton** v0.12.1 and above
- **[Platform API][platform-api]** 

## Install

```
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/pipeline/buildpacks/0.1/buildpacks.yaml
```

## Workspaces

 - **`source-ws`**: Location where source is stored. _(REQUIRED)_
 - **`cache-ws`**: Location where cache is stored if CACHE_IMAGE is not provided. _(optional)_

## Parameters

 - **`BUILDER_IMAGE`**: The image on which builds will run (must include lifecycle and compatible buildpacks). _(REQUIRED)_
 - **`TRUST_BUILDER`**: Whether the builder image is trusted. When false, each build phase is executed in isolation and credentials are only shared with trusted images. _(optional, default: "false")_
 - **`APP_IMAGE`**: The name of where to store the app image. _(REQUIRED)_
 - **`SOURCE_URL`**: A git repo url where the source code resides. _(REQUIRED)_
 - **`SOURCE_REFERENCE`**: The branch, tag or SHA to checkout. _(optional, default: "")_
 - **`SOURCE_SUBPATH`**: A subpath within checked out source where the source to build is located. _(optional, default: "")_
 - **`PROCESS_TYPE`**: The default process type to set on the image. _(optional, default: "web")_
 - **`RUN_IMAGE`**: The name of the run image to use (defaults to image specified in builder). _(optional, default: "")_
 - **`CACHE_IMAGE`**: The name of the persistent cache image. _(optional, default: "")_
 - **`USER_ID`**: The user ID of the builder image user. _(optional, default: "1000")_
 - **`GROUP_ID`**: The group ID of the builder image user. _(optional, default: "1000")_

## Builders

The following is only a subset of [builders](https://buildpacks.io/docs/concepts/components/builder/) available. These are the suggested builders from the Cloud Native Buildpacks projects.

 - **`gcr.io/buildpacks/builder:v1`**: Ubuntu 18 base image with buildpacks for .NET, Go, Java, Node.js, and Python
 - **`heroku/buildpacks:18`**
 - **`heroku/buildpacks:20`**
 - **`paketobuildpacks/builder:base`**: Ubuntu bionic base image with buildpacks for Java, .NET Core, NodeJS, Go, Ruby, NGINX and Procfile
 - **`paketobuildpacks/builder:full`**: Ubuntu bionic base image with buildpacks for Java, .NET Core, NodeJS, Go, PHP, Ruby, Apache HTTPD, NGINX and Procfile
 - **`paketobuildpacks/builder:tiny`**: Tiny base image (bionic build image, distroless-like run image) with buildpacks for Java Native Image and Go

[platform-api]: https://buildpacks.io/docs/reference/spec/platform-api/
