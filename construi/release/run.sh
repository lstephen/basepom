#!/bin/bash

set -e

[[ -n "$GIT_AUTHOR_NAME" ]] && git config user.name $GIT_AUTHOR_NAME
[[ -n "$GIT_AUTHOR_EMAIL" ]] && git config user.email $GIT_AUTHOR_EMAIL

printf "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

release_commit=`git rev-parse HEAD`

echo "Releasing commit ${release_commit}..."

# Remove -SNAPSHOT from version
master_version=`mvn -B help:evaluate -Dexpression=project.version | grep "^[^\s]*-SNAPSHOT$" | sed 's/\(.*\)-SNAPSHOT/\1/'`

echo "Release version is ${master_version}"

release_branch=release/$master_version
git checkout -b $release_branch

mvn -B versions:set -DnewVersion=$master_version -DgenerateBackupPoms=false

echo "Pushing to master..."
git add pom.xml
git commit -m "Update master version to $master_version"
git push origin $release_branch:master
echo "Push to master done."

echo "Updating development version..."
git checkout $release_commit

develop_version=`mvn -B help:evaluate -Dexpression=project.version | grep "^[^\s]*-SNAPSHOT$"`

develop_branch=develop/$develop_version
git checkout -b $develop_branch

mvn -B release:update-versions

new_develop_version=`mvn -B help:evaluate -Dexpression=project.version | grep "^[^\s]*-SNAPSHOT$"`

echo "New development version is $new_develop_version"

echo "Pushing to develop..."
git add pom.xml
git commit -m "Update develop version from $develop_version to $mew_develop_version"
git push origin $develop_branch:develop
echo "Push to develop done."

echo "Release done."

