#!/bin/bash

export TEMP_DIRECTORY=.tmp
export REPOSITORY=https://github.com/dvpermyakov/public-poll-server.git
export DEFAULT_BRANCH=master

function checkoutRepository() {
  git init
  git clone $REPOSITORY
  git remote add origin $REPOSITORY
  git fetch
  git checkout "$DEFAULT_BRANCH"
  git pull
}

function pushChangesToRepository() {
  git checkout -b "$FEATURE_BRANCH"
  git add "$VERSION_FILE"
  git commit -m "$COMMIT_NAME"
  git push origin "$FEATURE_BRANCH"
}

mkdir "$TEMP_DIRECTORY"
cd "$TEMP_DIRECTORY" || exit

checkoutRepository

export VERSION_FILE=version.txt
OLD_VERSION=$(cat $VERSION_FILE)
NEW_VERSION="${OLD_VERSION%.*}.$((${OLD_VERSION##*.} + 1))"

export FEATURE_BRANCH=feature/increment_version_$NEW_VERSION
export COMMIT_NAME="increase version $OLD_VERSION -> $NEW_VERSION"

cat >$VERSION_FILE <<EOF
$NEW_VERSION
EOF

pushChangesToRepository

cd ..
rm -rf "$TEMP_DIRECTORY"
