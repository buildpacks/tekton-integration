package main_test

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"testing"
	"text/template"
	"time"

	"github.com/onsi/gomega"
	"github.com/pkg/errors"
	"github.com/sclevine/spec"
	"github.com/sclevine/spec/report"
	"github.com/sirupsen/logrus"
	v12 "k8s.io/api/core/v1"
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	"sigs.k8s.io/kind/pkg/cluster"
	"sigs.k8s.io/kind/pkg/cluster/create"
)

func TestIntegration(t *testing.T) {
	spec.Run(t, "integration", testIntegration, spec.Report(report.Terminal{}))
}

const (
	clusterName           = "integration-test-cluster"
	registryContainerName = "integration-test-registry"
	appContainerName      = "integration-test-app"
	appRepoName           = "integration-test/app"
	defaultTaskConfig     = "https://raw.githubusercontent.com/tektoncd/catalog/master/buildpacks/buildpacks-v3.yaml"
)

func resolveTaskConfig() string {
	taskConfig := os.Getenv("TASK_CONFIG")
	if taskConfig == "" {
		taskConfig = defaultTaskConfig
	}

	return taskConfig
}

func testIntegration(t *testing.T, when spec.G, it spec.S) {
	var g *gomega.WithT
	it.Before(func() {
		g = gomega.NewWithT(t)
	})

	when("tekton is installed", func() {
		var (
			kindCtx       *cluster.Context
			k8sClient     *kubernetes.Clientset
			registryPort  int
			tmpDir        string
			err           error
			cleanUpDocker = func() {
				_ = exec.Command("docker", "rm", "-f", registryContainerName).Run()
				_ = exec.Command("docker", "rm", "-f", appContainerName).Run()
				if kindCtx != nil {
					_ = kindCtx.Delete()
				}
			}
		)

		it.Before(func() {
			t.Log("===> PREPARE")
			tmpDir, err = ioutil.TempDir("", "integration-test")
			g.Expect(err).To(gomega.BeNil())

			kindCtx = cluster.NewContext(clusterName)
			cleanUpDocker()

			t.Log("Starting registry...")
			registryPort, err = freePort()
			output, err := startContainer(registryContainerName, "registry:2", "-p", fmt.Sprintf("%d:5000", registryPort))
			t.Log(string(bytes.TrimSpace(output)))
			g.Expect(err).To(gomega.BeNil())

			t.Log("Creating k8s cluster...")
			logrus.SetOutput(ioutil.Discard)
			err = kindCtx.Create(
				create.WaitForReady(time.Minute * 1),
			)
			g.Expect(err).To(gomega.BeNil())

			t.Log("Configuring kubectl...")
			kubeConfigPath := kindCtx.KubeConfigPath()
			if kubeConfigPath == "" {
				t.Fatal("Kube Config path from kind is empty")
			}
			err = os.Setenv("KUBECONFIG", kubeConfigPath)
			g.Expect(err).To(gomega.BeNil())

			t.Log("Installing Tekton...")
			_, err = exec.Command("kubectl",
				"apply", "-f", "https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml",
			).CombinedOutput()
			g.Expect(err).To(gomega.BeNil())

			t.Log("Waiting for Tekton pods to be READY...")
			config, err := clientcmd.BuildConfigFromFlags("", kubeConfigPath)
			g.Expect(err).To(gomega.BeNil())
			k8sClient, err = kubernetes.NewForConfig(config)
			g.Expect(err).To(gomega.BeNil())
			waitForTekton(t, g, k8sClient)
		})

		it.After(func() {
			t.Log("===> CLEAN UP")
			if os.Getenv("SKIP_CLEANUP") == "true" {
				t.Logf(`==============
SKIPPING CLEANUP:
To manually clean up run 'kind delete cluster --name="%s"' 
or rerun tests without 'SKIP_CLEANUP=true' 

The temp dir is: %s
Output image: localhost:%d/%s
To use kubectl run: export KUBECONFIG="%s"
To list TaskRuns run: kubectl get taskruns
==============`,
					kindCtx.Name(),
					tmpDir,
					registryPort,
					appRepoName,
					kindCtx.KubeConfigPath(),
				)
				return
			}

			t.Log("Deleting temp dir...")
			if err := os.RemoveAll(tmpDir); err != nil {
				t.Errorf("Deleting temp dir %s", tmpDir)
			}

			t.Log("Cleaning up docker...")
			cleanUpDocker()
		})

		it("should install and build app", func() {
			t.Log("===> INSTALL")
			taskConfig := resolveTaskConfig()
			t.Logf("Installing 'buildpacks' TaskRun from: %s", taskConfig)
			output, err := exec.Command("kubectl", "create", "-f", taskConfig, ).CombinedOutput()
			t.Log(string(bytes.TrimSpace(output)))
			g.Expect(err).To(gomega.BeNil())

			t.Log("===> BUILD APP")
			t.Log("Finalizing build.yml...")
			ipAddress, err := resolveIPAddress()
			g.Expect(err).To(gomega.BeNil())
			templateContents, err := ioutil.ReadFile(filepath.Join("testdata", "taskrun.tmpl.yaml"))
			g.Expect(err).To(gomega.BeNil())
			taskRunFile, err := ioutil.TempFile(tmpDir, "taskrun.*.yml")
			g.Expect(err).To(gomega.BeNil())
			err = template.Must(template.New("").Parse(string(templateContents))).Execute(taskRunFile,
				map[string]string{
					"ImageName": fmt.Sprintf("%s:%d/%s", ipAddress, registryPort, appRepoName),
				})
			g.Expect(err).To(gomega.BeNil())

			t.Logf("Creating taskrun from: %s", taskRunFile.Name())
			output, err = exec.Command("kubectl", "create", "-f", taskRunFile.Name(), ).CombinedOutput()
			t.Log(string(bytes.TrimSpace(output)))
			g.Expect(err).To(gomega.BeNil())

			t.Log("Waiting for taskrun to complete...")
			waitForTaskRun(t, g, k8sClient)

			t.Log("===> RUN APP")
			appPort, err := freePort()
			g.Expect(err).To(gomega.BeNil())

			imageName := fmt.Sprintf("localhost:%d/%s", registryPort, appRepoName)
			t.Logf("Running app '%s' on port %d", imageName, appPort)

			output, err = startContainer(appContainerName, imageName, "-p", fmt.Sprintf("%d:8080", appPort))
			t.Log(string(bytes.TrimSpace(output)))
			g.Expect(err).To(gomega.BeNil())

			t.Logf("Checking app...")
			g.Eventually(func() int {
				resp, err := http.Get(fmt.Sprintf("http://localhost:%d", appPort))
				if err != nil {
					return 0
				}
				return resp.StatusCode
			}, 20*time.Second).Should(gomega.Equal(200))
		})
	})
}

func waitForTekton(t *testing.T, g *gomega.WithT, clientset *kubernetes.Clientset) {
	podsClient := clientset.CoreV1().Pods("tekton-pipelines")
	g.Eventually(func() bool {
		podsList, err := podsClient.List(v1.ListOptions{})
		g.Expect(err).To(gomega.BeNil())

		pods := podsList.Items
		if len(pods) < 1 {
			return false
		}
		for _, pod := range pods {
			if pod.Status.Phase != v12.PodRunning {
				return false
			}
		}

		return true
	}, 40*time.Second, 2*time.Second).Should(gomega.BeTrue())
}

func waitForTaskRun(t *testing.T, g *gomega.WithT, k8sClient *kubernetes.Clientset) {
	podsClient := k8sClient.CoreV1().Pods("default")
	g.Eventually(func() bool {
		podsList, err := podsClient.List(v1.ListOptions{LabelSelector: `tekton.dev/taskRun=test-run`})
		g.Expect(err).To(gomega.BeNil())

		pods := podsList.Items
		if len(pods) < 1 {
			return false
		}
		for _, pod := range pods {
			if pod.Status.Phase != v12.PodSucceeded {
				return false
			}
		}

		return true
	}, 4*time.Minute, 2*time.Second).Should(gomega.BeTrue())
}

func resolveIPAddress() (string, error) {
	addrs, err := net.InterfaceAddrs()
	if err != nil {
		return "", err
	}

	for _, address := range addrs {
		if ipnet, ok := address.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				return ipnet.IP.String(), nil
			}
		}
	}

	return "", errors.New("unable to resolve IP address")
}

func startContainer(containerName, imageName string, opts ...string) ([]byte, error) {
	args := []string{"run", "-d", "--rm", "--name", containerName,}
	args = append(args, opts...)
	args = append(args, imageName)

	return exec.Command("docker", args...).CombinedOutput()
}

func freePort() (int, error) {
	l, err := net.Listen("tcp", ":0")
	if err != nil {
		return 0, err
	}

	address, ok := l.Addr().(*net.TCPAddr)
	if !ok {
		return 0, errors.Errorf("unknown address type: %+v", address)
	}

	if err := l.Close(); err != nil {
		return 0, err
	}

	return address.Port, nil
}
