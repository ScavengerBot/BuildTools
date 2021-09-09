#!/bin/bash

if ! [ $TRAVIS_BRANCH =~ ^(dev|beta)$ ]; then
  endpoint=${TRAVIS_REPO_SLUG//ScavengerBot\/scavenger-/}
fi
  
if [ $endpoint ]; then
  curl -X PUT -H "Content-Type: application/json" -d {} https://api-dev.scavengerbot.io/v1/admin/services
fi
