1) Components of Kubernetes Master:
 Container Runtine(Docker)
 etcd
 kube-scheduler
 kube-apiserver
 kube controller manager

2) Components of Kubernetes Node:
 Container Runtine(Docker)
 kubelet
 kube-proxy

3) kube-apiserver:
It acts as frontend for the kubernetes control plane. It exposes the Kubernetes API
CLItools (like kubectl), Users and even Master components (scheduler, controller manager, etcd) and worker node components like (kubelet) everything talk with API Server

4) etcd:
Consistent and highly-available key value store used as kubernetes backing store for all cluster data.
It stores all the masters and worker node information. 

5) kube-scheduler:
Scheduler is responsible for distributing containers across multiple nodes
It watches for newly created Pods with no assigned node, and selects a node for them to run on. 

6) kube-controller-manager:
Controllers are responsible for noticing and responding when nodes, containers or endpoints go down. They make decisions to bring up new containers in such cases. 
- Node Controller: Responsible for noticing and responding when nodes go down. 
- Replication Controller: Responsible for maintaining the correct number of pods for every replication controller object in the system. 
- Endpoints Controller: Populates the Endpoints object(that is, json services & pods)
- Service Account & Token Controller: Creates default accounts and API Access for new namespaces. 

7) Cloud-controller-manager:
A Kubernetes control plane component that embeds cloud-specific control logic.
It only runs controllers that are specific to your cloud provider. 
On-Premise Kubernetes clusters will not have this component.
- Node controller: For checking the cloud provider to determine if a node has been deleted in the cloud after it stops responding
- Route controller: For setting up routes in the underlying cloud infrastructure. 
- Service Controller: For creating, updating and deleting cloud provider load balancer. 


8) Container Runtime:
Container Runtime is the underlying software where we run all these Kubernetes components. 
We are using Docker, but we have other runtime options like rkt, container-d etc. 

9) Kubelet: 
Kubelet is the agent that runs on every node in the cluster.
This agent is responsible for making sure that containers are running in a Pod on a node.

10) Kube-Proxy:
It is a network proxy that runs on each node in your cluster.
It maintains network rules on nodes
In short, these network rules allow network communication to your Pods from network sessions inside or outside of your cluster. 

- Node port range: 30000 - 32767

- ClusterIP vs NodePort vs LoadBalancer:

11) ClusterIP: Exposes the service on a cluster-internal IP. Choosing this value makes the service only reachable from within the cluster. This is the default ServiceType

12) NodePort: Exposes the service on each Node’s IP at a static port (the NodePort). A ClusterIP service, to which the NodePort service will route, is automatically created. You’ll be able to contact the NodePort service, from outside the cluster, by requesting <NodeIP>:<NodePort>.

13) LoadBalancer: Exposes the service externally using a cloud provider’s load balancer. NodePort and ClusterIP services, to which the external load balancer will route, are automatically created.



14) What is node affinity?

Node affinity is a set of rules used by the scheduler to determine where a pod can be placed. 

15) What is tain and toleration?
Taints are used to repel Pods from specific nodes. Instead of applying the label to a node, we apply a taint that tells a scheduler to repel Pods from this node if it does not match the taint. Only those Pods that have a toleration for the taint can be let into the node with that taint.


16) How do the kubelet and container runtine writes for the following:
machines with systemd
machines without systemd


17) what is make file 
It consists of commands and their respective executions 

18) Deamonset
A DaemonSet ensures that all (or some) Nodes run a copy of a Pod. As nodes are added to the cluster, Pods are added to them. As nodes are removed from the cluster, those Pods are garbage collected. Deleting a DaemonSet will clean up the Pods it created.
Some typical uses of a DaemonSet are:
 . running a cluster storage daemon on every node
 . running a logs collection daemon on every node
 . running a node monitoring daemon on every node


19) ingress controller
Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource.

Each path in an Ingress is required to have a corresponding path type. Paths that do not include an explicit pathType will fail validation. There are three supported path types:

 . ImplementationSpecific: With this path type, matching is up to the IngressClass. Implementations can treat this as a separate pathType or treat it identically to Prefix or Exact path types.
 . Exact: Matches the URL path exactly and with case sensitivity.
 . Prefix: Matches based on a URL path prefix split by /. Matching is case sensitive and done on a path element by element basis.


20) What is init containers:
A Pod can have multiple containers running apps within it, but it can also have one or more init containers, which are run before the app containers are started.

Init containers are exactly like regular containers, except:
 . Init containers always run to completion.
 . Each init container must complete successfully before the next one starts.


21) Stateful set:
StatefulSet is the workload API object used to manage stateful applications.

Manages the deployment and scaling of a set of Pods, and provides guarantees about the ordering and uniqueness of these Pods.
StatefulSets are valuable for applications that require one or more of the following.

Stable, unique network identifiers.
Stable, persistent storage.
Ordered, graceful deployment and scaling.
Ordered, automated rolling updates.

22) Liveness and Readiness probes:
Liveness: Many applications running for long periods of time eventually transition to broken states, and cannot recover except by being restarted. Kubernetes provides liveness probes to detect and remedy such situations.

23) Readiness probe: Sometimes, applications are temporarily unable to serve traffic. For example, an application might need to load large data or configuration files during startup, or depend on external services after startup. In such cases, you don't want to kill the application, but you don't want to send it requests either. Kubernetes provides readiness probes to detect and mitigate these situations. A pod with containers reporting that they are not ready does not receive traffic through Kubernetes Services.

Caution: Liveness probes do not wait for readiness probes to succeed. If you want to wait before executing a liveness probe you should use initialDelaySeconds or a startupProbe.

24) Kubernetes starts with four initial namespaces:
- default: The default namespace for objects with no other namespace
- kube-system: The namespace for objects created by the Kubernetes system
- kube-public: This namespace is created automatically and is readable by all users (including those not authenticated). This namespace is mostly reserved for cluster usage, in case that some resources should be visible and readable publicly throughout the whole cluster. The public aspect of this namespace is only a convention, not a requirement.
- kube-node-lease: This namespace holds Lease objects associated with each node. Node leases allow the kubelet to send heartbeats so that the control plane can detect node failure


FAQs:
Can we have multiple containers in a Pod?

Can we have similar containers in a Pod?

What are liveness and readiness probe?

Can we deploy a pod on particular node?
use labelling(check)

Important components:
Service: 
Spec: 
  type:
  selector:
  ports:
    port:  #ClusterIo Service Port
    targetPort:  # Container Port
    nodePort:
ReplicaSet:
Spec:
  replicas:
  selector:
  template:
    metadata:
    spec:
Deployment:
Spec:
  replicas:
  selector:
  template:
    metadata:
    spec:
      containers:
        - name:
          image:
          ports:
            - containerPort:

EKS Storage:
 - EBS CSI Driver (CSI - Container Storage Interface)
 - EFS CSI Driver
 - FSx for Luster CSI



