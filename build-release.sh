#!/bin/bash

test ! -e platforms/android/build-extras.gradle && \
  echo 'ext.cdvBuildMultipleApks=false' > platforms/android/build-extras.gradle

test -e plugin/cordova-plugin-console && \
cordova plugin rm cordova-plugin-console

# exit if fail
set -e

# fail if parameter not set
set -u

storekey=$1
key_alias=$2
storepass=$3
keypass=$4
env=$5
output_file=$6

gulp --cordova 'build --release android' --env=staging
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $storekey -storepass $storepass -keypass $keypass platforms/android/build/outputs/apk/android-release-unsigned.apk $alias
zipalign -v 4 platforms/android/build/outputs/apk/android-release-unsigned.apk $output_file
