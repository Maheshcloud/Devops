Add the Helm Stable Charts for your local client:
```sh
helm repo add stable https://charts.helm.sh/stable
```
Now add prometheus Helm repo:
```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```
Check the repos present in the helm:
```sh
helm search repo prometheus-community
```
Create Prometheus namespace:
```sh
kubectl create namespace prometheus
```
Install kube prometheus stack(kube-prometheus-stack it was formerly known as prometheus-operator):
```sh
helm install stable prometheus-community/kube-prometheus-stack -n prometheus
```
Once installed, check all the resources created by this helm chart

If we check the service, all the services are using ClusterIP, but to access Prometheus and Grafana we need loadbalancer or nodeport. So make below changes

Edit Prometheus service: 
```sh
kubectl edit svc stable-kube-prometheus-sta-prometheus -n prometheus
```
Edit type to loadbalancer or nodeport

Edit Grafana service:
```sh
kubectl edit svc stable-grafana -n prometheus
```
Edit type to loadbalancer or nodeport

Grab the URL and check if its working

Credentials for Grafana Dashboard:

UserName: admin 
Password: prom-operator

In Grafana, we need to import dashboards 

To create dashboard to monitor cluster load 12740 or 3119 id

To create dashboard to monitor POD load 6417 id




