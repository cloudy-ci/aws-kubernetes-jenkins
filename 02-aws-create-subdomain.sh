#!/bin/bash
set -eux

# Parameters
SUBDOMAIN=$1

# Find out more data
PARENT_DOMAIN=${SUBDOMAIN#*.}
PARENT_HOSTED_ZONE_ID=$(aws route53 list-hosted-zones-by-name \
    | jq -r ".HostedZones | map(select(.Name == \"$PARENT_DOMAIN.\")) | .[0].Id")

# Create subdomain hosted zone
NAME_SERVERS=$(aws route53 create-hosted-zone --name $SUBDOMAIN. --caller-reference $SUBDOMAIN.$(date +%s) \
    | jq -r '.DelegationSet.NameServers | map({"Value": .})')

# Add nameservers of subdomain to parent zone
aws route53 change-resource-record-sets --hosted-zone-id $PARENT_HOSTED_ZONE_ID --change-batch '
{"Changes":[{"Action":"CREATE", "ResourceRecordSet":{
    "Name":"'"$SUBDOMAIN"'",
    "Type":"NS",
    "TTL":300,
    "ResourceRecords": '"$NAME_SERVERS"'
}}]}
'

echo "Created subdomain $SUBDOMAIN"
