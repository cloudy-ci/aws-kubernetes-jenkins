#!/usr/bin/env bash
set -eux

# Parameters
BUCKET=$1

# Delete bucket
aws s3 rb s3://$BUCKET

echo
echo "# Deleted bucket. Now run:"
echo "unset KOPS_STATE_STORE"
