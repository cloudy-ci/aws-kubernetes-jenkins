#!/usr/bin/env bash

helm init
sleep 60
helm install -f jenkins-chart-values.yaml -n cloudy stable/jenkins --version 0.6.3
