# Manual installation

This will deploy the operator in the `nginx-ingress-operator-system` namespace.

1. Deploy the Operator and associated resources:

   1. Clone the `nginx-ingress-operator` repo:

   ```shell
   git clone https://github.com/nginxinc/nginx-ingress-helm-operator/ --branch v2.1.2
   cd nginx-ingress-helm-operator/
   ```

   2. To deploy the Operator and associated resources to all environments, run:

   ```shell
   make deploy IMG=nginx/nginx-ingress-operator:2.1.2
   ```

2. Check that the Operator is running:

   ```shell
   kubectl get deployments -n nginx-ingress-operator-system

   NAME                                        READY   UP-TO-DATE   AVAILABLE   AGE
   nginx-ingress-operator-controller-manager   1/1     1            1           15s
   ```

3. `OpenShift` Additional steps:

In order to deploy NGINX Ingress Controller instances into OpenShift environments, a new SCC is required to be created on the cluster which will be used to bind the specific required capabilities to the NGINX Ingress service account(s). To do so for NIC deployments, please run the following command (assuming you are logged in with administrator access to the cluster):

`kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-ingress-helm-operator/v2.1.2/resources/scc.yaml`

Alternatively, to create an SCC for NIC daemonsets, please run this command:

`kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-ingress-helm-operator/v2.1.2/resources/scc-daemonset.yaml`

You can now deploy the NGINX Ingress Controller instances.

**Note: If you're upgrading your operator installation to a later release, navigate [here](../helm-charts/nginx-ingress/) and run `kubectl apply -f crds/` or `oc apply -f crds/` as a prerequisite**
