#!/bin/bash

set -e

git status

# Remove -SNAPSHOT version version
master_version=`mvn -B help:evaluated -Dexpression=project.version | grep "^[^\s]*-SNAPSHOT$" | sed 's/\(.*\)-SNAPSHOT/\1/'`

mvn versions:set -DnewVersion=$master_version
git commit -m "Update master version to $master_version"
git push origin master

git checkout $GIT_COMMMIT
mvn release:update-version

develop_version=`mvn -B help:evaluated -Dexpression=project.version | grep "^[^\s]*-SNAPSHOT$"`

git commit -m "Update develop version to $develop_version"
git push origin develop


