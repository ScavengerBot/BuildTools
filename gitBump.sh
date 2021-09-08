#!/bin/bash

# get latest tag
tag=$(git describe --tags `git rev-list --tags --max-count=1`)

# get current commit hash for tag
commit=$(git rev-parse HEAD)

# get current branch name
branch=$(git rev-parse --abbrev-ref HEAD)

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
    *\[BREAKING]* ) newTag=$(semver $tag -i major);;
    *\[FEATURE]* ) newTag=$(semver $tag -i minor);;
    #*\[FIX]* ) newTag=$(semver $tag -i patch);;
    * ) newTag=$(semver $tag -i patch);;
esac

# export GIT variables for later use
export GIT_VERSION=${newTag}
export GIT_BRANCH=${branch}

# create github release notes heading
echo "# What's new in Version ${GIT_VERSION}" > release.txt
echo "" >> release.txt

# add git log as release notes
git log $(git describe --tags --abbrev=0)..HEAD --pretty=format:"- %s" -i -E --grep="^(\[BREAKING\]|\[FEATURE\]|\[FIX\]|\[DOC\])*" >> release.txt
