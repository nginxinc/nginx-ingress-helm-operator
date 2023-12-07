# NginxIngress Custom Resource

The `NginxIngress` Custom Resource is the definition of a deployment of the Ingress Controller.
With this Custom Resource, the NGINX Ingress Operator will be able to deploy and configure instances of the Ingress Controller in your cluster.

## Configuration

There are several fields to configure the deployment of an Ingress Controller.

 The following example shows the usage of all fields (required and optional):

```yaml
apiVersion: charts.nginx.org/v1alpha1
kind: NginxIngress
metadata:
  name: nginxingress-sample
spec:
  controller:
    kind: deployment
    annotations: {}
    nginxplus: false
    nginxReloadTimeout: 60000
    appprotect:
      enable: false
      # logLevel: fatal
    appprotectdos:
      enable: false
      debug: false
      maxWorkers: 0
      maxDaemons: 0
      memory: 0
    hostNetwork: false
    dnsPolicy: ClusterFirst
    nginxDebug: false
    logLevel: 1
    customPorts: []
    image:
      repository: nginx/nginx-ingress
      tag: "3.3.2-ubi"
      # digest: "sha256:CHANGEME"
      pullPolicy: IfNotPresent
    lifecycle: {}
    customConfigMap: ""
    config:
      # name: nginx-config
      annotations: {}
      entries: {}
    ## The secret with a TLS certificate and key for the default HTTPS server.
    ## The value must follow the following format: `<namespace>/<name>`.
    ## Note: Alternatively, omitting the default server secret completely will configure NGINX to reject TLS connections to the default server.
    ## Format: <namespace>/<secret_name>
    defaultTLS:
      secret: ""
    wildcardTLS:
      secret:
    # nodeSelector: {}
    terminationGracePeriodSeconds: 30
    autoscaling:
      enabled: false
      annotations: {}
      minReplicas: 1
      maxReplicas: 3
      targetCPUUtilizationPercentage: 50
      targetMemoryUtilizationPercentage: 50
    resources:
      requests:
        cpu: 100m
        memory: 128Mi
    # limits:
    #   cpu: 1
    #   memory: 1Gi
    tolerations: []
    affinity: {}
    # topologySpreadConstraints: {}
    ## The additional environment variables to be set on the Ingress Controller pods.
    env: []
    # - name: MY_VAR
    #   value: myvalue
    volumes: []
    # - name: extra-conf
    #   configMap:
    #     name: extra-conf
    volumeMounts: []
    # - name: extra-conf
    #   mountPath: /etc/nginx/conf.d/extra.conf
    #   subPath: extra.conf
    initContainers: []
    # - name: init-container
    #   image: busybox:1.34
    #   command: ['sh', '-c', 'echo this is initial setup!']
    minReadySeconds: 0
    ## Pod disruption budget for the Ingress Controller pods.
    podDisruptionBudget:
      ## Enables PodDisruptionBudget.
      enabled: false
      ## The annotations of the Ingress Controller pod disruption budget.
      annotations: {}
      ## The number of Ingress Controller pods that should be available. This is a mutually exclusive setting with "maxUnavailable".
      # minAvailable: 1
      ## The number of Ingress Controller pods that can be unavailable. This is a mutually exclusive setting with "minAvailable".
      # maxUnavailable: 1

    strategy: {}
    extraContainers: []
    # - name: container
    #   image: busybox:1.34
    #   command: ['sh', '-c', 'echo this is a sidecar!']
    replicaCount: 1
    ingressClass: 
      name: nginx
      setAsDefaultIngress: false
    watchNamespace: ""
    watchNamespaceLabel: ""
    watchSecretNamespace: ""
    enableCustomResources: true
    enablePreviewPolicies: false
    enableOIDC: false
    includeYear: false
    enableTLSPassthrough: false
    enableCertManager: false
    enableExternalDNS: false
    globalConfiguration:
      create: false
      spec: {}
        # listeners:
        # - name: dns-udp
        #   port: 5353
        #   protocol: UDP
        # - name: dns-tcp
        #   port: 5353
        #   protocol: TCP
    enableSnippets: false
    healthStatus: false
    healthStatusURI: "/nginx-health"
    nginxStatus:
      enable: true
      port: 8080
      allowCidrs: "127.0.0.1"
    service:
      create: true
      type: LoadBalancer
      externalTrafficPolicy: Local
      annotations: {}
      extraLabels: {}
      loadBalancerIP: ""
      externalIPs: []
      loadBalancerSourceRanges: []
      # name: nginx-ingress
      # allocateLoadBalancerNodePorts: false
      # ipFamilyPolicy: SingleStack
      # ipFamilies:
      #   - IPv6
      httpPort:
        enable: true
        port: 80
        # nodePort: 80
        targetPort: 80
      httpsPort:
        enable: true
        port: 443
        # nodePort: 443
        targetPort: 443
      customPorts: []
    serviceAccount:
      annotations: {}
      # name: nginx-ingress
      imagePullSecretName: ""
    serviceMonitor:
      create: false
      # name: nginx-ingress
      labels: {}
      selectorMatchLabels: {}
      endpoints: []
    reportIngressStatus:
      enable: true
      # externalService: nginx-ingress
      ## controller.reportIngressStatus.enable must be set to true.
      ingressLink: ""
      enableLeaderElection: true
      # leaderElectionLockName: "nginx-ingress-leader-election"
      annotations: {}
    pod:
      annotations: {}
      extraLabels: {}
    # priorityClassName: ""
    readyStatus:
      enable: true
      port: 8081
      initialDelaySeconds: 0
    enableLatencyMetrics: false
    disableIPV6: false
  ## Configure root filesystem as read-only and add volumes for temporary data.
  readOnlyRootFilesystem: false
  rbac:
    create: true
  prometheus:
    create: true
    port: 9113
    secret: ""
    scheme: http
  serviceInsight:
    create: false
    port: 9114
    secret: ""
    scheme: http
  nginxServiceMesh:
    enable: false
    enableEgress: false
 ```

|Parameter | Description | Default |
| --- | --- | --- |
|`controller.name` | The name of the Ingress Controller daemonset or deployment. | Autogenerated |
|`controller.kind` | The kind of the Ingress Controller installation - deployment or daemonset. | deployment |
|`controller.annotations` | Allows for setting of `annotations` for deployment or daemonset. | {} |
|`controller.nginxplus` | Deploys the Ingress Controller for NGINX Plus. | false |
|`controller.nginxReloadTimeout` | The timeout in milliseconds which the Ingress Controller will wait for a successful NGINX reload after a change or at the initial start. | 60000 |
|`controller.hostNetwork` | Enables the Ingress Controller pods to use the host's network namespace. | false |
|`controller.dnsPolicy` | DNS policy for the Ingress Controller pods. | ClusterFirst |
|`controller.nginxDebug` | Enables debugging for NGINX. Uses the `nginx-debug` binary. Requires `error-log-level: debug` in the ConfigMap via `controller.config.entries`. | false |
|`controller.logLevel` | The log level of the Ingress Controller. | 1 |
|`controller.image.digest` | The image digest of the Ingress Controller. | None |
|`controller.image.repository` | The image repository of the Ingress Controller. | nginx/nginx-ingress |
|`controller.image.tag` | The tag of the Ingress Controller image. | 3.3.2 |
|`controller.image.pullPolicy` | The pull policy for the Ingress Controller image. | IfNotPresent |
|`controller.lifecycle` | The lifecycle of the Ingress Controller pods. | {} |
|`controller.customConfigMap` | The name of the custom ConfigMap used by the Ingress Controller. If set, then the default config is ignored. | "" |
|`controller.config.name` | The name of the ConfigMap used by the Ingress Controller. | Autogenerated |
|`controller.config.annotations` | The annotations of the Ingress Controller configmap. | {} |
|`controller.config.entries` | The entries of the ConfigMap for customizing NGINX configuration. See [ConfigMap resource docs](https://docs.nginx.com/nginx-ingress-controller/configuration/global-configuration/configmap-resource/) for the list of supported ConfigMap keys. | {} |
|`controller.customPorts` | A list of custom ports to expose on the NGINX Ingress Controller pod. Follows the conventional Kubernetes yaml syntax for container ports. | [] |
|`controller.defaultTLS.cert` | The base64-encoded TLS certificate for the default HTTPS server. **Note:** It is recommended that you specify your own certificate. Alternatively, omitting the default server secret completely will configure NGINX to reject TLS connections to the default server. |
|`controller.defaultTLS.key` | The base64-encoded TLS key for the default HTTPS server. **Note:** It is recommended that you specify your own key. Alternatively, omitting the default server secret completely will configure NGINX to reject TLS connections to the default server. |
|`controller.defaultTLS.secret` | The secret with a TLS certificate and key for the default HTTPS server. The value must follow the following format: `<namespace>/<name>`. Used as an alternative to specifying a certificate and key using `controller.defaultTLS.cert` and `controller.defaultTLS.key` parameters. **Note:** Alternatively, omitting the default server secret completely will configure NGINX to reject TLS connections to the default server. | None |
|`controller.wildcardTLS.cert` | The base64-encoded TLS certificate for every Ingress/VirtualServer host that has TLS enabled but no secret specified. If the parameter is not set, for such Ingress/VirtualServer hosts NGINX will break any attempt to establish a TLS connection. | None |
|`controller.wildcardTLS.key` | The base64-encoded TLS key for every Ingress/VirtualServer host that has TLS enabled but no secret specified. If the parameter is not set, for such Ingress/VirtualServer hosts NGINX will break any attempt to establish a TLS connection. | None |
|`controller.wildcardTLS.secret` | The secret with a TLS certificate and key for every Ingress/VirtualServer host that has TLS enabled but no secret specified. The value must follow the following format: `<namespace>/<name>`. Used as an alternative to specifying a certificate and key using `controller.wildcardTLS.cert` and `controller.wildcardTLS.key` parameters. | None |
|`controller.nodeSelector` | The node selector for pod assignment for the Ingress Controller pods. | {} |
|`controller.terminationGracePeriodSeconds` | The termination grace period of the Ingress Controller pod. | 30 |
|`controller.tolerations` | The tolerations of the Ingress Controller pods. | [] |
|`controller.affinity` | The affinity of the Ingress Controller pods. | {} |
|`controller.topologySpreadConstraints` | The topology spread constraints of the Ingress controller pods. | {} |
|`controller.env` | The additional environment variables to be set on the Ingress Controller pods. | [] |
|`controller.volumes` | The volumes of the Ingress Controller pods. | [] |
|`controller.volumeMounts` | The volumeMounts of the Ingress Controller pods. | [] |
|`controller.initContainers` | InitContainers for the Ingress Controller pods. | [] |
|`controller.extraContainers` | Extra (eg. sidecar) containers for the Ingress Controller pods. | [] |
|`controller.resources` | The resources of the Ingress Controller pods. | requests: cpu=100m,memory=128Mi |
|`controller.replicaCount` | The number of replicas of the Ingress Controller deployment. | 1 |
|`controller.ingressClass.name` | A class of the Ingress Controller. An IngressClass resource with the name equal to the class must be deployed. Otherwise, the Ingress Controller will fail to start. The Ingress Controller only processes resources that belong to its class - i.e. have the "ingressClassName" field resource equal to the class. The Ingress Controller processes all the VirtualServer/VirtualServerRoute/TransportServer resources that do not have the "ingressClassName" field for all versions of Kubernetes. | nginx |
|`controller.ingressClass.create` | Creates a new IngressClass object with the name `controller.ingressClass.name`. Set to `false` to use an existing ingressClass created using `kubectl` with the same name. If you use `helm upgrade`, do not change the values from the previous release as helm will delete IngressClass objects managed by helm. If you are upgrading from a release earlier than 3.3.2, do not set the value to false. | true |
|`controller.ingressClass.setAsDefaultIngress` | New Ingresses without an `"ingressClassName"` field specified will be assigned the class specified in `controller.ingressClass.name`. Requires `controller.ingressClass.create`.  | false |
|`controller.watchNamespace` | Comma separated list of namespaces the Ingress Controller should watch for resources. By default the Ingress Controller watches all namespaces. Mutually exclusive with `controller.watchNamespaceLabel`. Please note that if configuring multiple namespaces using the Helm cli `--set` option, the string needs to wrapped in double quotes and the commas escaped using a backslash - e.g. `--set controller.watchNamespace="default\,nginx-ingress"`. | "" |
|`controller.watchNamespaceLabel` | Configures the Ingress Controller to watch only those namespaces with label foo=bar. By default the Ingress Controller watches all namespaces. Mutually exclusive with `controller.watchNamespace`. | "" |
|`controller.watchSecretNamespace` | Comma separated list of namespaces the Ingress Controller should watch for resources of type Secret. If this arg is not configured, the Ingress Controller watches the same namespaces for all resources. See `controller.watchNamespace` and `controller.watchNamespaceLabel`. Please note that if configuring multiple namespaces using the Helm cli `--set` option, the string needs to wrapped in double quotes and the commas escaped using a backslash - e.g. `--set controller.watchSecretNamespace="default\,nginx-ingress"`. | "" |
|`controller.enableCustomResources` | Enable the custom resources. | true |
|`controller.enablePreviewPolicies` | Enable preview policies. This parameter is deprecated. To enable OIDC Policies please use `controller.enableOIDC` instead. | false |
|`controller.enableOIDC` | Enable OIDC policies. | false |
|`controller.enableTLSPassthrough` | Enable TLS Passthrough on default port 443. Requires `controller.enableCustomResources`. | false |
|`controller.tlsPassThroughPort` | Set the port for the TLS Passthrough. Requires `controller.enableCustomResources` and `controller.enableTLSPassthrough`.  | 443 |
|`controller.enableCertManager` | Enable x509 automated certificate management for VirtualServer resources using cert-manager (cert-manager.io). Requires `controller.enableCustomResources`. | false |
|`controller.enableExternalDNS` | Enable integration with ExternalDNS for configuring public DNS entries for VirtualServer resources using [ExternalDNS](https://github.com/kubernetes-sigs/external-dns). Requires `controller.enableCustomResources`. | false |
|`controller.globalConfiguration.create` | Creates the GlobalConfiguration custom resource. Requires `controller.enableCustomResources`. | false |
|`controller.globalConfiguration.spec` | The spec of the GlobalConfiguration for defining the global configuration parameters of the Ingress Controller. | {} |
|`controller.enableSnippets` | Enable custom NGINX configuration snippets in Ingress, VirtualServer, VirtualServerRoute and TransportServer resources. | false |
|`controller.healthStatus` | Add a location "/nginx-health" to the default server. The location responds with the 200 status code for any request. Useful for external health-checking of the Ingress Controller. | false |
|`controller.healthStatusURI` | Sets the URI of health status location in the default server. Requires `controller.healthStatus`. | "/nginx-health" |
|`controller.nginxStatus.enable` | Enable the NGINX stub_status, or the NGINX Plus API. | true |
|`controller.nginxStatus.port` | Set the port where the NGINX stub_status or the NGINX Plus API is exposed. | 8080 |
|`controller.nginxStatus.allowCidrs` | Add IP/CIDR blocks to the allow list for NGINX stub_status or the NGINX Plus API. Separate multiple IP/CIDR by commas. | 127.0.0.1,::1 |
|`controller.priorityClassName` | The PriorityClass of the Ingress Controller pods. | None |
|`controller.service.create` | Creates a service to expose the Ingress Controller pods. | true |
|`controller.service.type` | The type of service to create for the Ingress Controller. | LoadBalancer |
|`controller.service.externalTrafficPolicy` | The externalTrafficPolicy of the service. The value Local preserves the client source IP. | Local |
|`controller.service.annotations` | The annotations of the Ingress Controller service. | {} |
|`controller.service.extraLabels` | The extra labels of the service. | {} |
|`controller.service.loadBalancerIP` | The static IP address for the load balancer. Requires `controller.service.type` set to `LoadBalancer`. The cloud provider must support this feature. | "" |
|`controller.service.externalIPs` | The list of external IPs for the Ingress Controller service. | [] |
|`controller.service.clusterIP` | The clusterIP for the Ingress Controller service, autoassigned if not specified. | "" |
|`controller.service.loadBalancerSourceRanges` | The IP ranges (CIDR) that are allowed to access the load balancer. Requires `controller.service.type` set to `LoadBalancer`. The cloud provider must support this feature. | [] |
|`controller.service.name` | The name of the service. | Autogenerated |
|`controller.service.customPorts` | A list of custom ports to expose through the Ingress Controller service. Follows the conventional Kubernetes yaml syntax for service ports. | [] |
|`controller.service.httpPort.enable` | Enables the HTTP port for the Ingress Controller service. | true |
|`controller.service.httpPort.port` | The HTTP port of the Ingress Controller service. | 80 |
|`controller.service.httpPort.nodePort` | The custom NodePort for the HTTP port. Requires `controller.service.type` set to `NodePort`. | "" |
|`controller.service.httpPort.targetPort` | The target port of the HTTP port of the Ingress Controller service. | 80 |
|`controller.service.httpsPort.enable` | Enables the HTTPS port for the Ingress Controller service. | true |
|`controller.service.httpsPort.port` | The HTTPS port of the Ingress Controller service. | 443 |
|`controller.service.httpsPort.nodePort` | The custom NodePort for the HTTPS port. Requires `controller.service.type` set to `NodePort`. | "" |
|`controller.service.httpsPort.targetPort` | The target port of the HTTPS port of the Ingress Controller service. | 443 |
|`controller.serviceAccount.annotations` | The annotations of the Ingress Controller service account. | {} |
|`controller.serviceAccount.name` | The name of the service account of the Ingress Controller pods. Used for RBAC. | Autogenerated |
|`controller.serviceAccount.imagePullSecretName` | The name of the secret containing docker registry credentials. Secret must exist in the same namespace as the helm release. | "" |
|`controller.serviceMonitor.name` | The name of the serviceMonitor. | Autogenerated |
|`controller.serviceMonitor.create` | Create a ServiceMonitor custom resource. | false |
|`controller.serviceMonitor.labels` | Kubernetes object labels to attach to the serviceMonitor object. | "" |
|`controller.serviceMonitor.selectorMatchLabels` | A set of labels to allow the selection of endpoints for the ServiceMonitor. | "" |
|`controller.serviceMonitor.endpoints` | A list of endpoints allowed as part of this ServiceMonitor. | "" |
|`controller.reportIngressStatus.enable` | Updates the address field in the status of Ingress resources with an external address of the Ingress Controller. You must also specify the source of the external address either through an external service via `controller.reportIngressStatus.externalService`, `controller.reportIngressStatus.ingressLink` or the `external-status-address` entry in the ConfigMap via `controller.config.entries`. **Note:** `controller.config.entries.external-status-address` takes precedence over the others. | true |
|`controller.reportIngressStatus.externalService` | Specifies the name of the service with the type LoadBalancer through which the Ingress Controller is exposed externally. The external address of the service is used when reporting the status of Ingress, VirtualServer and VirtualServerRoute resources. `controller.reportIngressStatus.enable` must be set to `true`. The default is autogenerated and enabled when `controller.service.create` is set to `true` and `controller.service.type` is set to `LoadBalancer`. | Autogenerated |
|`controller.reportIngressStatus.ingressLink` | Specifies the name of the IngressLink resource, which exposes the Ingress Controller pods via a BIG-IP system. The IP of the BIG-IP system is used when reporting the status of Ingress, VirtualServer and VirtualServerRoute resources. `controller.reportIngressStatus.enable` must be set to `true`. | "" |
|`controller.reportIngressStatus.enableLeaderElection` | Enable Leader election to avoid multiple replicas of the controller reporting the status of Ingress resources. `controller.reportIngressStatus.enable` must be set to `true`. | true |
|`controller.reportIngressStatus.leaderElectionLockName` | Specifies the name of the ConfigMap, within the same namespace as the controller, used as the lock for leader election. controller.reportIngressStatus.enableLeaderElection must be set to true. | Autogenerated |
|`controller.reportIngressStatus.annotations` | The annotations of the leader election configmap. | {} |
|`controller.pod.annotations` | The annotations of the Ingress Controller pod. | {} |
|`controller.pod.extraLabels` | The additional extra labels of the Ingress Controller pod. | {} |
|`controller.appprotect.enable` | Enables the App Protect WAF module in the Ingress Controller. | false |
|`controller.appprotectdos.enable` | Enables the App Protect DoS module in the Ingress Controller. | false |
|`controller.appprotectdos.debug` | Enable debugging for App Protect DoS. | false |
|`controller.appprotectdos.maxDaemons` | Max number of ADMD instances. | 1 |
|`controller.appprotectdos.maxWorkers` | Max number of nginx processes to support. | Number of CPU cores in the machine |
|`controller.appprotectdos.memory` | RAM memory size to consume in MB. | 50% of free RAM in the container or 80MB, the smaller |
|`controller.readyStatus.enable` | Enables the readiness endpoint `"/nginx-ready"`. The endpoint returns a success code when NGINX has loaded all the config after the startup. This also configures a readiness probe for the Ingress Controller pods that uses the readiness endpoint. | true |
|`controller.readyStatus.port` | The HTTP port for the readiness endpoint. | 8081 |
|`controller.readyStatus.initialDelaySeconds` | The number of seconds after the Ingress Controller pod has started before readiness probes are initiated. | 0 |
|`controller.enableLatencyMetrics` | Enable collection of latency metrics for upstreams. Requires `prometheus.create`. | false |
|`controller.minReadySeconds` | Specifies the minimum number of seconds for which a newly created Pod should be ready without any of its containers crashing, for it to be considered available. [docs](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#min-ready-seconds) | 0 |
|`controller.autoscaling.enabled` | Enables HorizontalPodAutoscaling. | false |
|`controller.autoscaling.annotations` | The annotations of the Ingress Controller HorizontalPodAutoscaler. | {} |
|`controller.autoscaling.minReplicas` | Minimum number of replicas for the HPA. | 1 |
|`controller.autoscaling.maxReplicas` | Maximum number of replicas for the HPA. | 3 |
|`controller.autoscaling.targetCPUUtilizationPercentage` | The target CPU utilization percentage. | 50 |
|`controller.autoscaling.targetMemoryUtilizationPercentage` | The target memory utilization percentage. | 50 |
|`controller.podDisruptionBudget.enabled` | Enables PodDisruptionBudget. | false |
|`controller.podDisruptionBudget.annotations` | The annotations of the Ingress Controller pod disruption budget | {} |
|`controller.podDisruptionBudget.minAvailable` | The number of Ingress Controller pods that should be available. This is a mutually exclusive setting with "maxUnavailable". | 0 |
|`controller.podDisruptionBudget.maxUnavailable` | The number of Ingress Controller pods that can be unavailable. This is a mutually exclusive setting with "minAvailable". | 0 |
|`controller.strategy` | Specifies the strategy used to replace old Pods with new ones. Docs for [Deployment update strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy) and [Daemonset update strategy](https://kubernetes.io/docs/tasks/manage-daemon/update-daemon-set/#daemonset-update-strategy) | {} |
|`controller.disableIPV6` | Disable IPV6 listeners explicitly for nodes that do not support the IPV6 stack. | false |
|`controller.readOnlyRootFilesystem` | Configure root filesystem as read-only and add volumes for temporary data. | false |
|`rbac.create` | Configures RBAC. | true |
|`prometheus.create` | Expose NGINX or NGINX Plus metrics in the Prometheus format. | true |
|`prometheus.port` | Configures the port to scrape the metrics. | 9113 |
|`prometheus.scheme` | Configures the HTTP scheme to use for connections to the Prometheus endpoint. | http |
|`prometheus.secret` | The namespace / name of a Kubernetes TLS Secret. If specified, this secret is used to secure the Prometheus endpoint with TLS connections. | "" |
|`prometheus.service.create` | Create a Headless service to expose prometheus metrics. Requires `prometheus.create`. | false |
|`prometheus.service.labels` | Kubernetes object labels to attach to the service object. | {service: "nginx-ingress-prometheus-service"} |
|`prometheus.serviceMonitor.create` | Create a ServiceMonitor custom resource. Requires ServiceMonitor CRD to be installed. For the latest CRD, check the latest release on the [prometheus-operator](https://github.com/prometheus-operator/prometheus-operator) GitHub repo under `example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml` | false |
|`prometheus.serviceMonitor.labels` | Kubernetes object labels to attach to the serviceMonitor object. | {} |
|`prometheus.serviceMonitor.selectorMatchLabels` | A set of labels to allow the selection of endpoints for the ServiceMonitor. | {service: "nginx-ingress-prometheus-service"} |
|`prometheus.serviceMonitor.endpoints` | A list of endpoints allowed as part of this ServiceMonitor. | [port: prometheus] |
|`serviceInsight.create` | Expose NGINX Plus Service Insight endpoint. | false |
|`serviceInsight.port` | Configures the port to expose endpoints. | 9114 |
|`serviceInsight.scheme` | Configures the HTTP scheme to use for connections to the Service Insight endpoint. | http |
|`serviceInsight.secret` | The namespace / name of a Kubernetes TLS Secret. If specified, this secret is used to secure the Service Insight endpoint with TLS connections. | "" |
|`serviceNameOverride` | Used to prevent cloud load balancers from being replaced due to service name change during helm upgrades. | "" |
|`nginxServiceMesh.enable` | Enable integration with NGINX Service Mesh. See the NGINX Service Mesh [docs](https://docs.nginx.com/nginx-service-mesh/tutorials/kic/deploy-with-kic/) for more details. Requires `controller.nginxplus`. | false |
|`nginxServiceMesh.enableEgress` | Enable NGINX Service Mesh workloads to route egress traffic through the Ingress Controller. See the NGINX Service Mesh [docs](https://docs.nginx.com/nginx-service-mesh/tutorials/kic/deploy-with-kic/#enabling-egress) for more details. Requires `nginxServiceMesh.enable`. | false |

## Notes
* The service account name cannot be overridden and needs to be set to `nginx-ingress`. This is a requirement due to the RBAC and SCC configuration on OpenShift clusters.
* The defaultServerSecret needs to be created before the IC deployment with the name of the secret supplied in the NginxIngress manifest, and cannot be created by instead supplying a cert and key.
* If required, the `controller.wildcardTLS.secret` must also be created separately with the name of the secret supplied in the NginxIngress manifest.

## Notes: Multiple NIC Deployments
* Please see [the NGINX Ingress Controller doumentation](https://docs.nginx.com/nginx-ingress-controller/installation/running-multiple-ingress-controllers/) for general information on running multiple NGINX Ingress Controllers in your cluster.
* To run multiple NIC instances deployed by the NGINX Ingress Operator in your cluster in the same namespace, `rbac.create` should be set to `false`, and the ServiceAccount and ClusterRoleBinding need to be created independently of the deployments. Please note that `controller.serviceAccount.imagePullSecretName` will also be ignored in this configuration, and will need to be configured as part of the independant ServiceAccount creation.
* The ClusterRoleBinding needs to configured to bind to the `nginx-ingress-operator-nginx-ingress-admin` ClusterRole.
* See [RBAC example spec](../resources/rbac-example.yaml) for an example ServiceAccount and ClusterRoleBinding manifest.
* To run multiple NIC instances deployed by the NGINX Ingress Operator in your cluster in any namespace but sharing an IngressClass, `controller.ingressClass` should be set to an empty string and the IngressClass resource needs to be created independantly of the deployments.Please note that `controller.setAsDefaultIngress` will also be ignored in this configuration, and will need to be configured as part of the independant IngressClass creation.
* See [IngressClass example spec](../resources/ingress-class.yaml) for an example IngressClass manifest.
