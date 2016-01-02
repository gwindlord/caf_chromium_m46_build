# Chromium CAF Snapdragon M46 Build Scripts

1. Clone this repo to dir where to build
2. Follow items 2-4 of this guide http://forum.xda-developers.com/general/general/guide-building-chromium-snapdragon-t3255475
  (item 1 is recommended, but I use Debian 8 and it works)
3. Change *ROMName* and *LOCAL_REPO* variables in __./build/*.sh__ accordingly
4. Make sure that you're in the dir where to build
5. To update run **./build/update.sh**
6. To build run **./build/make.sh**
7. Result is in **src/out/Release/apks**

Credits go to:
- [Chromium.org](https://www.chromium.org/);
- *CodeAurora* for their [code](https://codeaurora.org/cgit/quic/chrome4sdp/chromium/src?h=m46);
- *BachMinuetInG* for his guide;
- [Slim Team](https://github.com/SlimRoms) for their icons
