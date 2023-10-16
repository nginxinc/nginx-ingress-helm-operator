# Manual installation

This will deploy the operator in the `nginx-ingress-operator-system` namespace.

1. Deploy the Operator and associated resources:

   1. Clone the `nginx-ingress-operator` repo:

   ```shell
   git clone https://github.com/nginxinc/nginx-ingress-helm-operator/ --branch v2.0.1
   cd nginx-ingress-helm-operator/
   ```

   2. `OpenShift` To deploy the Operator and associated resources to an OpenShift environment, run:

   ```shell
   make deploy IMG=nginx/nginx-ingress-operator:2.0.1
   ```

   3. Alternatively, to deploy the Operator and associated resources to all other environments:

   ```shell
   make deploy IMG=nginx/nginx-ingress-operator:2.0.1
   ```

2. Check that the Operator is running:

   ```shell
   kubectl get deployments -n nginx-ingress-operator-system

   NAME                                        READY   UP-TO-DATE   AVAILABLE   AGE
   nginx-ingress-operator-controller-manager   1/1     1            1           15s
   ```

3. `OpenShift` Additional steps:

In order to deploy NGINX Ingress Controller instances into OpenShift environments, a new SCC is required to be created on the cluster which will be used to bind the specific required capabilities to the NGINX Ingress service account(s). To do so for NIC deployments, please run the following command (assuming you are logged in with administrator access to the cluster):

`kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-ingress-helm-operator/v2.0.1/resources/scc.yaml`

Alternatively, to create an SCC for NIC daemonsets, please run this command:

`kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-ingress-helm-operator/v2.0.1/resources/scc-daemonset.yaml`

You can now deploy the NGINX Ingress Controller instances.
