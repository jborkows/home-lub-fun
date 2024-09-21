#!/bin/bash

set -e

LABEL_SELECTOR="autodeploy"  

get_latest_image_hash() {
  local image_name=$1
  
  latest_tag=$(curl -s "https://registry.hub.docker.com/v2/repositories/$image_name/tags" | jq -r '.results | .[0].name')

  if [ -z "$latest_tag" ]; then
    echo "No tags found for image: $image_name."
    exit 1
  fi

  image_hash=$(curl -s "https://registry.hub.docker.com/v2/repositories/$image_name/tags/$latest_tag" | jq -r '.images[0].digest')

  if [ -z "$image_hash" ]; then
    echo "No image hash found for tag: $latest_tag."
    exit 1
  fi

  echo "$image_hash"
}

deployments=$(microk8s kubectl get deployments --all-namespaces -l $LABEL_SELECTOR -o jsonpath='{.items[*].metadata.name}')
namespaces=$(microk8s kubectl get deployments --all-namespaces -l $LABEL_SELECTOR -o jsonpath='{.items[*].metadata.namespace}')
image_names=$(microk8s kubectl get deployments --all-namespaces -l $LABEL_SELECTOR -o jsonpath='{.items[*].spec.template.spec.containers[*].image}')

if [ -z "$deployments" ]; then
  echo "No deployments found with label '$LABEL_SELECTOR' in any namespace."
  exit 0
fi

# Convert to arrays
IFS=' ' read -r -a deployment_array <<< "$deployments"
IFS=' ' read -r -a namespace_array <<< "$namespaces"
IFS=' ' read -r -a image_array <<< "$image_names"

for index in "${!deployment_array[@]}"; do
  deployment="${deployment_array[$index]}"
  namespace="${namespace_array[$index]}"
  image_name="${image_array[$index]}"
  image_name=$(echo "$image_name" | sed 's/[@:].*//')


  echo "Updating deployment: $deployment in namespace: $namespace with image: $image_name"
  
  latest_hash=$(get_latest_image_hash "$image_name")

  echo "Latest image hash found: $latest_hash"

  microk8s kubectl set image deployment/$deployment $deployment=$image_name@$latest_hash -n $namespace
  
  # Optionally, roll out the deployment
  microk8s kubectl rollout status deployment/$deployment -n $namespace

  echo "Deployment '$deployment' updated to use image hash: $latest_hash"
done
