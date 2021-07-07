#!/bin/bash

# get latest tag
tag=$(git describe --tags `git rev-list --tags --max-count=1`)

# get current commit hash for tag
commit=$(git rev-parse HEAD)

# if there are none, start tags at 0.0.0
if [ -z "$tag" ]
then
    log=$(git log --pretty=oneline)
    tag=0.0.0
else
    log=$(git log $tag..HEAD --pretty=oneline)
fi

# get commit logs and determine home to bump the version
# supports #major, #minor, #patch (anything else will be 'patch')
case "$log" in
    *#major* ) newTag=$(semver $tag -i major);;
    *#minor* ) newTag=$(semver $tag -i minor);;
    * ) newTag=$(semver $tag -i patch);;
esac

export GIT_VERSION=${newTag}
