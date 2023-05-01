FROM quay.io/operator-framework/helm-operator:v1.28.1

ENV HOME=/opt/helm
COPY watches.yaml ${HOME}/watches.yaml
COPY helm-charts  ${HOME}/helm-charts
WORKDIR ${HOME}

COPY LICENSE /licenses/

# hack to update packages with CVEs
USER root
RUN microdnf --nodocs upgrade -y libxml2 libksba
USER 1001
