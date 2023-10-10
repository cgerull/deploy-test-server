#!/bin/bash
#
# Create a simple testsecret
kubectl create secret generic testserver --from-literal=testserver=mytestsecret