#!/bin/bash

commit=`git rev-parse HEAD`
version=`mvn -B help:evaluate -Dexpression=project.version | grep "^[\d\.]*$"`
tag=v$version

echo "Tagging $commit as $tag"

git tag $tag $commit
git push origin $tag

