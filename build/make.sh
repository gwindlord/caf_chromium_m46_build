#!/bin/bash

LOCAL_REPO="$(dirname $(dirname $(readlink -f $0)))"
ROMName=$(basename $LOCAL_REPO)

# parameter "--system" allows not to start the build immdeiately
# parameter "--no-gclient" allows not to run "gclient runhooks -v" - to check the pervious commits logs
isCustom="$1"

cd $LOCAL_REPO/src

# this commit is here because "gclient sync -n --no-nag-max" changes some files and they need to be either reset or committed to make repo clean
git add -f $(git status -s | awk '{print $2}') && git commit -m "Dummy"

# from here: http://forum.xda-developers.com/general/general/guide-building-chromium-snapdragon-t3255475
git apply $LOCAL_REPO/build/patches/build-deps.patch && git add -f $(git status -s | awk '{print $2}') && git commit -m "Fixing CoreAurora guys issue"

# reverting Google sign-in and extended bookmarks related removals
# (well, they are not removed but placed under ENABLE_SUPPRESSED_CHROMIUM_FEATURES flag, but this flag is not added for actual usage)
# some of them are part of other commits, so had to use patching
git apply $LOCAL_REPO/build/patches/signin.patch && git add -f $(git status -s | awk '{print $2}') && git commit -m "Getting sign-in back"

# I do not know other way to get it themed, sorry
git apply $LOCAL_REPO/build/patches/themes.patch && git add -f $(git status -s | awk '{print $2}') && git commit -m "Masking to Chrome Beta for themes support :->"

#cp -rf $LOCAL_REPO/build/icons/res $LOCAL_REPO/src/swe/channels/default/
#git add -f $(git status -s | awk '{print $2}') && git commit -m "Shamelessly stealing icons from Slim >_<"

# removing Google Translate tick as it does not work anyway
git apply $LOCAL_REPO/build/patches/remove_translate.patch && git add -f $(git status -s | awk '{print $2}') && git commit -m "Remove page translation tick"

cp -f $LOCAL_REPO/build/webrefiner_conf/web_refiner_conf $LOCAL_REPO/src/chrome/android/java/res_chromium/raw/
cp -f $LOCAL_REPO/build/webdefender_conf/web_defender_conf $LOCAL_REPO/src/chrome/android/java/res_chromium/raw/
git add -f $(git status -s | awk '{print $2}') && git commit -m "Shamelessly stealing WebRefiner and WebDefender configs from JSwarts and extending them"

# reverting to old bookmarks UI - have to change strategy due to 9fd8eb1f1374a51f048ec255f8e341ff2e381234
git apply $LOCAL_REPO/build/patches/bookmarks.patch && git add -f $(git status -s | awk '{print $2}') && git commit -m "Reverting to old bookmarks UI"
git revert 2f8a15af8865836a98c578138dc7f59e1b043cf7 || git add -f $(git status -s | awk '{print $2}') && git revert --continue

if [[ "$isCustom" != "--no-gclient" ]];
then

  gclient runhooks -v

  # implementing custom translated lines build
  patch -p0 < $LOCAL_REPO/build/patches/chrome_strings_grd_ninja.diff

else
  exit 0
fi

# for ROM build env - to allow it starting system package build itself
if [[ "$isCustom" != "--system" ]];
then

  $LOCAL_REPO/build/run.sh &

fi
