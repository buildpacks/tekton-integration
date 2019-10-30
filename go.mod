module github.com/buildpack/tekton-integration/test

go 1.13

require (
	github.com/imdario/mergo v0.3.8 // indirect
	github.com/onsi/gomega v1.5.0
	github.com/pkg/errors v0.8.1
	github.com/sclevine/spec v1.3.0
	github.com/sirupsen/logrus v1.4.1
	golang.org/x/oauth2 v0.0.0-20190604053449-0f29369cfe45 // indirect
	golang.org/x/time v0.0.0-20191024005414-555d28b269f0 // indirect
	k8s.io/api v0.0.0-20190409021203-6e4e0e4f393b
	k8s.io/apimachinery v0.0.0-20190404173353-6a84e37a896d
	k8s.io/client-go v11.0.0+incompatible
	k8s.io/utils v0.0.0-20191010214722-8d271d903fe4 // indirect
	sigs.k8s.io/kind v0.5.1
)
