#!/usr/bin/env bash
set -eux

CLUSTER=$1

kops delete cluster --name $CLUSTER --yes
