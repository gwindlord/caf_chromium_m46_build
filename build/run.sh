#!/bin/bash

ROMName="chromium"
LOCAL_REPO="/mnt/sdc/$ROMName"

# these lines explained at http://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>$HOME/logs/bg_build_${ROMName}_$(date +%F_%H_%M_%S).log 2>&1
# Everything below will go to the log file

cd $LOCAL_REPO/src
time ninja -C out/Release swe_browser_apk
