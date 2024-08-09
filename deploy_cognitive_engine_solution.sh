#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo snap install juju --classic

juju add-k8s xu8

juju bootstrap xu8

juju add-model kubeflow

# Bypass OS limits
sudo sysctl fs.inotify.max_user_instances=1280
sudo sysctl fs.inotify.max_user_watches=655360

juju deploy mlflow --trust
watch -c 'juju status --color | grep -E "blocked|error|maintenance|waiting|App|Unit"'
juju show-action mlflow-server/0 get-minio-credentials
juju deploy kubeflow --trust

# Configure external IP address for DEX and OIDC Gatekeeper
juju config dex-auth public-url=PUBLIC_URL_dex
juju config oidc-gatekeeper public-url=PUBLIC_URL_oidc

# Set username and password for DEX authentication
juju config dex-auth static-username=EMAIL
juju config dex-auth static-password=PASSWORD

# Deploy Resource Dispatcher and relate it to MLflow
juju deploy resource-dispatcher --trust
juju relate mlflow-server:secrets resource-dispatcher:secrets
juju relate mlflow-server:pod-defaults resource-dispatcher:pod-defaults

watch -c 'juju status --color | grep -E "blocked|error|maintenance|waiting|App|Unit"'

microk8s kubectl label ns user123 user.kubeflow.org/enabled="true"
juju run --unit istio-pilot/0 -- "export JUJU_DISPATCH_PATH=hooks/config-changed; ./dispatch"

# Check Gateway status
kubectl get gateway -n kubeflow