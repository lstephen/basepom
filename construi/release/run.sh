#!/bin/bash

set -e

gpg --import /root/.gnupg/public.key
gpg --import --allow-secret-key-import /root/.gnupg/private.key
git status
mvn -B -e -X -DstartCommit=$GIT_COMMIT -DpushReleases=ture jgitflow:release-start jgitflow:release-finish

