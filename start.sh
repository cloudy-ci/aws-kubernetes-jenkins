#!/usr/bin/env bash
set -eux

CLUSTER=$1
echo "Creating $CLUSTER"

source 01-install.sh
source 02-aws-create-subdomain.sh $CLUSTER
source 03-aws-create-s3-bucket.sh $CLUSTER
source 04-create-cluster.sh $CLUSTER
