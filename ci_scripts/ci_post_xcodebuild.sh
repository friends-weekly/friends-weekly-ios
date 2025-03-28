#!/bin/sh

#  ci_post_xcodebuild.sh
# Run after the xcodebuild phase of the CI process, before the TestFlight upload

# Update the TestFlight release notes with the last 3 commit messages
if [[ -d "$CI_APP_STORE_SIGNED_APP_PATH" ]]; then
  TESTFLIGHT_DIR_PATH=../TestFlight
  mkdir $TESTFLIGHT_DIR_PATH
  git fetch --deepen 5 && git log -5 --pretty=format:"- %s%n %h%n %ad%n" --date=format:'%A, %B %d, %Y at %I:%M %p' >! $TESTFLIGHT_DIR_PATH/WhatToTest.en-US.txt
fi
