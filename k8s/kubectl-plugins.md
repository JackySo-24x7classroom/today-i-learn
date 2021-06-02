# kubectl plugins tutorial


<!-- vim-markdown-toc GFM -->

- [Shell script to run plugin](#shell-script-to-run-plugin)
- [Deploy script into local kubectl plugin](#deploy-script-into-local-kubectl-plugin)
- [Package homemade plugins into krew manageable](#package-homemade-plugins-into-krew-manageable)
	- [Prepare kubectl plugins](#prepare-kubectl-plugins)
	- [Install plugins](#install-plugins)
	- [krew management tour](#krew-management-tour)
- [References](#references)

<!-- vim-markdown-toc -->

## Shell script to run plugin

> Shell script to select automation with kubectl work in Makefiles and show its usages and variables

```bash
#! /bin/env bash

MF=${1:-"${HOME}/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/useful-resources/devops/makefile"}

LIST=`(cd $MF; ag kubectl -G Makefile -l)`

PS3="Input your choice: "
select opt in `echo "${LIST}" | grep -v .md | sed ':a;N;$!ba;s/\n/ /g'`
	do
	echo "Run help in ${opt}"; (cd ${MF}; make -sf ${opt} help 2>/dev/null; make -sf ${opt} var 2>/dev/null); break
	done
```

> Run script

```bash
$  /tmp/kubectl-makefile
 1) Makefile-gcloud
 2) Makefile-minikube
 3) Makefile-obs-metrics
 4) Makefile-cicd-tekton-github
 5) Makefile-kind
 6) Makefile-traefik-ingress
 7) Makefile-k8s-obs-kubevious
 8) Makefile-k8s-toolkits
 9) Makefile-k8s-kubectl
10) Makefile-k8s-obs-jaeger
11) Makefile-k8s-opa
12) Makefile-k8s-k3d
13) Makefile-k8s-certmanager
14) Makefile-k8s-chaostoolkits
15) Makefile-k8s-source
16) Makefile-k8s-kops
17) Makefile-k8s-security
18) Makefile-k8s-linkderd
19) Makefile-kubeflow
20) Makefile-nginx-ingress
21) Makefile-serverless-platform
22) Makefile-helm
23) Makefile-k8s-operator
24) Makefile-k8s-context
25) Makefile-scan-devops-pipeline
26) Makefile-k8s-observability
27) Makefile-Kubernetic
28) Makefile-k8s-gitops
29) Makefile-k8s-secret
30) Makefile-k8s-polaris
31) Makefile-tekton
32) Makefile-crossplane
33) Makefile-k8s-obs-node-problem
34) Makefile-k8s-istio
35) Makefile-k8s-backup-restore
36) Makefile-gke-externaldns
37) Makefile-k8s-ClusterApi
38) toolkits/build-harness/modules/helm/Makefile
39) toolkits/build-harness/modules/helmfile/Makefile
40) toolkits/build-harness/modules/packages/Makefile
41) toolkits/k8s/k8s-Makefile
42) toolkits/k8s/kube-mgmt/vendor/golang.org/x/net/http2/h2demo/Makefile
43) toolkits/k8s/kube-mgmt/opa-Makefile
44) toolkits/k8s/kube-mgmt/Makefile
45) toolkits/k8s/context-Makefile
46) toolkits/k8s/moodle-Makefile
47) toolkits/k8s/api-Makefile
48) toolkits/k8s/rancher-Makefile
49) toolkits/k8s/obs-Makefile
50) toolkits/k8s/Makefile
51) toolkits/k8s/kubeaudit/Makefile
52) toolkits/k8s/operator/memcached-operator/Makefile
53) toolkits/k8s/operator/Makefile
54) toolkits/k8s/ops-kube-db-operator/Makefile
55) toolkits/ci/tekton/Makefile
56) Makefile-k8s-istioinaction
57) Makefile-shipa.io
58) Makefile-k8s-memcached-operator
59) Makefile-k8s-cluster
60) Makefile-k8s-knative
61) Makefile-k8s-moodle
Input your choice: 2
Run help in Makefile-minikube

 Choose a command run:

ohelp                                    Help page
install-minikube                         Intall minikube into /usr/local/bin
configure-memory                         Configure 4G memory ⚠️  These changes will take effect upon a minikube delete and then a minikube start
configure-cpu                            Configure 2 CPU ⚠️  These changes will take effect upon a minikube delete and then a minikube start
storage                                  Configure storage - Set the storage class for Persistent Volumes
start-minikube                           Start minikube with docker driver, run status and show running pods in all namespaces
status-minikube                          Check minikube running status
start-minikube-dashboard                 Start minikube dashboard
minikube-ingress                         Enable ingress addon in minikube and list all ingress
stop-minikube                            Stop minikube and show status
node-shell                               Shell in k8s cluster node $(node)
pod-shell                                Shell in k8s cluster pod $(pod)
argocd-initial-admin-secret              Show ArgoCD initial admin secret
port-forward-argocd-server               Setup Port forwarding to access ArgoCD server https://localhost:8080

api                                      $(shell kubectl api-resources --no-headers | awk '{ print $$1 }')
```

## Deploy script into local kubectl plugin

> Copy script into local kubectl plugin location `$HOME/.krew/bin`

```bash
$  kubectl plugin list
The following compatible plugins are available:

/home1/jso/.krew/bin/kubectl-krew
/home1/jso/.krew/bin/kubectl-makefile
/home1/jso/.krew/bin/kubectl-pod_logs
/home1/jso/.krew/bin/kubectl-sniff
```

> Test run kubectl <plugin>

```bash
$  kubectl makefile
 1) Makefile-gcloud							  32) Makefile-crossplane
 2) Makefile-minikube							  33) Makefile-k8s-obs-node-problem
 3) Makefile-obs-metrics						  34) Makefile-k8s-istio
 4) Makefile-cicd-tekton-github						  35) Makefile-k8s-backup-restore
 5) Makefile-kind							  36) Makefile-gke-externaldns
 6) Makefile-traefik-ingress						  37) Makefile-k8s-ClusterApi
 7) Makefile-k8s-obs-kubevious						  38) toolkits/build-harness/modules/helm/Makefile
 8) Makefile-k8s-toolkits						  39) toolkits/build-harness/modules/helmfile/Makefile
 9) Makefile-k8s-kubectl						  40) toolkits/build-harness/modules/packages/Makefile
10) Makefile-k8s-obs-jaeger						  41) toolkits/k8s/k8s-Makefile
11) Makefile-k8s-opa							  42) toolkits/k8s/kube-mgmt/vendor/golang.org/x/net/http2/h2demo/Makefile
12) Makefile-k8s-k3d							  43) toolkits/k8s/kube-mgmt/opa-Makefile
13) Makefile-k8s-certmanager						  44) toolkits/k8s/kube-mgmt/Makefile
14) Makefile-k8s-chaostoolkits						  45) toolkits/k8s/context-Makefile
15) Makefile-k8s-source							  46) toolkits/k8s/moodle-Makefile
16) Makefile-k8s-kops							  47) toolkits/k8s/api-Makefile
17) Makefile-k8s-security						  48) toolkits/k8s/rancher-Makefile
18) Makefile-k8s-linkderd						  49) toolkits/k8s/obs-Makefile
19) Makefile-kubeflow							  50) toolkits/k8s/Makefile
20) Makefile-nginx-ingress						  51) toolkits/k8s/kubeaudit/Makefile
21) Makefile-serverless-platform					  52) toolkits/k8s/operator/memcached-operator/Makefile
22) Makefile-helm							  53) toolkits/k8s/operator/Makefile
23) Makefile-k8s-operator						  54) toolkits/k8s/ops-kube-db-operator/Makefile
24) Makefile-k8s-context						  55) toolkits/ci/tekton/Makefile
25) Makefile-scan-devops-pipeline					  56) Makefile-k8s-istioinaction
26) Makefile-k8s-observability						  57) Makefile-shipa.io
27) Makefile-Kubernetic							  58) Makefile-k8s-memcached-operator
28) Makefile-k8s-gitops							  59) Makefile-k8s-cluster
29) Makefile-k8s-secret							  60) Makefile-k8s-knative
30) Makefile-k8s-polaris						  61) Makefile-k8s-moodle
31) Makefile-tekton
Input your choice: 2
Run help in Makefile-minikube

 Choose a command run:

ohelp                                    Help page
install-minikube                         Intall minikube into /usr/local/bin
configure-memory                         Configure 4G memory ⚠️  These changes will take effect upon a minikube delete and then a minikube start
configure-cpu                            Configure 2 CPU ⚠️  These changes will take effect upon a minikube delete and then a minikube start
storage                                  Configure storage - Set the storage class for Persistent Volumes
start-minikube                           Start minikube with docker driver, run status and show running pods in all namespaces
status-minikube                          Check minikube running status
start-minikube-dashboard                 Start minikube dashboard
minikube-ingress                         Enable ingress addon in minikube and list all ingress
stop-minikube                            Stop minikube and show status
node-shell                               Shell in k8s cluster node $(node)
pod-shell                                Shell in k8s cluster pod $(pod)
argocd-initial-admin-secret              Show ArgoCD initial admin secret
port-forward-argocd-server               Setup Port forwarding to access ArgoCD server https://localhost:8080

api                                      $(shell kubectl api-resources --no-headers | awk '{ print $$1 }')
```

`Note`: Exactly same result as bare script running

## Package homemade plugins into krew manageable

- [ ] Prepare kubectl plugin
  - [ ] `plugin` container folder
    - [ ] `plugin` program
    - [ ] `plugin` documentation
- [ ] Push to github repository
- [ ] Prepare for github archive zip
  - [ ] Use `git tag` to label github repo with plugin codes
  - [ ] Push with tag to generate your convention of archive file for downloading
  - [ ] Validate github archive zip
    - [ ] Download zip
    - [ ] Compute its checksum
    - [ ] Analyze plugin's folder/file structure
- [ ] Prepare for plugin definition
  - [ ] `<plugin>.yaml`
    - [ ] sha checksum
    - [ ] download url
    - [ ] installing structure
    - [ ] version
    - [ ] description
- [ ] Upload plugin definition and configuration to github repository for krew index
- [ ] Add customized index to your krew configuration
- [ ] Manage plugin from customized krew index
  - [ ] Search plugins from indexes
  - [ ] Install plugins from updated indexes
  - [ ] List installed plugins
  - [ ] Run plugin

### Prepare kubectl plugins

```bash
└── makefile
    ├── makefile.sh
    └── plugin.yaml

1 directory, 2 files
```

> Commit change and push into github repository

> Use `git tag` to label github repository for archive zip download use

```bash
$  git tag -a "kubectl-plugin-1.0.1" -m "Tag 1.0.1"

$  git tag
kubectl-plugin-1.0.0
kubectl-plugin-1.0.1

$  gitp push origin --tags
Enumerating objects: 11, done.
Counting objects: 100% (11/11), done.
Compressing objects: 100% (7/7), done.
Writing objects: 100% (8/8), 1.86 KiB | 1.86 MiB/s, done.
Total 8 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To github.com:JackySo-24x7classroom/public-resources.git
 * [new tag]         kubectl-plugin-1.0.1 -> kubectl-plugin-1.0.1
```

> Download github repository archive zip file and check for checksum

```bash
$  wget https://github.com/JackySo-24x7classroom/public-resources/archive/kubectl-plugin-1.0.1.zip
--2021-06-02 17:28:20--  https://github.com/JackySo-24x7classroom/public-resources/archive/kubectl-plugin-1.0.1.zip
Resolving github.com (github.com)... 13.236.229.21
Connecting to github.com (github.com)|13.236.229.21|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://codeload.github.com/JackySo-24x7classroom/public-resources/zip/kubectl-plugin-1.0.1 [following]
--2021-06-02 17:28:21--  https://codeload.github.com/JackySo-24x7classroom/public-resources/zip/kubectl-plugin-1.0.1
Resolving codeload.github.com (codeload.github.com)... 3.105.64.153
Connecting to codeload.github.com (codeload.github.com)|3.105.64.153|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [application/zip]
Saving to: ‘kubectl-plugin-1.0.1.zip’

kubectl-plugin-1.0.1.zip               [  <=>                                                            ] 278.47K  1.34MB/s    in 0.2s

2021-06-02 17:28:22 (1.34 MB/s) - ‘kubectl-plugin-1.0.1.zip’ saved [285152]

$  zip -sf kubectl-plugin-1.0.1.zip
Archive contains:
  public-resources-kubectl-plugin-1.0.1/
  public-resources-kubectl-plugin-1.0.1/README.md
  public-resources-kubectl-plugin-1.0.1/makefile/
  public-resources-kubectl-plugin-1.0.1/makefile/makefile.sh
  public-resources-kubectl-plugin-1.0.1/makefile/plugin.yaml
  public-resources-kubectl-plugin-1.0.1/plugins/
  public-resources-kubectl-plugin-1.0.1/plugins/makefile.yaml
Total 20 entries (399257 bytes)

$  sha256sum kubectl-plugin-1.0.1.zip
08693adff2d25edc220ec8bf588e1586bec4dadddeced782807fb170a606112e  kubectl-plugin-1.0.1.zip
```

> Construct plugin definition to prepare for krew customized index   

```bash
├── plugins
│   └── makefile.yaml
└── README.md
```

`makefile.yaml`

```yaml
apiVersion: krew.googlecontainertools.github.com/v1alpha2
kind: Plugin
metadata:
  name: makefile
spec:
  platforms:
  - sha256: 08693adff2d25edc220ec8bf588e1586bec4dadddeced782807fb170a606112e
    uri: https://github.com/JackySo-24x7classroom/public-resources/archives/kubectl-plugin-1.0.1.zip
    bin: makefile.sh
    files:
    - from: "/*/makefile/*"
      to: "."
    selector:
      matchExpressions:
      - {key: os, operator: In, values: [linux]}
  version: "v1.0.1"
  homepage: https://github.com/JackySo-24x7classroom/public-resources
  shortDescription: Select Makefiles with kubectl work and display its run options and variables
```

### Install plugins

> Use krew to install `makefile` from homemade github and index

```bash
$  kubectl plugin list
The following compatible plugins are available:

/home1/jso/.krew/bin/kubectl-krew
/home1/jso/.krew/bin/kubectl-pod_logs
/home1/jso/.krew/bin/kubectl-sniff

$  kubectl krew install homemade/makefile
Updated the local copy of plugin index.
Updated the local copy of plugin index "homemade".
Installing plugin: makefile
Installed plugin: makefile
\
 | Use this plugin:
 | 	kubectl makefile
 | Documentation:
 | 	https://github.com/JackySo-24x7classroom/public-resources
/

$  kubectl plugin list
The following compatible plugins are available:

/home1/jso/.krew/bin/kubectl-krew
/home1/jso/.krew/bin/kubectl-makefile
/home1/jso/.krew/bin/kubectl-pod_logs
/home1/jso/.krew/bin/kubectl-sniff

$  tree ~/.krew/index
/home1/jso/.krew/index
├── default
│   ├── code-of-conduct.md
│   ├── CONTRIBUTING.md
│   ├── LICENSE
│   ├── OWNERS
│   ├── OWNERS_ALIASES
│   ├── plugins
│   │   ├── access-matrix.yaml
│   │   ├── advise-psp.yaml
│   │   ├── allctx.yaml
│   │   ├── apparmor-manager.yaml
│   │   ├── assert.yaml
│   │   ├── auth-proxy.yaml
│   │   ├── azad-proxy.yaml
│   │   ├── bd-xray.yaml
│   │   ├── bulk-action.yaml
│   │   ├── ca-cert.yaml
│   │   ├── capture.yaml
│   │   ├── cert-manager.yaml
│   │   ├── change-ns.yaml
│   │   ├── cilium.yaml
│   │   ├── cluster-group.yaml
│   │   ├── config-cleanup.yaml
│   │   ├── config-registry.yaml
│   │   ├── cost.yaml
│   │   ├── creyaml.yaml
│   │   ├── ctx.yaml
│   │   ├── custom-cols.yaml
│   │   ├── cyclonus.yaml
│   │   ├── datadog.yaml
│   │   ├── debug-shell.yaml
│   │   ├── deprecations.yaml
│   │   ├── df-pv.yaml
│   │   ├── direct-csi.yaml
│   │   ├── doctor.yaml
│   │   ├── duck.yaml
│   │   ├── edit-status.yaml
│   │   ├── eksporter.yaml
│   │   ├── emit-event.yaml
│   │   ├── evict-pod.yaml
│   │   ├── example.yaml
│   │   ├── exec-as.yaml
│   │   ├── exec-cronjob.yaml
│   │   ├── fields.yaml
│   │   ├── flame.yaml
│   │   ├── fleet.yaml
│   │   ├── flyte.yaml
│   │   ├── fuzzy.yaml
│   │   ├── gadget.yaml
│   │   ├── get-all.yaml
│   │   ├── gke-credentials.yaml
│   │   ├── gopass.yaml
│   │   ├── graph.yaml
│   │   ├── grep.yaml
│   │   ├── gs.yaml
│   │   ├── hlf.yaml
│   │   ├── hns.yaml
│   │   ├── iexec.yaml
│   │   ├── images.yaml
│   │   ├── ingress-nginx.yaml
│   │   ├── ipick.yaml
│   │   ├── janitor.yaml
│   │   ├── konfig.yaml
│   │   ├── krew.yaml
│   │   ├── kubesec-scan.yaml
│   │   ├── kudo.yaml
│   │   ├── kuttl.yaml
│   │   ├── kyverno.yaml
│   │   ├── match-name.yaml
│   │   ├── mc.yaml
│   │   ├── minio.yaml
│   │   ├── modify-secret.yaml
│   │   ├── mtail.yaml
│   │   ├── multinet.yaml
│   │   ├── neat.yaml
│   │   ├── net-forward.yaml
│   │   ├── node-admin.yaml
│   │   ├── node-restart.yaml
│   │   ├── node-shell.yaml
│   │   ├── np-viewer.yaml
│   │   ├── ns.yaml
│   │   ├── oidc-login.yaml
│   │   ├── open-svc.yaml
│   │   ├── operator.yaml
│   │   ├── oulogin.yaml
│   │   ├── outdated.yaml
│   │   ├── passman.yaml
│   │   ├── pexec.yaml
│   │   ├── pod-dive.yaml
│   │   ├── podevents.yaml
│   │   ├── pod-inspect.yaml
│   │   ├── pod-lens.yaml
│   │   ├── pod-logs.yaml
│   │   ├── pod-shell.yaml
│   │   ├── popeye.yaml
│   │   ├── preflight.yaml
│   │   ├── profefe.yaml
│   │   ├── promdump.yaml
│   │   ├── prompt.yaml
│   │   ├── prune-unused.yaml
│   │   ├── psp-util.yaml
│   │   ├── rabbitmq.yaml
│   │   ├── rbac-lookup.yaml
│   │   ├── rbac-view.yaml
│   │   ├── reap.yaml
│   │   ├── reliably.yaml
│   │   ├── resource-capacity.yaml
│   │   ├── resource-snapshot.yaml
│   │   ├── resource-versions.yaml
│   │   ├── restart.yaml
│   │   ├── rm-standalone-pods.yaml
│   │   ├── rolesum.yaml
│   │   ├── roll.yaml
│   │   ├── schemahero.yaml
│   │   ├── score.yaml
│   │   ├── service-tree.yaml
│   │   ├── shovel.yaml
│   │   ├── sick-pods.yaml
│   │   ├── skew.yaml
│   │   ├── snap.yaml
│   │   ├── sniff.yaml
│   │   ├── socks5-proxy.yaml
│   │   ├── sort-manifests.yaml
│   │   ├── split-yaml.yaml
│   │   ├── spy.yaml
│   │   ├── sql.yaml
│   │   ├── sshd.yaml
│   │   ├── ssh-jump.yaml
│   │   ├── ssm-secret.yaml
│   │   ├── starboard.yaml
│   │   ├── status.yaml
│   │   ├── sudo.yaml
│   │   ├── support-bundle.yaml
│   │   ├── tail.yaml
│   │   ├── tap.yaml
│   │   ├── tmux-exec.yaml
│   │   ├── topology.yaml
│   │   ├── trace.yaml
│   │   ├── tree.yaml
│   │   ├── tunnel.yaml
│   │   ├── unused-volumes.yaml
│   │   ├── vela.yaml
│   │   ├── view-allocations.yaml
│   │   ├── view-cert.yaml
│   │   ├── view-secret.yaml
│   │   ├── view-serviceaccount-kubeconfig.yaml
│   │   ├── view-utilization.yaml
│   │   ├── view-webhook.yaml
│   │   ├── virt.yaml
│   │   ├── warp.yaml
│   │   ├── whisper-secret.yaml
│   │   ├── whoami.yaml
│   │   └── who-can.yaml
│   ├── plugins.md
│   ├── README.md
│   └── SECURITY_CONTACTS
└── homemade
    ├── makefile
    │   ├── makefile.sh
    │   └── plugin.yaml
    ├── notebooks
    │   ├── Evaluating-Binary-Classification-Lab.ipynb
    │   ├── Evaluating-Model-Predictions-for-Regression-Models.ipynb
    │   ├── images
    │   │   ├── confirm_delete.png
    │   │   ├── MLvsDL.png
    │   │   ├── model_running.png
    │   │   ├── project_delete.png
    │   │   ├── skyscraper.jpeg
    │   │   ├── suburb.jpeg
    │   │   └── use_model.png
    │   ├── Machine-Learning-Custom-Models.ipynb
    │   └── Testing-Your-Models-in-the-Real-World.ipynb
    ├── plugins
    │   └── makefile.yaml
    └── README.md

7 directories, 169 files

$  tree ~/.krew/receipts/
/home1/jso/.krew/receipts/
├── krew.yaml
├── makefile.yaml
├── pod-logs.yaml
└── sniff.yaml

0 directories, 4 files

$  tree ~/.krew/bin
/home1/jso/.krew/bin
├── kubectl-krew -> /home1/jso/.krew/store/krew/v0.4.1/krew
├── kubectl-makefile -> /home1/jso/.krew/store/makefile/v1.0.1/makefile.sh
├── kubectl-pod_logs -> /home1/jso/.krew/store/pod-logs/v1.0.1/pod-logs.sh
└── kubectl-sniff -> /home1/jso/.krew/store/sniff/v1.6.0/kubectl-sniff

0 directories, 4 files

$ cat /home1/jso/.krew/store/makefile/v1.0.1/makefile.sh

#! /bin/env bash

MF=${1:-"${HOME}/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/useful-resources/devops/makefile"}
MK=${2:-"Makefile"}
LIST=`(cd $MF; ag kubectl -G Makefile -l)`

PS3="Input your choice: "
select opt in `echo "${LIST}" | grep -v .md | sed ':a;N;$!ba;s/\n/ /g'`
	do
	echo "Run help in ${opt}"; (cd ${MF}; make -sf ${opt} help 2>/dev/null; make -sf ${opt} var 2>/dev/null); break
	done

$  kubectl makefile
 1) Makefile-gcloud							  32) Makefile-crossplane
 2) Makefile-minikube							  33) Makefile-k8s-obs-node-problem
 3) Makefile-obs-metrics						  34) Makefile-k8s-istio
 4) Makefile-cicd-tekton-github						  35) Makefile-k8s-backup-restore
 5) Makefile-kind							  36) Makefile-gke-externaldns
 6) Makefile-traefik-ingress						  37) Makefile-k8s-ClusterApi
 7) Makefile-k8s-obs-kubevious						  38) toolkits/build-harness/modules/helm/Makefile
 8) Makefile-k8s-toolkits						  39) toolkits/build-harness/modules/helmfile/Makefile
 9) Makefile-k8s-kubectl						  40) toolkits/build-harness/modules/packages/Makefile
10) Makefile-k8s-obs-jaeger						  41) toolkits/k8s/k8s-Makefile
11) Makefile-k8s-opa							  42) toolkits/k8s/kube-mgmt/vendor/golang.org/x/net/http2/h2demo/Makefile
12) Makefile-k8s-k3d							  43) toolkits/k8s/kube-mgmt/opa-Makefile
13) Makefile-k8s-certmanager						  44) toolkits/k8s/kube-mgmt/Makefile
14) Makefile-k8s-chaostoolkits						  45) toolkits/k8s/context-Makefile
15) Makefile-k8s-source							  46) toolkits/k8s/moodle-Makefile
16) Makefile-k8s-kops							  47) toolkits/k8s/api-Makefile
17) Makefile-k8s-security						  48) toolkits/k8s/rancher-Makefile
18) Makefile-k8s-linkderd						  49) toolkits/k8s/obs-Makefile
19) Makefile-kubeflow							  50) toolkits/k8s/Makefile
20) Makefile-nginx-ingress						  51) toolkits/k8s/kubeaudit/Makefile
21) Makefile-serverless-platform					  52) toolkits/k8s/operator/memcached-operator/Makefile
22) Makefile-helm							  53) toolkits/k8s/operator/Makefile
23) Makefile-k8s-operator						  54) toolkits/k8s/ops-kube-db-operator/Makefile
24) Makefile-k8s-context						  55) toolkits/ci/tekton/Makefile
25) Makefile-scan-devops-pipeline					  56) Makefile-k8s-istioinaction
26) Makefile-k8s-observability						  57) Makefile-shipa.io
27) Makefile-Kubernetic							  58) Makefile-k8s-memcached-operator
28) Makefile-k8s-gitops							  59) Makefile-k8s-cluster
29) Makefile-k8s-secret							  60) Makefile-k8s-knative
30) Makefile-k8s-polaris						  61) Makefile-k8s-moodle
31) Makefile-tekton
Input your choice: 1
Run help in Makefile-gcloud

 Choose a command run:

install-howto                            Howto install Google Cloud SDK
0-install-ubuntu                         Install Google Cloud SDK onto Ubuntu/Debian
0-install-redhat                         Install Google Cloud SDK onto Redhat/CentOS/Fedora
0-install-linux                          Install 64 bit Google Cloud SDK onto Linux
0-version                                Check version of install SDK gcloud utility
1-init                                   Run gcloud init (skip dignostic) and logon
2-setup-preferences                      Configure gcloud preferences zone and region
2-login                                  Login
3a-create-cluster                        Create a cluster and get the credentials for kubectl
3b-create-cluster                        Create a GKE Cluster (overrides preferences)
cleanup                                  Delete GKE cluster
utl-switch-gke                           Switch to using the GKE cluster
utl-server-config                        Get Cluster Config
utl-config-account                       Get Config info - account
utl-list-disks                           List disks in zone $(ZONE)
utl-remove-disk                          Remove unused disks - avoid reaching the quota
utl-ssh-vm                               SSH into VM

CLUSTER                                  kubernetic
NODE                                     1
PROJECT_ID                               cal-877-69f442c33d57
REGION                                   europe-west1
VM                                       calab-notebook
ZONE                                     europe-west1-b

$  kubectl krew update
Updated the local copy of plugin index.
Updated the local copy of plugin index "homemade".

$  kubectl krew list
PLUGIN             VERSION
homemade/makefile  v1.0.1
krew               v0.4.1
pod-logs           v1.0.1
sniff              v1.6.0
```

> Update `makefile` plugin and push into github repository

`makefile.yaml`

```json
apiVersion: krew.googlecontainertools.github.com/v1alpha2
kind: Plugin
metadata:
  name: makefile
spec:
  platforms:
  - sha256: 08693adff2d25edc220ec8bf588e1586bec4dadddeced782807fb170a606112e
    uri: https://github.com/JackySo-24x7classroom/public-resources/archive/kubectl-plugin-1.0.1.zip
    bin: makefile.sh
    files:
    - from: "/*/makefile/*"
      to: "."
    selector:
      matchExpressions:
      - {key: os, operator: In, values: [linux]}
  version: "v1.1.1"
  homepage: https://github.com/JackySo-24x7classroom/public-resources
  shortDescription: Select Makefiles with kubectl work and display its run options and variables
```

> Deploy updated `makefile` plugin

```bash
$  kubectl krew list
PLUGIN             VERSION
homemade/makefile  v1.0.1
krew               v0.4.1
pod-logs           v1.0.1
sniff              v1.6.0

$  kubectl krew update
Updated the local copy of plugin index.
Updated the local copy of plugin index "homemade".
  Upgrades available for installed plugins:
    * homemade/makefile v1.0.1 -> v1.1.1

$  kubectl krew list
PLUGIN             VERSION
homemade/makefile  v1.0.1
krew               v0.4.1
pod-logs           v1.0.1
sniff              v1.6.0

$  kubectl krew update homemade/makefile
Updated the local copy of plugin index.
Updated the local copy of plugin index "homemade".

$  kubectl krew list
PLUGIN             VERSION
homemade/makefile  v1.0.1
krew               v0.4.1
pod-logs           v1.0.1
sniff              v1.6.0

$  kubectl krew upgrade
Updated the local copy of plugin index.
Updated the local copy of plugin index "homemade".
Upgrading plugin: krew
Skipping plugin krew, it is already on the newest version
Upgrading plugin: homemade/makefile
Upgraded plugin: homemade/makefile
Upgrading plugin: pod-logs
Skipping plugin pod-logs, it is already on the newest version
Upgrading plugin: sniff
Skipping plugin sniff, it is already on the newest version

$  kubectl krew list
PLUGIN             VERSION
homemade/makefile  v1.1.1
krew               v0.4.1
pod-logs           v1.0.1
sniff              v1.6.0
```

`Note`: Use krew `upgrade` option to redeploy new version v1.1.1 

### krew management tour

> Familiar with krew 

```bash
$  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

$  kubectl krew search

NAME                            DESCRIPTION                                         INSTALLED
access-matrix                   Show an RBAC access matrix for server resources     no
advise-psp                      Suggests PodSecurityPolicies for cluster.           no
allctx                          Run commands on contexts in your kubeconfig         no
apparmor-manager                Manage AppArmor profiles for cluster.               no
auth-proxy                      Authentication proxy to a pod or service            no
bd-xray                         Run Black Duck Image Scans                          no
bulk-action                     Do bulk actions on Kubernetes resources.            no
ca-cert                         Print the PEM CA certificate of the current clu...  no
capture                         Triggers a Sysdig capture to troubleshoot the r...  no
cert-manager                    Manage cert-manager resources inside your cluster   no
change-ns                       View or change the current namespace via kubectl.   no
cilium                          Easily interact with Cilium agents.                 no
cluster-group                   Exec commands across a group of contexts.           no
config-cleanup                  Automatically clean up your kubeconfig              no
config-registry                 Switch between registered kubeconfigs               no
creyaml                         Generate custom resource YAML manifest              no
cssh                            SSH into Kubernetes nodes                           no
ctx                             Switch between contexts in your kubeconfig          no
custom-cols                     A "kubectl get" replacement with customizable c...  no
datadog                         Manage the Datadog Operator                         no
debug                           Attach ephemeral debug container to running pod     no
debug-shell                     Create pod with interactive kube-shell.             no
deprecations                    Checks for deprecated objects in a cluster          no
df-pv                           Show disk usage (like unix df) for persistent v...  no
doctor                          Scans your cluster and reports anomalies.           no
duck                            List custom resources with ducktype support         no
edit-status                     Edit /status subresources of CRs                    no
eksporter                       Export resources and removes a pre-defined set ...  no
emit-event                      Emit Kubernetes Events for the requested object     no
evict-pod                       Evicts the given pod                                no
example                         Prints out example manifest YAMLs                   no
exec-as                         Like kubectl exec, but offers a `user` flag to ...  no
exec-cronjob                    Run a CronJob immediately as Job                    no
fields                          Grep resources hierarchy by field name              no
flame                           Generate CPU flame graphs from pods                 no
fleet                           Shows config and resources of a fleet of clusters   no
fuzzy                           Fuzzy and partial string search for kubectl         no
gadget                          Gadgets for debugging and introspecting apps        no
get-all                         Like `kubectl get all` but _really_ everything      no
gke-credentials                 Fetch credentials for GKE clusters                  no
gopass                          Imports secrets from gopass                         no
graph                           Visualize Kubernetes resources and relationships.   no
grep                            Filter Kubernetes resources by matching their n...  no
gs                              Handle custom resources with Giant Swarm            no
hlf                             Deploy and manage Hyperledger Fabric components     no
hns                             Manage hierarchical namespaces (part of HNC)        no
iexec                           Interactive selection tool for `kubectl exec`       no
images                          Show container images used in the cluster.          no
ingress-nginx                   Interact with ingress-nginx                         no
ipick                           A kubectl wrapper for interactive resource sele...  no
janitor                         Lists objects in a problematic state                no
konfig                          Merge, split or import kubeconfig files             no
krew                            Package manager for kubectl plugins.                yes
kubesec-scan                    Scan Kubernetes resources with kubesec.io.          no
kudo                            Declaratively build, install, and run operators...  no
kuttl                           Declaratively run and test operators                no
kyverno                         Kyverno is a policy engine for kubernetes           no
match-name                      Match names of pods and other API objects           no
minio                           Deploy and manage MinIO Operator and Tenant(s)      no
modify-secret                   modify secret with implicit base64 translations     no
mtail                           Tail logs from multiple pods matching label sel...  no
neat                            Remove clutter from Kubernetes manifests to mak...  no
net-forward                     Proxy to arbitrary TCP services on a cluster ne...  no
node-admin                      List nodes and run privileged pod with chroot       no
node-restart                    Restart cluster nodes sequentially and gracefully   no
node-shell                      Spawn a root shell on a node via kubectl            no
np-viewer                       Network Policies rules viewer                       no
ns                              Switch between Kubernetes namespaces                no
oidc-login                      Log in to the OpenID Connect provider               no
open-svc                        Open the Kubernetes URL(s) for the specified se...  no
operator                        Manage operators with Operator Lifecycle Manager    no
oulogin                         Login to a cluster via OpenUnison                   no
outdated                        Finds outdated container images running in a cl...  no
passman                         Store kubeconfig credentials in keychains or pa...  no
pod-dive                        Shows a pod's workload tree and info inside a node  no
pod-logs                        Display a list of pods to get logs from             no
pod-shell                       Display a list of pods to execute a shell in        no
podevents                       Show events for pods                                no
popeye                          Scans your clusters for potential resource issues   no
preflight                       Executes application preflight tests in a cluster   no
profefe                         Gather and manage pprof profiles from running pods  no
prompt                          Prompts for user confirmation when executing co...  no
prune-unused                    Prune unused resources                              no
psp-util                        Manage Pod Security Policy(PSP) and the related...  no
rabbitmq                        Manage RabbitMQ clusters                            no
rbac-lookup                     Reverse lookup for RBAC                             no
rbac-view                       A tool to visualize your RBAC permissions.          no
reap                            Delete unused Kubernetes resources.                 no
resource-capacity               Provides an overview of resource requests, limi...  no
resource-snapshot               Prints a snapshot of nodes, pods and HPAs resou...  no
restart                         Restarts a pod with the given name                  no
rm-standalone-pods              Remove all pods without owner references            no
rolesum                         Summarize RBAC roles for subjects                   no
roll                            Rolling restart of all persistent pods in a nam...  no
schemahero                      Declarative database schema migrations via YAML     no
score                           Kubernetes static code analysis.                    no
service-tree                    Status for ingresses, services, and their backends  no
shovel                          Gather diagnostics for .NET Core applications       no
sick-pods                       Find and debug Pods that are "Not Ready"            no
snap                            Delete half of the pods in a namespace or cluster   no
sniff                           Start a remote packet capture on pods using tcp...  yes
sort-manifests                  Sort manifest files in a proper order by Kind       no
split-yaml                      Split YAML output into one file per resource.       no
spy                             pod debugging tool for kubernetes clusters with...  no
sql                             Query the cluster via pseudo-SQL                    no
ssh-jump                        A kubectl plugin to SSH into Kubernetes nodes u...  no
sshd                            Run SSH server in a Pod                             no
ssm-secret                      Import/export secrets from/to AWS SSM param store   no
starboard                       Toolkit for finding risks in kubernetes resources   no
status                          Show status details of a given resource.            no
sudo                            Run Kubernetes commands impersonated as group s...  no
support-bundle                  Creates support bundles for off-cluster analysis    no
tail                            Stream logs from multiple pods and containers u...  no
tap                             Interactively proxy Kubernetes Services with ease   no
tmux-exec                       An exec multiplexer using Tmux                      no
topology                        Explore region topology for nodes or pods           no
trace                           bpftrace programs in a cluster                      no
tree                            Show a tree of object hierarchies through owner...  no
unused-volumes                  List unused PVCs                                    no
view-allocations                List allocations per resources, nodes, pods.        no
view-cert                       View certificate information stored in secrets      no
view-secret                     Decode Kubernetes secrets                           no
view-serviceaccount-kubeconfig  Show a kubeconfig setting to access the apiserv...  no
view-utilization                Shows cluster cpu and memory utilization            no
view-webhook                    Visualize your webhook configurations               no
virt                            Control KubeVirt virtual machines using virtctl     no
warp                            Sync and execute local files in Pod                 no
who-can                         Shows who has RBAC permissions to access Kubern...  no
whoami                          Show the subject that's currently authenticated...  no

$  kubectl krew -h
krew is the kubectl plugin manager.
You can invoke krew through kubectl: "kubectl krew [command]..."

Usage:
  kubectl krew [command]

Available Commands:
  help        Help about any command
  index       Manage custom plugin indexes
  info        Show information about an available plugin
  install     Install kubectl plugins
  list        List installed kubectl plugins
  search      Discover kubectl plugins
  uninstall   Uninstall plugins
  update      Update the local copy of the plugin index
  upgrade     Upgrade installed plugins to newer versions
  version     Show krew version and diagnostics

Flags:
  -h, --help      help for krew
  -v, --v Level   number for the log level verbosity

Use "kubectl krew [command] --help" for more information about a command.

$  kubectl krew list
PLUGIN  VERSION
krew    v0.4.0
sniff   v1.5.0

$  kubectl krew info sniff
NAME: sniff
INDEX: default
URI: https://github.com/eldadru/ksniff/releases/download/v1.5.0/ksniff.zip
SHA256: f3f11afd4c86fdc9661496f93b4db97cd3c70eef98a029f78c2a949419b51b6d
VERSION: v1.5.0
HOMEPAGE: https://github.com/eldadru/ksniff
DESCRIPTION:
When working with micro-services, many times it's very helpful to get a capture of the network
activity between your micro-service and it's dependencies.

ksniff use kubectl to upload a statically compiled tcpdump binary to your pod and redirecting it's
output to your local Wireshark for smooth network debugging experience.

CAVEATS:
\
 | This plugin needs the following programs:
 | * wireshark (optional, used for live capture)
/

$  tree ~/.krew/bin
/home1/jso/.krew/bin
├── kubectl-krew -> /home1/jso/.krew/store/krew/v0.4.1/krew
├── kubectl-makefile -> /home1/jso/.krew/store/makefile/v1.1.1/makefile.sh
├── kubectl-pod_logs -> /home1/jso/.krew/store/pod-logs/v1.0.1/pod-logs.sh
└── kubectl-sniff -> /home1/jso/.krew/store/sniff/v1.6.0/kubectl-sniff

$  kubectl krew list
PLUGIN  VERSION
krew    v0.4.0
sniff   v1.5.0

$  kubectl plugin list
The following compatible plugins are available:

/home1/jso/.krew/bin/kubectl-krew
/home1/jso/.krew/bin/kubectl-makefile
/home1/jso/.krew/bin/kubectl-podtop
/home1/jso/.krew/bin/kubectl-sniff

$  kubectl krew update
Updated the local copy of plugin index.
  New plugins available:
    * assert
    * azad-proxy
    * cost
    * cyclonus
    * direct-csi
    * flyte
    * mc
    * multinet
    * pexec
    * pod-inspect
    * pod-lens
    * promdump
    * reliably
    * resource-versions
    * skew
    * socks5-proxy
    * tunnel
    * vela
    * whisper-secret
  Upgrades available for installed plugins:
    * krew v0.4.0 -> v0.4.1
    * sniff v1.5.0 -> v1.6.0
```

## References

* [git tag](https://git-scm.com/book/en/v2/Git-Basics-Tagging)

* [default krew index](https://github.com/kubernetes-sigs/krew-index)

* [Packt book - create basic kubectl plugin](https://subscription.packtpub.com/book/cloud_and_networking/9781800561878/11/ch11lvl1sec47/creating-a-basic-plugin)

* [Medium Blog - Extending Kubernetes with plugin using Krew](https://devopslearning.medium.com/extending-kubernetes-with-plugin-using-krew-d2cac313b5b)

* [How To Install kubectl plugins in Kubernetes using Krew](https://computingforgeeks.com/install-kubectl-plugins-in-kubernetes-using-krew/)

* [Plugins](https://krew.sigs.k8s.io/plugins/)

* [K8s.io kubectl plugins](https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/)

* [Using Custom Plugin Indexes](https://krew.sigs.k8s.io/docs/user-guide/custom-indexes/)

