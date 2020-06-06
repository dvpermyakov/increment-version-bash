#!/bin/bash

while getopts r:b:m:f: flag; do
  case "${flag}" in
  r) REPOSITORY=${OPTARG} ;;
  b) BRANCH_CURRENT=${OPTARG} ;;
  m) BRANCH_MASTER=${OPTARG} ;;
  f) VERSION_FILE=${OPTARG} ;;
  esac
done

export TEMP_DIRECTORY=.tmp

function cloneRepository() {
  git init
  git clone "$REPOSITORY"
  git remote add origin "$REPOSITORY"
  git fetch
}

function checkoutMaster() {
  git checkout "$BRANCH_MASTER"
  git pull
}

function checkoutCurrentVersion() {
  git checkout "$BRANCH_CURRENT"
  git pull
}

function pushChangesToRepository() {
  git add "$VERSION_FILE"
  git commit -m "$COMMIT_NAME"
  git push origin "$BRANCH_CURRENT"
}

mkdir "$TEMP_DIRECTORY"
cd "$TEMP_DIRECTORY" || exit

cloneRepository

checkoutMaster
MASTER_VERSION=$(cat $VERSION_FILE)

checkoutCurrentVersion
CURRENT_VERSION=$(cat $VERSION_FILE)

if [ "$MASTER_VERSION" == "$CURRENT_VERSION" -o "$MASTER_VERSION" \> "$CURRENT_VERSION" ]; then
  NEW_VERSION="${MASTER_VERSION%.*}.$((${MASTER_VERSION##*.} + 1))"
  export COMMIT_NAME="increase version $OLD_VERSION -> $NEW_VERSION"
  cat >$VERSION_FILE <<EOF
$NEW_VERSION
EOF
  pushChangesToRepository
fi

cd ..
rm -rf "$TEMP_DIRECTORY"
