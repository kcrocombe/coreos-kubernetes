#!/bin/bash
#
# Notes by KJC Jan 2020
#
# Test Suite to check the conformance of a particular kubernetes release. These run largely within a go container on the controller machine.
#
# The components of the test suite seems to update themselves to the latest versions when it runs. Consequently, it may very well change in between
# runs: I know for a fact that the suite worked ok in November 2019, but a bug has been intoduced in the version it builds in January 2020, and so
# as of then, it NO LONGER WORKS. Hopefully that will get fixed in due course.
#
# Note that building the test suit involves downloading and installing quite a lot of software : consequently the test take a long time to start
# running.
#
# If, and when, they do start running : this is extremely resource intensive too.
#
# Also, still not entirely clear whether this tends the kubernetes cluster that I have built, or whether it builds its own and tests that (although
# the documnetatio claims that it tests the cluster that I have installed!)
#
set -euo pipefail

CHECK_NODE_COUNT=${CHECK_NODE_COUNT:-true}
CONFORMANCE_REPO=${CONFORMANCE_REPO:-github.com/coreos/kubernetes}
#CONFORMANCE_VERSION=${CONFORMANCE_VERSION:-v1.5.4+coreos.0}
CONFORMANCE_VERSION=${CONFORMANCE_VERSION:-v1.9.11+coreos.0}
SSH_OPTS=${SSH_OPTS:-}

usage() {
    echo "USAGE:"
    echo "  $0 <ssh-host> <ssh-port> <ssh-key>"
    echo
    exit 1
}

if [ $# -ne 3 ]; then
    usage
    exit 1
fi

ssh_host=$1
ssh_port=$2
ssh_key=$3

kubeconfig=$(cat <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    server: http://127.0.0.1:8080
EOF
)

K8S_SRC=/home/core/go/src/k8s.io/kubernetes


# Clone a full copy of the kerbetes repository onto the Controller Box itself. This will reflect the very latest state of kerbetes.

ssh ${SSH_OPTS} -i ${ssh_key} -p ${ssh_port} core@${ssh_host} \
    "mkdir -p ${K8S_SRC} && [[ -d ${K8S_SRC}/.git ]] || git clone https://${CONFORMANCE_REPO} ${K8S_SRC}"


echo "Cloning Step Complete.\n"

ssh ${SSH_OPTS} -i ${ssh_key} -p ${ssh_port} core@${ssh_host} \
    "[[ -f /home/core/kubeconfig ]] || echo '${kubeconfig}' > /home/core/kubeconfig"

echo "Kubeconfig Written.\n"


# Init steps necessary to run conformance in docker://golang:1.7.4 container
#
# No idea what the go-bindata stuff does.
#
# Note that the below are all to be run INSIDE the Go container.
#
#INIT="apt-get update && apt-get install -y rsync && go get -u github.com/jteeuwen/go-bindata/go-bindata"
#
INIT="apt-get update && \
	echo 'INIT 1 Complete.' && \
	apt-get install -y rsync && \
	echo 'INIT 2 Complete.' && \
	go get -u github.com/jteeuwen/go-bindata/go-bindata && \
	echo 'INIT 3 Complete.' \
	"
INIT="echo 'INIT 3 Complete.'"

# These are flags eventually supplied into the end2end test routine, and the latter ones are then passed on into the kubetest.
# Note that these have changes over recent months : even the one below, I'm not sure works.
#
# TEST_FLAGS="-v --test -check_version_skew=false --test_args=\"ginkgo.focus='\[Conformance\]'\""
TEST_FLAGS="--get=false -- --test -check_version_skew=false --test_args=\"ginkgo.focus='\[Conformance\]'\""

#CONFORMANCE=$(echo \
#    "cd /go/src/k8s.io/kubernetes && " \
#    "git checkout ${CONFORMANCE_VERSION} && " \
#    "make all WHAT=cmd/kubectl && " \
#    "make all WHAT=vendor/github.com/onsi/ginkgo/ginkgo && " \
#    "make all WHAT=test/e2e/e2e.test && " \
#    "KUBECONFIG=/kubeconfig KUBERNETES_PROVIDER=skeleton KUBERNETES_CONFORMANCE_TEST=Y go run hack/e2e.go ${TEST_FLAGS}")


# Builds the guts of the commands that are to be executed INSIDE the container. It checks out the release of kubernetes under 
# test, builds certain components from within it, and then runs the 'go' script e2e.go.

CONFORMANCE=$(echo \
    "cd /go/src/k8s.io/kubernetes && " \
    "echo 'CONFORMANCE 1 Complete\n' && " \
    "git checkout ${CONFORMANCE_VERSION} && " \
    "echo 'CONFORMANCE 2 Complete\n' && " \
    "make all WHAT=cmd/kubectl && " \
    "echo 'CONFORMANCE 3 Complete\n' && " \
    "make all WHAT=vendor/github.com/onsi/ginkgo/ginkgo && " \
    "echo 'CONFORMANCE 4 Complete\n' && " \
    "make all WHAT=test/e2e/e2e.test && " \
    "echo 'CONFORMANCE 5 Complete\n' && " \
    "KUBECONFIG=/kubeconfig KUBERNETES_PROVIDER=skeleton KUBERNETES_CONFORMANCE_TEST=Y go run hack/e2e.go ${TEST_FLAGS}")

#CONFORMANCE=$(echo \
#    "cd /go/src/k8s.io/kubernetes && " \
#    "KUBECONFIG=/kubeconfig KUBERNETES_PROVIDER=skeleton KUBERNETES_CONFORMANCE_TEST=Y go run hack/e2e.go ${TEST_FLAGS}")

#CONFORMANCE=$(echo \
#    "cd /go/src/k8s.io && " \
#    "KUBECONFIG=/kubeconfig KUBERNETES_PROVIDER=skeleton KUBERNETES_CONFORMANCE_TEST=Y go get -u k8s.io/test-infra/kubetest")
#
#CONFORMANCE=$(echo \
#    "cd /go/src/k8s.io && " \
#    "KUBECONFIG=/kubeconfig KUBERNETES_PROVIDER=skeleton KUBERNETES_CONFORMANCE_TEST=Y go install k8s.io/test-infra/kubetest2")

echo ${CONFORMANCE}

# Maps sections of the controller filesystems to volumes mounted inside the the Container. Because these are overlay filesystems, what the
# container writes to the filesystem is not visible outside of it.
#
RKT_OPTS=$(echo \
    "--volume=kc,kind=host,source=/home/core/kubeconfig "\
    "--volume=k8s,kind=host,source=${K8S_SRC} " \
    "--mount volume=kc,target=/kubeconfig " \
    "--mount volume=k8s,target=/go/src/k8s.io/kubernetes")

#RKT_OPTS=$(echo \
#    "--volume=kc,kind=host,source=/home/core/kubeconfig "\
#    "--volume=k8s,kind=host,source=/home/core/go/src" \
#    "--mount volume=kc,target=/kubeconfig " \
#    "--mount volume=k8s,target=/go/src")

echo ${RKT_OPTS}

# Build the command string actually to be run. Note that this specifies the docker image to be run ( golang ) and the commands to be run within a
# bash shell within it.
#
#CMD="sudo rkt run --net=host --insecure-options=image ${RKT_OPTS} docker://golang:1.7.4 --exec /bin/bash -- -c \"${INIT} && ${CONFORMANCE}\""
#CMD="sudo rkt run --net=host --insecure-options=image ${RKT_OPTS} docker://golang:1.9.1 --exec /bin/bash -- -c \"${INIT} && ${CONFORMANCE}\""
CMD="sudo rkt run --net=host --insecure-options=image ${RKT_OPTS} docker://golang:1.13.6 --exec /bin/bash -- -c \"${INIT} && ${CONFORMANCE}\""

echo $CMD

ssh ${SSH_OPTS} -i ${ssh_key} -p ${ssh_port} core@${ssh_host} "${CMD}"
