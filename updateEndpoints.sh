#!/bin/bash

if [ "$TRAVIS_BRANCH" = "dev" ]; then
  endpoint=${TRAVIS_REPO_SLUG//ScavengerBot\/scavenger-/}
fi
  
if [ $endpoint ]; then
  json=$(jo $endpoint=$GIT_VERSION)
  curl -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $AUTH_TOKEN" -d $json https://api-dev.scavengerbot.io/v1/admin/services
fi
