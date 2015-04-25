#!/bin/bash

[[ -n "$GIT_AUTHOR_NAME" ]] && git config user.name $GIT_AUTHOR_NAME
[[ -n "$GIT_AUTHOR_EMAIL" ]] && git config user.email $GIT_AUTHOR_EMAIL

printf "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config 

commit=`git rev-parse HEAD`
version=`mvn -B help:evaluate -Dexpression=project.version | grep "^[0-9\.]*$"`
tag=v$version

echo "Tagging $commit as $tag"

git tag $tag $commit
git push origin $tag

