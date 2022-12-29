1.	How SSO works (OAuth2, OpenID, SAML 2.0), keycloak
Ans: SAML 2.0(Security Assertion Markup language)
-	Principle(user requesting)
-	Service Provider – it will generate SAML auth request & Redirect to windows AD 
- Identity Provider(Active Directory) – SAML Token will be sent to the source, then user will contact Service Provider with the Token

Validity of the token will have some time in hours

2.	What type of test is carried out (Unit Test), SonarQube, Sonarqube API's 
- Unit test
- Sonar Qube – for code quality
- SAST (Static Application Security Testing) - Fortify/Checkmarx
- SCA(Softwate Composition Analysis) - Fortify/Snyk
- DAST(Dynamic Application Security Testing)- OWASP ZAP
- IAST (Interactive Application Security Testing)
- IAC (Infrastructure As Code) - 
- Container security tool (Aqua/Prismacloud)

SAST is a white-box testing that analyzes source code for identity security issues.

SCA scans your code base to provide visibility into open source software components, including license compliance and security vulnerabilities. 

DAST is a type of black-box security testing in which dynamic tests are performed on the application 

IAST combines elements of both SAST and DAST and tries to overcome its limitations. It scans specific workflows of code. 

3.	What is Kubernetes 
Kubernetes, also known as K8s, is an open-source system for automating deployment, scaling, and management of containerized applications. Kubernetes is a container orchestration system
4.	What tools used for vanilla flavor Kubernetes 
   A vanilla Kubernetes setup includes the control-plane nodes which run etcd, the api-server, a scheduler, and the controller-manager. It also includes worker nodes, and each node runs a kubelet, kube-proxy, and a container runtime like Docker.

To operationalize a vanilla Kubernetes installation, users will need to add an ingress-managed load balancer, autoscaling, CI/CD, and install software to handle logging, monitoring, and alerting.


5.	How would you publish web application from Kubernetes? 
Ingress service 
6.	What is difference deployment and stateful set 
Ans: Deployment is a resource to deploy a stateless application, if using a PVC, all replicas will be using the same Volume and none of it will have its own state.

Statefulsets are used when state has to be persisted, is used for Stateful applications, each replica of the pod will have its own state, and will be using its own Volume.

DaemonSet is a controller similar to ReplicaSet that ensures that the pod runs on all the nodes of the cluster. If a node is added/removed from a cluster, DaemonSet automatically adds/deletes the pod.
7.	What are different deployment statergy in Kubernetes? 
Rolling Update|Recreate|Canary Deployemnt | blue green
The rolling deployment is the default deployment strategy in Kubernetes. It replaces pods, one by one, of the previous version of our application with pods of the new version without any cluster downtime.

In recreate deployment, we fully scale down the existing application version before we scale up the new application version.

In a blue/green deployment strategy (sometimes also referred to as red/black), the blue represents the current application version, and green represents the new application version. In this, only one version is live at a time. Traffic is routed to the blue deployment while the green deployment is created and tested. After we are finished testing, we then route traffic to the new version.

In canary deployment, the new version of the application is gradually deployed to the Kubernetes cluster while getting a very small amount of live traffic. In this approach, we have two almost identical servers: one that goes to all the current active users and another with the new features that gets rolled out to a subset of users and then compared. When no errors are reported and the confidence increases, the new version can gradually roll out to the rest of the infrastructure. In the end, all live traffic goes to canaries, making the canary version the new production version.

8.	What is difference bettween SQL & NOSQL? 
SQL is primarily called RDBMS or Relational Databases, whereas NoSQL is a Non-relational or Distributed Database.
SQL databases are table-based databases, whereas NoSQL databases can be document-based, key-value pairs, and graph databases.
SQL databases are vertically scalable, while NoSQL databases are horizontally scalable.
SQL databases have a predefined schema, whereas NoSQL databases use a dynamic schema for unstructured data.
9.	which tools used to do the versioning of Database? 
Sqitch, dolt
Sqitch is an effective data versioning tool that can be used for any database engine, application framework, or development environment.

Dolt is a SQL database that works similarly to a git repository in terms of forking, cloning, branching, merging, pushing, and pulling. Dolt allows data and structure to change in tandem to improve the user experience of a version control database.
10.	What common GIT commands used 
Git status, git pull, git commit -m “”, git add ., git push
11. How will you deal with merge confict 

************************************************************************************************************************ GIT -------- 
1.	Whats the Branching statergy 
Branching allows teams of developers to easily collaborate inside of one central code base. When a developer creates a branch, the version control system creates a copy of the code base at that point in time. Changes to the branch don't affect other developers on the team.
Different types of branches: 
- Feature branch
- hotfix branch
- release branch
2. Diffence between Git Fecth & Pull 
Git Fetch is the command that tells the local repository that there are changes available in the remote repository without bringing the changes into the local repository. Git Pull on the other hand brings the copy of the remote directory changes into the local repository.
************************************************************************************************************************ Terraform ---------- 
1.	Most used command in terraform 
Terraform init, terraform plan, terraform apply, terraform fmt
2.	What do you understand by terraform backend? 
A backend defines where Terraform stores its state data files. Terraform uses persisted state data to keep track of the resources it manages. Most non-trivial Terraform configurations either integrate with Terraform Cloud or use a backend to store state remotely.
3.	What are modules in Terraform? 
A Terraform module is a set of Terraform configuration files in a single directory. Even a simple configuration consisting of a single directory with one or more .tf files is a module. When you run Terraform commands directly from such a directory, it is considered the root module.
4.	Does Terraform support multi-provider deployments? 
Yes, We can’t write two or more providers with the same name i.e. two AWS providers. If there’s any such need the terraform has provided a way to do that which is to use alias argument. A provider block without an alias argument is the default configuration for that provider.
5.	How to run one tf file for multipl env 
We can use workspaces or we can use terragrunt
************************************************************************************************************************ AWS ----- 
1.	IAM- Assume role 
Assuming a role means asking Security Token Service (STS) to provide you with a set of temporary credentials -- role credentials -- that are specific to the role you want to assume. (Specifically, a new "session" with that role.)

You can optionally include a policy with this request, which will serve to limit the permissions of the temporary credentials to only a subset of what the role's policies would have allowed.
2.	Best security principles 
There are seven design principles for security in the cloud:
•	Implement a strong identity foundation
•	Enable traceability
•	Apply security at all layers
•	Automate security best practices
•	Protect data in transit and at rest
•	Keep people a	way from data
•	Prepare for security events

3.	What are the key elements in the JSON schema of a policy? 
Version, Statement,sid, effect, principal, action, resource 
4.	RDS - DR statergy 
For a production environment, it is important to take precautions so that you can recover if there’s an unexpected event. While Amazon RDS provides a highly available Multi-AZ configuration, it can’t protect from every possibility, such as a natural disaster, a malicious actor, or logical corruption of a database. To maintain business continuity, it is important to design and test a DR plan.

Recovery time objective (RTO) and recovery point objective (RPO) are two key metrics to consider when developing a DR plan. RTO represents how many hours it takes you to return to a working state after a disaster. RPO, which is also expressed in hours, represents how much data you could lose when a disaster happens.

DR options available for RDS:
- DB Instance snapshots
- Read replicas
- Cross account replicas
5. What is AWS s3 copy and S3 sync command?
aws s3 cp will copy all files, even if they already exist in the destination area. It also will not delete files from your destination if they are deleted from the source.
aws s3 sync looks at the destination before copying files over and only copies over files that are new and updated. The --delete flag also will delete things at the destination if they were removed in source.
5.	How to copy S3 data from one account to another account 
Copying objects between buckets within an AWS account is a standard, simple process for S3 users. To copy AWS S3 objects from one bucket to another you can use the AWS CLI. In its simplest form, the following command copies all objects from bucket1 to bucket2:aws s3 sync s3://bucket1 s3://bucket2

But moving objects from one AWS account to a bucket owned by another account is a different matter because a bucket can only be written by its owner.

The first step is to change the permissions of the account. Managing permissions of AWS S3 objects and buckets can be done using Access Control Lists (ACLs) and bucket policies. The drawback is that object ACLs are not inherited from bucket ACLs. That’s why you should use a bucket policy that allows cross-account bucket copying. A bucket policy overrides ACLs.

- Create two AWS S3 buckets in two separate accounts.
- Create an AWS IAM policy in the destination account that will allow reading the source bucket and writing the destination bucket.
- Create an IAM user in the destination account, and connect to the IAM policy.
- Create a bucket-policy that will allow the destination account to get objects from the source bucket.
- Copy the objects from the source bucket to the destination bucket, using the AWS CLI.
6. How do you allow a user to gain access to a specific bucket?
We can create a policy and attach it to the bucket
Open the bucket  Click on Permissions  Enter Bucket Policy 
7. How can you monitor S3 cross-region replication to ensure consistency without actually checking the bucket? 
8. What is SnowBall? 
AWS Snowball is a service that provides secure, rugged devices, so you can bring AWS computing and storage capabilities to your edge environments, and transfer data into and out of AWS.
9. VPC architechture 
10. What is VPC endpoint used for 
A VPC endpoint allows you to privately connect your VPC to supported AWS services. It doesn't require you to deploy an internet gateway, network address translation (NAT) device, Virtual Private Network (VPN) connection, or AWS Direct Connect connection.
11.	How to connect to AWS resources privately 
A virtual private network (VPN)
AWS Direct Connect (DX)
A VPC endpoint


12. What is the difference between AWS gateway endpoint and interface endpoint? 
A VPC endpoint enables you to privately connect your VPC to supported AWS services and VPC endpoint services powered by AWS PrivateLink without requiring an internet gateway, NAT device, VPN connection, or AWS Direct Connect connection. Instances in your VPC do not require public IP addresses to communicate with resources in the service. Traffic between your VPC and the other service does not leave the Amazon network.

There are two types of VPC endpoints: interface endpoints and gateway endpoints.

An interface endpoint is powered by PrivateLink, and uses an elastic network interface (ENI) as an entry point for traffic destined to the service.

A gateway endpoint serves as a target for a route in your route table for traffic destined for the service
13. Whats the Use of NAT gateway 
A NAT gateway is a Network Address Translation (NAT) service. You can use a NAT gateway so that instances in a private subnet can connect to services outside your VPC but external services cannot initiate a connection with those instances.

************************************************************************************************************************ K8s ---- 
1. Kube arechitechture 
1. What is Kublet and its purpose 
The kubelet is the primary "node agent" that runs on each node. It can register the node with the apiserver using one of: the hostname; a flag to override the hostname; or specific logic for a cloud provider. The kubelet works in terms of a PodSpec. A PodSpec is a YAML or JSON object that describes a pod.
2.Different Services used in K8s 
ClusterIP. Exposes a service which is only accessible from within the cluster.
NodePort. Exposes a service via a static port on each node’s IP.
LoadBalancer. Exposes the service via the cloud provider’s load balancer.
ExternalName. Maps a service to a predefined externalName field by returning a value for the CNAME record.

3.Purpose of kube scheduler 
The Kubernetes scheduler is a control plane process which assigns Pods to Nodes. The scheduler determines which Nodes are valid placements for each Pod in the scheduling queue according to constraints and available resources. The scheduler then ranks each valid Node and binds the Pod to a suitable Node

4. What is probe used for and whats different types of probe 
Liveness, Readiness and Startup Probes
 Liveness: Many applications running for long periods of time eventually transition to broken states, and cannot recover except by being restarted. Kubernetes provides liveness probes to detect and remedy such situations.
Readiness probe: Sometimes, applications are temporarily unable to serve traffic. For example, an application might need to load large data or configuration files during startup, or depend on external services after startup. In such cases, you don't want to kill the application, but you don't want to send it requests either. Kubernetes provides readiness probes to detect and mitigate these situations. A pod with containers reporting that they are not ready does not receive traffic through Kubernetes Services.
Startup probe: The kubelet uses startup probes to know when a container application has started. If such a probe is configured, it disables liveness and readiness checks until it succeeds, making sure those probes don't interfere with the application startup
5. What is ingress and how its used 
Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource.
6.	Whats deployment and whats types of deployment statergy
Different stages in Jenkins: 
Checkout Code, Validate, Compile, Unit testing, Integration testing, static code analysis(SonarQube), Build container image, image security scanning(Twistlock), push, deploy

How does http and https work?

