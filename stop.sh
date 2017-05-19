#!/usr/bin/env bash
set -eux

CLUSTER=$1
echo "Destroying $CLUSTER..."
sleep 3

source u-04-kops-delete-cluster.sh
source u-03-aws-delete-s3-bucket.sh
source u-02-aws-delete-subdomain.sh
