#!/bin/bash
set -eux

CLUSTER=$1

AVAILABILITY_ZONE=$(aws ec2 describe-availability-zones | jq -r '.AvailabilityZones[0].ZoneName')
MYIP=$(curl -s http://checkip.amazonaws.com/)
NODE_SIZE=t2.small
MASTER_SIZE=t2.small

kops create cluster --zones=$AVAILABILITY_ZONE --admin-access $MYIP/32 --node-size=$NODE_SIZE --master-size=$MASTER_SIZE $CLUSTER
kops update cluster $CLUSTER --yes
