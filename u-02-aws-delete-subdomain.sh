#!/bin/bash
set -eux

# Parameters
SUBDOMAIN=$1

# Find out more data
PARENT_DOMAIN=${SUBDOMAIN#*.}
PARENT_HOSTED_ZONE_ID=$(aws route53 list-hosted-zones-by-name \
    | jq -r ".HostedZones | map(select(.Name == \"$PARENT_DOMAIN.\")) | .[0].Id")
RECORD_SET_TO_DELETE=$(aws route53 list-resource-record-sets --hosted-zone-id $PARENT_HOSTED_ZONE_ID \
    | jq ".ResourceRecordSets | map(select(.Name == \"$SUBDOMAIN.\")) | .[0]")
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones-by-name \
    | jq -r ".HostedZones | map(select(.Name == \"$SUBDOMAIN.\")) | .[0].Id")

# Delete it
aws route53 delete-hosted-zone --id $HOSTED_ZONE_ID
aws route53 change-resource-record-sets --hosted-zone-id $PARENT_HOSTED_ZONE_ID --change-batch \
    '{"Changes":[{"Action":"DELETE", "ResourceRecordSet": '"$RECORD_SET_TO_DELETE"' }]}'

echo
echo "Deleted subdomain $SUBDOMAIN"
