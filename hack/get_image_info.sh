#!/bin/bash

image=$1
version=$2

docker pull ${image}:${version}

image_info=$(docker inspect ${image}:${version})

created="$(echo ${image_info} | jq -r '.[0] | .Config.Labels."org.opencontainers.image.created"')"

image_digest="$(echo ${image_info} | jq -r '.[0] | .RepoDigests | .[0]')"

token="$(curl 'https://auth.docker.io/token?service=registry.docker.io&scope=repository:'${image}':pull' 2>/dev/null | jq -r '.token')"

proxy="./config/default/manager_auth_proxy_patch.yaml"
kube_proxy=$(yq e '.spec.template.spec.containers.[0].image' $proxy)
full_image=${kube_proxy%:*}
kube_image=${full_image#*/}
kube_version=${kube_proxy#*:}

kube_digest=$(curl -sSfL -I -H "Accept: application/vnd.docker.distribution.manifest.list.v2+json" "https://gcr.io/v2/${kube_image}/manifests/${kube_version}" | awk 'BEGIN {FS=": "}/^docker-content-digest/{gsub(/"/, "", $2); print $2}')

printf "%s\n\n" "Manually replace the following values in bundle/manifests/nginx-ingress-operator.clusterserviceversion.yaml"
printf "%s\n" "metadata.annotations.createdAt: ${created}"
printf "%s\n" "metadata.annotations.containerImage: docker.io/${image_digest}"
printf "%s\n" "spec.install.spec.deployments[0].spec.template.spec.containers[1].image (nginx-ingress-operator): docker.io/${image_digest}"
printf "%s\n" "spec.install.spec.deployments[0].spec.template.spec.containers[0].image (kube-rbac-proxy): ${full_image}@${kube_digest}"
