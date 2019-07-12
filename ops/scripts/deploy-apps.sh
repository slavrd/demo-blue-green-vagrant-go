#!/usr/bin/env bash
# Deploy 2 versions of the github.com/slavrd/demo-blue-green-vagrant-go golang app

# Arguments
# 1 (Required) "blue" version - e.g. v0.1
# 2 (Required) "gree" version - e.g. v0.1

if [ $# != 2 ]; then
  echo "usage: ${0} <blue_version> <green_version>"
  exit 1
fi

# input variables
APP_ARTIFACT_NAME='demosrv.zip'
APP_NAME='demosrv' # the script assumes that this is the name of the app executable and the root folder in the downloaded application archive 
BLUE_URL="https://github.com/slavrd/demo-blue-green-vagrant-go/releases/download/${1}/${APP_ARTIFACT_NAME}"
GREEN_URL="https://github.com/slavrd/demo-blue-green-vagrant-go/releases/download/${2}/${APP_ARTIFACT_NAME}"

# create directories to download and deploy apps
[ -d /tmp/blue ] || mkdir /tmp/blue
[ -d /tmp/green ] || mkdir /tmp/green
[ -d /opt/blue ] || sudo mkdir /opt/blue
[ -d /opt/green ] || sudo mkdir /opt/green

# download verions
[ -e /tmp/blue/$APP_ARTIFACT_NAME ] && rm -rf /tmp/blue/$APP_ARTIFACT_NAME
wget -q -P /tmp/blue $BLUE_URL || {
  echo "failed downloading app form $BLUE_URL"
  exit 1
}
[ -e /tmp/green/$APP_ARTIFACT_NAME ] && rm -rf /tmp/green/$APP_ARTIFACT_NAME
wget -q -P /tmp/green $GREEN_URL || {
  echo "failed downloading app form $GREEN_URL"
  exit 1
}

# install unzip if not installed
which unzip || {
  sudo apt-get update
  sudo apt-get install -y unzip
}

# unzip and start apps
sudo kill $(pgrep $APP_NAME) 2>/dev/null

[ -z "`ls -A /opt/blue/`" ] || sudo rm -rf /opt/blue/*
  sudo unzip /tmp/blue/$APP_ARTIFACT_NAME -d /opt/blue && {
  pushd /opt/blue/$APP_NAME
  ./$APP_NAME -p 8000 &
  popd
}

[ -z "`ls -A /opt/green/`" ] || sudo rm -rf /opt/green/*
  sudo unzip /tmp/green/$APP_ARTIFACT_NAME -d /opt/green && {
  pushd /opt/green/$APP_NAME
  ./$APP_NAME -p 8010 &
  popd
}

#clean up
sudo apt-get clean
rm -rf /tmp/blue /tmp/green
