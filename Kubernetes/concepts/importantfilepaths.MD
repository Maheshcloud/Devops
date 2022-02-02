Static pods: 
```
/etc/kubernetes/manifests
```
ConfigPath: 
#This is to get the staticpod path
```
/var/lib/kubelet/config.ymal
```


Kubernetes CNI:
Kubelet.service
```
--cni-bin-dir=/opt/cni/bin
--cni-conf-dir=/etc/cni/net.d
```
View Kubelet options: 
```
ps -aux | grep kubelet
```

#This will have all the network configuration
```
cat /etc/cni/net.d/10-bridge.conf
```

What is the path configured with all binaries of CNI supported plugins?
```
/opt/cni/bin
```

#In this location we can change the ipaddress/subnet
```
cat /etc/cni/net.d/net-script.conf 
```


```
cat /var/log/kube-proxy.log

iptables -L -t nat | grep db-service
```

For Qualified domain name:

For Service:
```
http://<servicename>.<namespace>.svc.cluster.local
```
For Pod:
```
http://<podIP>.<namespace>.pod.cluster.local
```
