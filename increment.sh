#!/bin/bash

while getopts r:b: flag; do
  case "${flag}" in
  r) REPOSITORY=${OPTARG} ;;
  b) DEFAULT_BRANCH=${OPTARG} ;;
  esac
done

export TEMP_DIRECTORY=.tmp

function checkoutRepository() {
  git init
  git clone "$REPOSITORY"
  git remote add origin "$REPOSITORY"
  git fetch
  git checkout "$DEFAULT_BRANCH"
  git pull "$DEFAULT_BRANCH"
}

function pushChangesToRepository() {
  git add "$VERSION_FILE"
  git commit -m "$COMMIT_NAME"
  git push origin "$DEFAULT_BRANCH"
}

mkdir "$TEMP_DIRECTORY"
cd "$TEMP_DIRECTORY" || exit

checkoutRepository

export VERSION_FILE=version.txt
OLD_VERSION=$(cat $VERSION_FILE)
NEW_VERSION="${OLD_VERSION%.*}.$((${OLD_VERSION##*.} + 1))"

export COMMIT_NAME="increase version $OLD_VERSION -> $NEW_VERSION"

cat >$VERSION_FILE <<EOF
$NEW_VERSION
EOF

pushChangesToRepository

cd ..
rm -rf "$TEMP_DIRECTORY"
