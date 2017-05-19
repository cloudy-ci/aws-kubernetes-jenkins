#!/bin/bash
set -eux

# Parameters
BUCKET=$1

# Add bucket
aws s3 mb s3://$BUCKET

export KOPS_STATE_STORE=s3://$BUCKET

echo
echo "# If you haven't sourced this script, run:"
echo "export KOPS_STATE_STORE=$KOPS_STATE_STORE"
