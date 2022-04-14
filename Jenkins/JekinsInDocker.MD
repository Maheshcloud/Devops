On Windows
The Jenkins project provides a Linux container image, not a Windows container image. Be sure that your Docker for Windows installation is configured to run Linux Containers rather than Windows Containers. See the Docker documentation for instructions to switch to Linux containers. Once configured to run Linux Containers, the steps are:

1. Open up a command prompt window and similar to the macOS and Linux instructions above do the following:

2. Create a bridge network in Docker
```sh
docker network create jenkins
```
3. Run a docker:dind Docker image

```sh
docker run --name jenkins-docker --rm --detach ^
  --privileged --network jenkins --network-alias docker ^
  --env DOCKER_TLS_CERTDIR=/certs ^
  --volume jenkins-docker-certs:/certs/client ^
  --volume jenkins-data:/var/jenkins_home ^
  --publish 2376:2376 ^
  docker:dind
```
  
4. Customise official Jenkins Docker image, by executing below two steps:

  a. Create Dockerfile with the following content:
```sh
FROM jenkins/jenkins:2.332.2-jdk11
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean:1.25.3 docker-workflow:1.28"
```
  b. Build a new docker image from this Dockerfile and assign the image a meaningful name, e.g. "myjenkins-blueocean:2.332.2-1":

```sh
docker build -t myjenkins-blueocean:2.332.2-1 .
```
Keep in mind that the process described above will automatically download the official Jenkins Docker image if this hasn’t been done before.

5. Run your own myjenkins-blueocean:2.332.2-1 image as a container in Docker using the following docker run command:
```sh
docker run --name jenkins-blueocean --rm --detach ^
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 ^
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 ^
  --volume jenkins-data:/var/jenkins_home ^
  --volume jenkins-docker-certs:/certs/client:ro ^
  --publish 8080:8080 --publish 50000:50000 myjenkins-blueocean:2.332.2-1
 ```
Proceed to the Setup wizard.

##Accessing the Docker container:##
If you have some experience with Docker and you wish or need to access your Docker container through a terminal/command prompt using the docker exec command, you can add an option like --name jenkins-tutorial to the docker exec command. That will access the Jenkins Docker container named "jenkins-tutorial".

This means you could access your docker container (through a separate terminal/command prompt window) with a docker exec command like:
```sh
docker exec -it jenkins-blueocean bash
```
##Accessing the Docker logs:##
There is a possibility you may need to access the Jenkins console log, for instance, when Unlocking Jenkins as part of the Post-installation setup wizard.

The Jenkins console log is easily accessible through the terminal/command prompt window from which you executed the docker run …​ command. In case if needed you can also access the Jenkins console log through the Docker logs of your container using the following command:

docker logs <docker-container-name>

Your <docker-container-name> can be obtained using the docker ps command.

##Accessing the Jenkins home directory:##
There is a possibility you may need to access the Jenkins home directory, for instance, to check the details of a Jenkins build in the workspace subdirectory.

If you mapped the Jenkins home directory (/var/jenkins_home) to one on your machine’s local file system (i.e. in the docker run …​ command above), then you can access the contents of this directory through your machine’s usual terminal/command prompt.

Otherwise, if you specified the --volume jenkins-data:/var/jenkins_home option in the docker run …​ command, you can access the contents of the Jenkins home directory through your container’s terminal/command prompt using the docker container exec command:

docker container exec -it <docker-container-name> bash

As mentioned above, your <docker-container-name> can be obtained using the docker container ls command. If you specified the
--name jenkins-blueocean option in the docker container run …​command above (see also Accessing the Jenkins/Blue Ocean Docker container), you can simply use the docker container exec command:

docker container exec -it jenkins-blueocean bash

Post-installation setup wizard
After downloading, installing and running Jenkins using one of the procedures above (except for installation with Jenkins Operator), the post-installation setup wizard begins.

This setup wizard takes you through a few quick "one-off" steps to unlock Jenkins, customize it with plugins and create the first administrator user through which you can continue accessing Jenkins.

Unlocking Jenkins
When you first access a new Jenkins instance, you are asked to unlock it using an automatically-generated password.

Browse to http://localhost:8080 (or whichever port you configured for Jenkins when installing it) and wait until the Unlock Jenkins page appears.

Unlock Jenkins page

From the Jenkins console log output, copy the automatically-generated alphanumeric password (between the 2 sets of asterisks).

Copying initial admin password
Note:

The command: sudo cat /var/lib/jenkins/secrets/initialAdminPassword will print the password at console.

If you are running Jenkins in Docker using the official jenkins/jenkins image you can use sudo docker exec ${CONTAINER_ID or CONTAINER_NAME} cat /var/jenkins_home/secrets/initialAdminPassword to print the password in the console without having to exec into the container.

On the Unlock Jenkins page, paste this password into the Administrator password field and click Continue.
Notes:

You can always access the Jenkins console log from the Docker logs (above).

The Jenkins console log indicates the location (in the Jenkins home directory) where this password can also be obtained. This password must be entered in the setup wizard on new Jenkins installations before you can access Jenkins’s main UI. This password also serves as the default administrator account’s password (with username "admin") if you happen to skip the subsequent user-creation step in the setup wizard.
  
  
  Source: https://www.jenkins.io/doc/book/installing/docker/#setup-wizard
  
