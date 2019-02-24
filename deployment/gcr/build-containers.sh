#!/bin/bash

set -e

docker build -t gcr.io/metal-mariner-231915/justdoit-service:$TRAVIS_COMMIT -f service/Dockerfile service

echo $GCLOUD_SERVICE_KEY | base64 --decode -i > gcloud-service-key.json
gcloud auth activate-service-account --key-file gcloud-service-key.json

gcloud --quiet config set project metal-mariner-231915
gcloud --quiet config set container/cluster todo-app-kubernetes
gcloud --quiet config set compute/zone europe-west2-a
gcloud --quiet container clusters get-credentials todo-app-kubernetes

gcloud docker -- push gcr.io/metal-mariner-231915/justdoit-service
yes | gcloud beta container images add-tag gcr.io/metal-mariner-231915/justdoit-service:$TRAVIS_COMMIT gcr.io/metal-mariner-231915/justdoit-service:latest