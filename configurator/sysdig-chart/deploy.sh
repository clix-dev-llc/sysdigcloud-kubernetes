#!/bin/bash

DIR="$(cd "$(dirname "$0")"; pwd -P)"
source "$DIR/shared-values.sh"

set -euo pipefail
. "/sysdig-chart/framework.sh"

APPS=$(readConfigFromValuesYaml .apps "$TEMPLATE_DIR/values.yaml")
log info "${APPS}"
SECURE=false
for app in ${APPS}
do
 if [[ ${app} == "secure" ]]; then
  SECURE=true
 fi
done

log notice "Deploying Monitor..."
"$TEMPLATE_DIR/monitor.sh"
if [[ ${SECURE} == true ]];
then
  log notice "Deploying Secure..."
  "$TEMPLATE_DIR/secure.sh"
fi

username=$(readConfigFromValuesYaml .sysdig.admin.username "$MANIFESTS/values.yaml")
password=$(readConfigFromValuesYaml .sysdig.admin.password "$MANIFESTS/secrets-values.yaml")
dns_name=$(readConfigFromValuesYaml .sysdig.dnsName "$MANIFESTS/values.yaml")
log notice "Congratulations your sysdig installation was successfull you can now login to the UI at https://$dns_name with:

username: ${username}
password: ${password}"
