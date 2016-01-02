#!/bin/bash

ROMName="chromium"
LOCAL_REPO="/mnt/sdc/$ROMName"

pushd $LOCAL_REPO/src
  git clean -f -d
  git reset --hard HEAD
  rm -rf out
popd

gclient sync -n --no-nag-max
