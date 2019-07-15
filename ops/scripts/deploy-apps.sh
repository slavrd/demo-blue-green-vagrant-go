#!/usr/bin/env bash
# Deploy 2 versions of the github.com/slavrd/demo-blue-green-vagrant-go golang app

# Arguments
# 1 (Required) "blue" version - e.g. v0.1
# 2 (Required) "gree" version - e.g. v0.1

if [ $# != 3 ]; then
  echo "usage: ${0} <app_ver> <deploy_dir> <listen_port>"
  exit 1
fi

# input variables
APP_VER="${1}"
DEPLOY_DIR="${2}"
PORT="${3}"
APP_ARTIFACT_NAME='demosrv.zip'
APP_NAME='demosrv' # the script assumes that this is the name of the app executable and the root folder in the downloaded application archive 
APP_URL="https://github.com/slavrd/demo-blue-green-vagrant-go/releases/download/${APP_VER}/${APP_ARTIFACT_NAME}"

# check for app instance already running on this port
pgrep -f "${APP_NAME} -p\s*${PORT}" && {
  echo "error: there already is ${APP_NAME} instance listening on ${PORT}" >&2
  exit 1
}

# create directories to download and deploy apps
[ -d "/tmp/${APP_VER}" ] || mkdir "/tmp/${APP_VER}"
[ -d "${DEPLOY_DIR}" ] || sudo mkdir "${DEPLOY_DIR}"

# download verions
[ -e /tmp/${APP_VER}/${APP_ARTIFACT_NAME} ] && rm -rf /tmp/${APP_VER}/${APP_ARTIFACT_NAME}
wget -q -P /tmp/${APP_VER} ${APP_URL} || {
  echo "failed downloading app form ${APP_URL}"
  exit 1
}

# install unzip if not installed
which unzip || {
  sudo apt-get update
  sudo apt-get install -y unzip
}

# unzip and start apps
[ -z "`ls -A ${DEPLOY_DIR}`" ] || sudo rm -rf ${DEPLOY_DIR}*
  sudo unzip /tmp/${APP_VER}/$APP_ARTIFACT_NAME -d ${DEPLOY_DIR} && {
  pushd ${DEPLOY_DIR}/${APP_NAME} >> /dev/null
  ./${APP_NAME} -p ${PORT} &
  popd >> /dev/null
}

#clean up
sudo apt-get clean
rm -rf /tmp/${APP_VER}
