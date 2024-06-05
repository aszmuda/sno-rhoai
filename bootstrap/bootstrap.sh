#!/bin/sh

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly ORANGE='\033[38;5;214m'
readonly NC='\033[0m' # No Color
readonly RUN_DIR=$(dirname -- "${BASH_SOURCE}")

# Define the retry function
wait_and_retry() {
  local retries="$1"
  local wait="$2"
  local command="$3"

  # Run the command, and save the exit code
  $command
  local exit_code=$?

  # If the exit code is non-zero (i.e. command failed), and we have not
  # reached the maximum number of retries, run the command again
  if [[ $exit_code -ne 0 && $retries -gt 0 ]]; then
    # Wait before retrying
    echo "..."
    sleep $wait

    wait_and_retry $(($retries - 1)) $wait "$command"
  else
    # Return the exit code from the command
    return $exit_code
  fi
}

clear

oc whoami
[[ $? -gt 0 ]] && echo "Make sure you are logged in your Cluster with an cluster-admin user first! oc login..." && exit 1

echo "\n${GREEN}Install Openshift Gitops Operator...${NC}"
oc apply -k $RUN_DIR/../applications/openshift-gitops-operator/operator/overlays/latest

echo "\n${GREEN}Wait until the Gitops operators is ready...${NC}"

wait_and_retry 10 10 "oc wait pods -n openshift-gitops-operator -l control-plane=gitops-operator --for condition=Ready"

echo "\n${GREEN}Create an ArgoCD instance...${NC}"
oc apply -k $RUN_DIR/../applications/openshift-gitops-operator/instance/overlays/default

echo "\n${GREEN}Wait until the ArgoCD instance is ready...${NC}"

wait_and_retry 6 10 "oc get argocd -n openshift-gitops"

echo "\n${GREEN}Bootstrapping the components though Openshift GitOps (ArgoCD)...${NC}"
oc apply -f $RUN_DIR/../app-of-apps/dev-app-of-apps.yaml

argocdurl=$(oc get route openshift-gitops-server --ignore-not-found=true -n "openshift-gitops" -o jsonpath="{'https://'}{.status.ingress[0].host}")
echo "\n${GREEN}Done!✅ \nYou can now access Openshift Gitops though: $argocdurl${NC}"