#!/bin/bash

image="${1#quay.io/}"
version=$2

response=$(curl -sSfL -w '%{header_json}' -H "Accept: application/vnd.oci.image.index.v1+json" "https://quay.io/v2/${image}/manifests/${version}" | jq -s)

image_digest=$(jq -r '.[1]."docker-content-digest"[]' <<<$response)
manifest_digest=$(jq -r '.[0].manifests[0].digest' <<<$response)

digest="$(curl -sSfL -H "Accept: application/vnd.oci.image.manifest.v1+json" "https://quay.io/v2/${image}/manifests/${manifest_digest}" | jq -r '.config.digest')"

created=$(curl -sSfL -H "Accept: application/vnd.oci.image.config.v1+json" "https://quay.io/v2/${image}/blobs/${digest}" | jq -r '.config.Labels."org.opencontainers.image.created"')

proxy="./config/default/manager_auth_proxy_patch.yaml"
kube_proxy=$(yq e '.spec.template.spec.containers.[0].image' $proxy)
full_image=${kube_proxy%:*}
kube_image=${full_image#*/}
kube_version=${kube_proxy#*:}

kube_digest=$(curl -sSfL -I -H "Accept: application/vnd.docker.distribution.manifest.list.v2+json" "https://gcr.io/v2/${kube_image}/manifests/${kube_version}" | awk 'BEGIN {FS=": "}/^docker-content-digest/{gsub(/"/, "", $2); print $2}')

printf "%s\n\n" "Manually repleace the following values in bundle/manifests/nginx-ingress-operator.clusterserviceversion.yaml"
printf "%s\n" "metadata.annotations.createdAt: ${created}"
printf "%s\n" "metadata.annotations.containerImage: quay.io/${image}@${image_digest}"
printf "%s\n" "spec.install.spec.deployments[0].spec.template.spec.containers[1].image (nginx-ingress-operator): quay.io/${image}@${image_digest}"
printf "%s\n" "spec.install.spec.deployments[0].spec.template.spec.containers[0].image (kube-rbac-proxy): ${full_image}@${kube_digest}"
