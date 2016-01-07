#!/bin/bash

LOCAL_REPO="$(dirname $(dirname $(readlink -f $0)))"
ROMName=$(basename $LOCAL_REPO)

cd $LOCAL_REPO/src

# this commit is here because "gclient sync -n --no-nag-max" changes some files and they need to be either reset or committed to make repo clean
git add -f $(git status -s | awk '{print $2}') && git commit -m "Dummy"

# from here: http://forum.xda-developers.com/general/general/guide-building-chromium-snapdragon-t3255475
git apply $LOCAL_REPO/build/patches/build-deps.patch && git add -f $(git status -s | awk '{print $2}') && git commit -m "Fixing CoreAurora guys issue"

# reverting Google sign-in and extended bookmarks related removals
# (well, they are not removed but placed under ENABLE_SUPPRESSED_CHROMIUM_FEATURES flag, but this flag is not added for actual usage)
# some of them are part of other commits, so had to use patching
git apply $LOCAL_REPO/build/patches/signin.patch && git add -f $(git status -s | awk '{print $2}') && git commit -m "Getting sign-in back"

sed -i 's#org.codeaurora.swe.browser.dev#com.chrome.beta#' $LOCAL_REPO/src/swe/channels/default/branding/BRANDING
git add -f $(git status -s | awk '{print $2}') && git commit -m "Masking to Chrome Beta for themes support :->"

#cp -rf $LOCAL_REPO/build/icons/res $LOCAL_REPO/src/swe/channels/default/
#git add -f $(git status -s | awk '{print $2}') && git commit -m "Shamelessly stealing icons from Slim >_<"

cp -f $LOCAL_REPO/build/webrefiner_conf/web_refiner_conf $LOCAL_REPO/src/chrome/android/java/res_chromium/raw/
cp -f $LOCAL_REPO/build/webdefender_conf/web_defender_conf $LOCAL_REPO/src/chrome/android/java/res_chromium/raw/
git add -f $(git status -s | awk '{print $2}') && git commit -m "Shamelessly stealing WebRefiner and WebDefender configs from JSwarts and extending them"

gclient runhooks -v

$LOCAL_REPO/build/run.sh &
