Linux: 
1. How to check the list of installed packages?

apt list --installed | head
apt list | head
dpkg is a package manager for Debian-based systems.

dpkg --get-selections | grep -w "install" | head

dpkg-query -l | head

2. Command to check kernal version

The uname command in Linux is used to gather information about the system and its kernel. It stands for "Unix Name" and offers several options to display different types of information.

uname -r

To check the kernel version in Linux we can use the hostnamectl command.
hostnamectl
hostnamectl | grep 'Kernel:'

The /proc/version file in Linux contains valuable information about the Linux kernel version, compiler details, and build information. It acts as a virtual file that you can access to obtain kernel-related data. To check the kernel version in Linux we use it to display the content of the proc/version file. To check the kernel version in Linux using the /proc/version file, open a terminal and enter the following command:
cat /proc/version

The dmesg command in Linux displays the kernel ring buffer messages. It enables you to see and analyze the system and kernel messages that are generated during the boot process or while the system is running. To check the kernel version in Linux using the dmesg command, open a terminal and enter the following command:
dmesg | grep Linux

3. How to create a new user and add it as sudo?

adduser <username>

usermod -aG sudo <username>

4. Command to check if a process called 'a' is running or not. If running how to stop it
5. Command to list all files less than 5mb
find /var/log -maxdepth 1 -size -5M -type f -printf '%5k %f\n'
-maxdepth 1 tells find not to descend into subdirectories. (If you want subdirectories to be included, omit this)

-size -5M tells find to limit the results to file less than 5M in size.

-type f tells find to look only for regular files.

-printf '%5k %f\n' tells find to allocate 5 spaces to the size and print the size in kilobytes, followed by a space, followed by the file's name.

find /var/log/ -type f -size -5M -exec ls -lsh {} \; | awk '{ print $10 " has a size of " $1 }'

6. Hard link v/s soft link

A simple way to see the difference between a hard link and a symbolic link is through a simple example. A hard link to a file will point to the place where the file is stored, or the inode of that file. A symbolic link will point to the actual file itself.

7. Command to check disk space usage and free RAM

df -h shows disk space in human-readable format
du -h shows disk usage in human-readable format for all directories and subdirectories
fdisk -l shows disk size along with disk partitioning information


CI/CD: 
1. Git fetch vs Git pull
2. Sonarqube quality gate vs quality profile
3. What is sonar runner
4. Types of pipelines in Jenkins
5. Scripted vs Declarative pipeline
6. Should we prefer artifactory to store artifcats or should we store them in s3
7. How to upgrade plugins in Jenkins
8. Usermanagement in Jenkins
9. Concepts about Gitlab runners
10. How to upgrade Jenkins

k8s: 
1. K8s architecture
2. Deployment v/s stateful set v/s replica set
3. What is config map
A ConfigMap is an API object that lets you store configuration for other objects to use. Unlike most Kubernetes objects that have a spec , a ConfigMap has data and binaryData fields. 
These fields accept key-value pairs as their values. 

4. Role of etcd in kubernetes
The etcd stores all cluster information, such as its current state, desired state, configuration of resources, and runtime data. 

etcd monitors the various nodes and, as a result, sees which resources are free. Based on this, the control plane assigns the task to the relevant resource. 
etcd monitors the health of all nodes at regular intervals. Thus, if any node is overloaded or underused etcd possesses the applicable data. The control plane can either delete the node or reassign the task to another node. 
etcd implements several mechanisms to avoid resource starvation and ensure the availability and reliability of its services.
etcd’s features such as shared configuration, service discovery, leader election, distributed locks, and the watch API, can help address cross-communication concerns in Kubernetes. This is achieved through better synchronization and interaction among various components and services.

5. How rolling updates work in deployment?
A rolling update allows a Deployment update to take place with zero downtime. It does this by incrementally replacing the current Pods with new ones. The new Pods are scheduled on Nodes with available resources, and Kubernetes waits for those new Pods to start before removing the old Pods.

Docker: 
1. ADD v/s COPY
Although ADD and COPY are functionally similar, generally speaking, COPY is preferred. That’s because it’s more transparent than ADD. 
COPY only supports the basic copying of local files into the container, while ADD has some features (like local-only tar extraction and remote URL support) 
that are not immediately obvious. Consequently, the best use for ADD is local tar file auto-extraction into the image, as in ADD rootfs.tar.xz /.

2. Entrypoint v/s CMD
Docker has a default entrypoint which is /bin/sh -c but does not have a default command.

When you run docker like this: docker run -i -t ubuntu bash the entrypoint is the default /bin/sh -c, the image is ubuntu and the command is bash.

The command is run via the entrypoint. i.e., the actual thing that gets executed is /bin/sh -c bash. This allowed Docker to implement RUN quickly by relying on the shell's parser.

Later on, people asked to be able to customize this, so ENTRYPOINT and --entrypoint were introduced.

Everything after the image name, ubuntu in the example above, is the command and is passed to the entrypoint. When using the CMD instruction, it is exactly as if you were executing
docker run -i -t ubuntu <cmd>
The parameter of the entrypoint is <cmd>.

You will also get the same result if you instead type this command docker run -i -t ubuntu: a bash shell will start in the container because in the ubuntu Dockerfile a default CMD is specified:
CMD ["bash"].

As everything is passed to the entrypoint, you can have a very nice behavior from your images. @Jiri example is good, it shows how to use an image as a "binary". When using ["/bin/cat"] as entrypoint and then doing docker run img /etc/passwd, you get it, /etc/passwd is the command and is passed to the entrypoint so the end result execution is simply /bin/cat /etc/passwd.

Another example would be to have any cli as entrypoint. For instance, if you have a redis image, instead of running docker run redisimg redis -H something -u toto get key, you can simply have ENTRYPOINT ["redis", "-H", "something", "-u", "toto"] and then run like this for the same result: docker run redisimg get key.

To reiterate what we’ve discussed above, ENTRYPOINT and CMD are similar but separate instructions that complement each other:

ENTRYPOINT is the process that’s executed inside the container.
CMD is the default set of arguments that are supplied to the ENTRYPOINT process.
There are also differences in how you override these values when you start a container:

CMD is easily overridden by appending your own arguments to the docker run command.
ENTRYPOINT can be changed using the --entrypoint flag, but this should rarely be necessary for container images being used in the way they were intended. If you do change the ENTRYPOINT, you’ll almost certainly need to set a custom CMD too—as otherwise, your new ENTRYPOINT is likely to receive arguments that it doesn’t understand.

3. How to remove all unwanted or unused doker objects from the system?

4. Multistage docker build
Multi-stage builds help build optimized Docker images that can run anywhere. If streamlining software delivery is one of your goals, then you should definitely understand how multi-stage Docker builds work. 
The software deployments can be faster through this approach, and the image can be reused to save time and effort. Multi-stage builds are a great way to simplify your image creation process and save developers time.

In the cloud-native world, security is considered of high importance. One excellent benefit of multi-stage Docker builds is that it reduces the number of dependencies and unnecessary packages in the image, 
reducing the attack surface. In addition, it keeps it clean and lean by having only the things required to run your application in production. Else, we all end up building and pushing images that are large in 
size with vulnerabilities that can give an easy way to attackers to get into our applications. Try using multi-stage Docker builds for optimized images and security. Hope this article helped you learn more about multi-stage Docker builds and why we should use them.

5. Is docker file immutable?
Docker images are immutable, which means they can't be modified once created.Docker images are immutable, which means they can't be modified once created.
