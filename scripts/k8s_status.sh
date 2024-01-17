#!/usr/bin/env bash

# Tmux status bar script to fetch information on k8s environments
get_status() {
  if !(hash kubectl) 2> /dev/null; then
    status="kubectl not found!"
  else
    kubeconfig_base="$HOME/.kube/"
    # loop over kubeconfig files in kubeconfig_base and construct KUBECONFIG
    for kubeconfig in $(ls $kubeconfig_base | grep config); do
      export KUBECONFIG="$KUBECONFIG:$kubeconfig_base/$kubeconfig"
    done
    echo "KUBECONFIG: $KUBECONFIG" > /tmp/k8s_status.log
    context=$(kubectl config current-context)
    context_info=$(kubectl config get-contexts --no-headers)
    namespace=$(echo "$context_info" | grep "*" | awk '{print $5}')

    if [ -z "$namespace" -o -z "$context" -o -z "$context_info" ]; then
      context="N/A"
      context_info="N/A"
      namespace="N/A"
    fi

    status="${context}:${namespace}"
  fi
  echo "$status"
}

get_status
