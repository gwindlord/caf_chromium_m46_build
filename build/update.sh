#!/bin/bash

LOCAL_REPO="$(dirname $(dirname $(readlink -f $0)))"
ROMName=$(basename $LOCAL_REPO)

pushd $LOCAL_REPO/src
  git clean -f -d
  git reset --hard HEAD
  rm -rf out
popd

gclient sync -n --no-nag-max
