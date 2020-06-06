#!/bin/bash

export REPOSITORY=https://github.com/dvpermyakov/public-poll-server.git
export DEFAULT_BRANCH=feature/increase_version_2
export FEATURE_BRANCH=feature/increase_version_2
export COMMIT_NAME="increase version"
export VERSION_FILE=version.txt

function incrementVersion() {
  version=$(cat $VERSION_FILE)
  incrementedVersion="${version%.*}.$((${version##*.} + 1))"
  cat >$VERSION_FILE <<EOF
$incrementedVersion
EOF
}

function checkoutRepository() {
  git init
  git clone $REPOSITORY
  git remote add origin $REPOSITORY
  git fetch
  git checkout "$DEFAULT_BRANCH"
  git pull
  git checkout -b "$FEATURE_BRANCH"
}

mkdir temp
cd temp || exit

checkoutRepository
incrementVersion

git add $VERSION_FILE
git commit -m "$COMMIT_NAME"
git push origin "$FEATURE_BRANCH"

cd ..
rm -rf temp
