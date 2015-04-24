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
mvn -B versions:set -DnewVersion=$master_version -DgenerateBackupPoms=false

echo "Pushing to master..."
git add pom.xml
git commit -m "Update master version to $master_version"
git push origin master
echo "Push to master done."

echo "Updating development version..."
git checkout $release_commit
mvn -B release:update-version

develop_version=`mvn -B help:evaluate -Dexpression=project.version | grep "^[^\s]*-SNAPSHOT$"`

echo "New development version is $develop_version"

echo "Pushing to develop..."
git add pom.xml
git commit -m "Update develop version to $develop_version"
git push origin develop
echo "Push to develop done."

echo "Release done."

