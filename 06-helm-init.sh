#!/usr/bin/env bash

helm init
sleep 60
helm install stable/jenkins --version 0.6.3
