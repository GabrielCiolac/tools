#!/usr/bin/env bash

# This script checks the latest tag in the repo and checks commit messages from the last MR for #major, #minor, or #patch
# tags follow the format major.minor.patch

# get the latest tag
latest_tag=$(git describe --tags $(git rev-list --tags --max-count=1))

# get the commit messages from the last MR
commit_messages=$(git log --pretty=format:"%s" $(git rev-list -n 1 $latest_tag^))

# parse tag into variables major, minor, and patch
major=$(echo $latest_tag | cut -d '.' -f 1)
minor=$(echo $latest_tag | cut -d '.' -f 2)
patch=$(echo $latest_tag | cut -d '.' -f 3)

# check if the commit messages contain #major, #minor, or #patch
if [[ $commit_messages == *"#major"* ]]; then
    major=$((major+1))
    minor=0
    patch=0
elif [[ $commit_messages == *"#minor"* ]]; then
    minor=$((minor+1))
    patch=0
elif [[ $commit_messages == *"#patch"* ]]; then
    patch=$((patch+1))
fi

# print the new version
echo "$major.$minor.$patch"
