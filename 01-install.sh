#!/bin/bash
set -eu

export PATH=$PWD:$PATH

KUBERNETES_RELEASE=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
KOPS_RELEASE=$(curl -s https://github.com/kubernetes/kops/releases/ | grep -o '/kubernetes/kops/releases/download/.*/kops-linux-amd64' | sort -V | tail -n1 | cut -d/ -f6)

echo "kops $KOPS_RELEASE and kubernetes $KUBERNETES_RELEASE found."

if kubectl help > /dev/null; then
    echo "kubectl available in PATH, skipping..."
else
    echo "downloading kubectl $KUBERNETES_RELEASE"
    wget https://storage.googleapis.com/kubernetes-release/release/$KUBERNETES_RELEASE/bin/linux/amd64/kubectl
    chmod +x kubectl
fi

if kops help > /dev/null; then
    echo "kops available in PATH, skipping..."
else
    echo "downloading kops $KOPS_RELEASE"
    wget https://github.com/kubernetes/kops/releases/download/$KOPS_RELEASE/kops-linux-amd64
    mv kops-linux-amd64 kops
    chmod +x kops
fi

echo
echo "# If you haven't sourced this script, run:"
echo 'export PATH=$PWD:$PATH'
