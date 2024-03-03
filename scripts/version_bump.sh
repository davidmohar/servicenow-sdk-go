#!/bin/bash

# Get the last public release
last_release=$(git describe --tags `git rev-list --tags --max-count=1`)

# Get the current state of the repo
current_state=$(git rev-parse HEAD)

# Compare the last release to the current state of the repo
changes=$(git diff --name-only $last_release $current_state)

# Check if any public API changes have been made
api_changes=$(echo "$changes" | grep -v "internal" | grep ".go")

# Get the current version
version=$(echo $last_release | sed 's/v//')
major_version=$(echo $version | cut -d. -f1)
minor_version=$(echo $version | cut -d. -f2)
patch_version=$(echo $version | cut -d. -f3)

# Check if the current branch is a bug-fix
current_branch=$(git branch --show-current)
if [[ $current_branch == *"bug-fix"* ]]; then
  bug_fix=true
else
  bug_fix=false
fi

if [[ $last_release == *"-preview"* ]]; then
  exit 0
fi

# If any public API changes have been made, increment the minor version
if [[ -n $api_changes ]]; then
  minor_version=$((minor_version + 1))
  patch_version=0
# If the current branch is a bug-fix and the minor version isn't incremented, increment the patch version
elif [[ $bug_fix = true ]]; then
  patch_version=$((patch_version + 1))
fi

# Print the new version
echo "v$major_version.$minor_version.$patch_version"