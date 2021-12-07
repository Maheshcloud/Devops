    #!/bin/bash
    #Autor : Mahesh
    #Description: To install the softwares
    install_docker_latest()
    {
    #add the GPG key for the official Docker repository
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    #Add the Docker repository to APT sources
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    #update the package database with the Docker packages from the newly added repo
    sudo apt-get update 
    #install from the Docker repo
    apt-cache policy docker-ce
    #install Docker
    sudo apt-get install -y docker-ce 
    if [[ $? -eq 0 ]]
    then 
        echo "docker is installed"
    else 
        echo "unable to install docker"
    fi 

    usr=$(whoami)
    
    sudo usermod -aG docker $usr

    <<runjenkins 
    This command is to run jenkins in docker
    docker run \
    -u root \
    --rm \
    -d \
    -p 8080:8080 \
    -v /home/cloud_user/jenkins_home:/var/jenkins_home \
    --name jenkins \
    --env JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64 \
    --env M2_HOME=/opt/maven \
    jenkins
    jenkinsci/blueocean
runjenkins

    <<runprom
    This command is to run Prometheus in docker
    docker run -d --name prometheus -p 9090:9090 prom/prometheus
    docker run -d --name prometheus -p 9090:9090 --network prom  prom/prometheus
    docker update --restart unless-stopped container_id
    #in prometheus.yml under /etc/prometheus enter privateip for node_exporter to communicate
runprom

    <<runnodeexporter
    docker run -d --name node-exporter -p 9100:9100 prom/node-exporter
    docker run -d --name node-exporter -p 9100:9100 --network prom prom/node-exporter
    docker update --restart unless-stopped container_id
runnodeexporter

    <<rungrafana
    docker run -d --name grafana -p 3000:3000 grafana/grafana
rungrafana

    <<runtomcat
    docker run -d --name tomcat -p 8081:8080 tomcat
runtomcat





    }
    install_docker_17.03.2(){
    sudo apt install libltdl7 &> /dev/null
    wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_17.03.2~ce-0~ubuntu-xenial_amd64.deb &$
    sudo dpkg -i docker-ce_17.03.2~ce-0~ubuntu-xenial_amd64.deb &> /dev/null
    sudo usermod -aG docker $usr
    }

    install_tomcat(){
    if which java &> /dev/null
    then
        echo "Java is installed, its prerequisite"
    else
        echo "Installing Java as its prerequisite to install tomcat"
        install_java
    fi
    #we need SSH Agent plugin in Jenkins to deploy/copy war files to remote machines. 
    if [ -d /opt ]
    then
    echo "opt directory exists"
    cd /opt
    sudo chown $(id -u):$(id -g) /opt
    else
    echo "opt directory doesn't exists. Hence, creating an opt directory"
    sudo mkdir /opt
    cd /opt
    sudo chown $(id -u):$(id -g) /opt
    fi
    read -p "Enter the tomcat version you want to install: i.e 8.5.66, 9.0.46, 10.0.6:" tomcat_version
    tomcat_major_version=$(echo $tomcat_version | cut -c 1)
    if [[ ! -e tomcat${tomcat_major_version} ]]
    then
    #url=http://apachemirror.wuchna.com/tomcat/tomcat-${tomcat_major_version}/v${tomcat_version}/bin/apache-tomcat-${tomcat_version}.tar.gz
    url=http://mirrors.sonic.net/apache/tomcat/tomcat-${tomcat_major_version}/v${tomcat_version}/bin/apache-tomcat-${tomcat_version}.tar.gz
    #http://apachemirror.wuchna.com/tomcat/tomcat-9/v9.0.36/bin/apache-tomcat-9.0.36.tar.gz
    #https://mirrors.gigenet.com/apache/tomcat/tomcat-10/v10.0.4/bin/apache-tomcat-10.0.4.tar.gz
    wget $url
    tar -xvzf apache-tomcat-${tomcat_version}.tar.gz
    mv apache-tomcat-${tomcat_version} tomcat${tomcat_major_version}
    rm -rf apache-tomcat-${tomcat_version}.tar.gz
    echo "Need to comment the loopback address for manager and host-manager"
    cd /opt/tomcat${tomcat_major_version}/webapps/manager/META-INF/
    sed -i '19i <!--' context.xml
    sed -i '22i -->' context.xml
    cd /opt/tomcat${tomcat_major_version}/webapps/host-manager/META-INF
    sed -i '19i <!--' context.xml
    sed -i '22i -->' context.xml

    #create link files for tomcat startup.sh and shutdown.sh
    #give executing permissions to startup.sh and shutdown.sh which are under bin.
    
    echo "Changing the permission of the startup.sh and shutdown.sh files"
    chmod +x /opt/tomcat${tomcat_major_version}/bin/startup.sh 
    chmod +x /opt/tomcat${tomcat_major_version}/bin/shutdown.sh
    echo "Creating a link for startup and shutdown"
    sudo ln -s /opt/tomcat${tomcat_major_version}/bin/startup.sh /usr/local/bin/tomcatup
    sudo ln -s /opt/tomcat${tomcat_major_version}/bin/shutdown.sh /usr/local/bin/tomcatdown
    tomcatup
    echo "tomcat ${tomcat_version} is installed successfully "
    else
    echo "The tomcat version ${tomcat_version} already exists"

    fi

    #Once installation is done, we need to startup the tomcat server from tomcat/bin/
    #By default the tomcat server runs on 8080 port
    #But tomcat and Jenkins runs on ports number 8080. 
    #Hence lets change tomcat port number to 8090. Change port number in conf/server.xml file under tomcat home
    #cd /opt/tomcat${tomcat_major_version}/conf
    # update port number in the "connecter port" field in server.xml
    # restart tomcat after configuration update

    #Manager App:

    #You will not be able to access manager app
    #To access manager app we need to comment the loopback ip in context.xml
    #search for the file using  sudo find / -name context.xml
    #Sudo nano tomcat9/webapps/host-manager/META-INF/context.xml
    #<!--  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
    #       allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
    #Perform the same action in the other file as well  
    #sudo nano tomcat9/webapps/manager/META-INF/context.xml
    #As we have made changes, we need to restart tomcat i.e ./shutdown.sh and ./startup.sh


    #Update users information in the tomcat-users.xml file goto tomcat home directory and Add below users to conf/tomcat-user.xml file
    <<tomcat-users
        <role rolename="manager-gui"/>
        <role rolename="manager-script"/>
        <role rolename="manager-jmx"/>
        <role rolename="manager-status"/>
        <user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
        <user username="deployer" password="deployer" roles="manager-script"/>
        <user username="tomcat" password="secret" roles="manager-gui"/>
tomcat-users
    #Restart serivce and try to login to tomcat application from the browser. 


    #we need deploy to container plugin in jenkins to deploy to another VM
    #In post build actions, select Deploy war/ear to a container
    #Need to add the tomcat deployer credentials that we have added previously in tomcat-users


    }

    install_terraform()
    {
    sudo apt-get install unzip
    wget https://releases.hashicorp.com/terraform/0.15.4/terraform_0.15.4_linux_amd64.zip
    unzip terraform_0.15.4_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    
    }

    install_java()
    {
    #update the package index
    #sudo apt-get -y update
    #install Java. Specifically, this command will install the Java Runtime Environment (JRE)
    #sudo apt-get install -y default-jre
    #You can install the JDK with the following command
    #sudo apt-get install -y default-jdk
    #add Oracle’s PPA, then update your package repository
    #sudo add-apt-repository ppa:webupd8team/java
    #sudo apt-get -y update
    #sudo apt-get install -y oracle-java8-installer

    #sudo update-alternatives --config java   #To set the default java

    #Install Java 8:
    #sudo add-apt-repository ppa:webupd8team/java
    #sudo apt-get update
    #sudo apt install openjdk-8-jdk

    #Install Jenkins: 
    #Add Key on Host:
    #wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
    #Add following entry in your /etc/apt/sources.list:
    #echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
    #Update your local package index, then finally install Jenkins:
    #sudo apt-get update
    #sudo apt-get install jenkins


    sudo add-apt-repository ppa:openjdk-r/ppa

    sudo apt-get update

    sudo apt install openjdk-11-jdk
    #After installation set the JAVA_HOME by finding the location using below command
    pathofjava=$(find /usr/lib/jvm/java-* | head -n 1)
    export JAVA_HOME=$pathofjava
    export PATH=$JAVA_HOME/bin:$PATH
    #source /etc/environment  or 
    source ~/.bash_profile
    echo "JAVA_HOME and PATH are set"
    echo $JAVA_HOME



    }

    install_apache()
    {
    echo "installing apache2"
    sudo apt-get install apache2 -y
    if [[ $? -eq 0 ]]
    then 
        echo "apache2 is installed"
    else 
        echo "unable to install apache2"
    fi 
    sudo systemctl status apache2 || sudo systemctl start apache2
    
    
    
    #Default configuration directory for apache2 is /etc/apache2/sites-available/000-default.conf
    #/etc/apache2/sites-available/example.conf

    #<VirtualHost *:80>
    #   ServerAdmin admin@example.com
    #   ServerName example.com
    #   ServerAlias www.example.com
    #   DocumentRoot /var/www/example.com/html
    #   ErrorLog ${APACHE_LOG_DIR}/error.log
    #   CustomLog ${APACHE_LOG_DIR}/access.log combines
    #</VirtualHost>

    #enable using following command:
    #sudo a2ensite example.com.conf
    #restart the apache
    #sudo systemctl restart apache2

    #Now, disable the default configuration file:
    #sudo a2dissite 000-default.conf
    #restart apache2
    #sudo systemctl restart apache2


    #Installing SSL for domain using Lets Encrypt:
    #sudo add-apt-respository ppa:certbot/cerbot
    #sudo apt install python-certbot-apache

    #sudo certbot --apache -d example.com -d www.example.com 





    }

    install_ansible()
    {
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt update
    sudo apt install ansible

    #add user to sudoers file:
    #visudo or /etc/sudoers and add this line: user ALL:(ALL) NOPASSWD: ALL

    }

    install_kubernetes(){

            #Update the package list with the command
            sudo apt-get -y update
            if which docker &> /dev/null
            then
                echo "docker is already installed"
            else
                #Next, install Docker with the command
                sudo apt-get install -y docker.io
                if [[ $? -eq 0 ]]
                then 
                echo "Docker is installed"
                else 
                sleep 10
                sudo apt-get install -y docker.io
                fi 
                #Set Docker to launch at boot by entering the following command
                sudo systemctl enable docker
                #To start Docker with the following command
                sudo systemctl start docker
            fi
            
            #Enter the following to add a signing key
            curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
            if [[ $? -eq 0 ]]
            then 
                echo "Added signing key"
            else 
                echo "curl is not installed, trying to install curl and then will add signing key"
                sudo apt-get -y install curl
                curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
            fi 
            #Kubernetes is not included in the default repositories. To add them, enter the following:
            #No public key error:
            #sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys <key>
            sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
            #Install Kubernetes tools with the command
            sudo apt-get -y install kubeadm kubelet kubectl
            sudo apt-mark hold kubeadm kubelet kubectl
            #Start by disabling the swap memory on each server
            sudo swapoff –a
            read -p "please enter the hostname to be set eg: master-node or worker-node, etc:" hostname
            sudo hostnamectl set-hostname $hostname
            read -p "Please let us know if you are trying to setup 1.master-node 2.worker-node:" nodeselect
            case $nodeselect in
                1) 
                    #connectionrefused_overlay2_network
                    sudo kubeadm init --pod-network-cidr=10.244.0.0/16
                    mkdir -p $HOME/.kube
                    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
                    sudo chown $(id -u):$(id -g) $HOME/.kube/config
                    read -p "Please select the network type you want to setup 1.Calico network  2.Flannel network:" networktype
                    case $networktype in
                        1) 
                            kubectl create -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml
                            ;;
                        2) 
                            sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
                            ;;
                    esac
                    echo "Please make a note of the below join command. This will be used to join the worker nodes to the cluster."
                    kubeadm token create --print-join-command
                    ;;
                2)
                    #connectionrefused_overlay2_network
                    read -p "Please enter the join command you get from the worker node:" joincommand
                    sudo $joincommand
                    ;;
            esac

            #Create a tiller Serviceaccount in Kubernetes Master
            #kubectl -n kube-system create serviceaccount tiller
            #Bind the tiller serviceaccount to the cluster-admin role in Kubernetes Master:
            #kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller


    }

    install_jenkins(){

            if which java &> /dev/null
            then
            echo "Java is installed, its prerequisite"
            else
            echo "Installing Java as its prerequisite to install jenkins"
            install_java
            fi
            #You can get the jenkins password from /var/lib/jenkins/secrets/initialAdminPassword
            #add the repository key to the system

           # wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
            wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

            #append the Debian package repository address to the server’s sources.list
            sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
            #run update so that apt will use the new repository
            sudo apt -y update
            # install Jenkins and its dependencies
            sudo apt install -y jenkins
            if [[ $? -eq 0 ]]
            then
                echo "Jenkins is installed successfully"
            else
                sleep 10
                sudo apt install -y jenkins
            fi
            #start Jenkins using systemctl
            sudo systemctl start jenkins
            #Jenkins runs on port 8080, so let’s open that port using ufw
            sudo ufw allow 8080
            #Check ufw’s status to confirm the new rules
            status=$(sudo ufw status | awk -F [:] '{ print $2 }')
            if [ ${status} == inactive ]
            then
                #the following commands will allow OpenSSH and enable the firewall
                sudo ufw allow OpenSSH
                sudo ufw enable
            fi

            #We can find jenkins in /var/jenkins_home or /var/lib/jenkins
            #We can find jenkins initialpassword in /var/jenkins_home/secrets/initialpassword

            #To install Helm & Tiller in the Jenkins & Kubernetes Master respectively
            #Assign shell to jenkins user:

            #vi /etc/passwd
            #change shell from /bin/false to /bin/bash


            #provide permissions to jenkins user in jenkins server to access docker:

            #sudo groupadd docker
            #sudo usermod -aG docker jenkins
            #sudo chmod 777 /var/run/docker.sock


            #Add Jenkins user into sudoers file to get sudo access:

            #sudo nano /etc/sudoers
            #jenkins ALL=(ALL) NOPASSWD: ALL
            #For installation of helm, login as jenkins user, then perform below steps
            #To login as jenkins user, need to assign a password for it using the command sudo passwd jenkins
            #curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
            #sudo chmod 700 get_helm.sh
            #sudo ./get_helm.sh -v v2.14.1


            #Copy admin.conf file from Kubernetes master to Jenkins user's home directory in Jenkins server
            #Note: Install Tiller Serviceaccount in Kubernetes Master to copy i.e create and bind tiller serviceaccount
            #mkdir /var/lib/jenkins/.kube
            #Manually copy /etc/kubernetes/admin.conf file to /var/lib/jenkins/.kube/config file
            #chown -R jenkins:jenkins /home/jenkins/.kube
            
            #Run 'helm init' in Jenkins Server to configure helm:
    
            #helm init --service-account tiller
            
            #Verify if tiller is running in kubemaster
            #kubectl get pods --namespace kube-system



    }

    install_jenkins_18ubuntu(){

            if which java &> /dev/null
            then
            echo "Java is installed, its prerequisite"
            else
            echo "Installing Java as its prerequisite to install jenkins"
            install_java
            fi
            #You can get the jenkins password from /var/lib/jenkins/secrets/initialAdminPassword
            #add the repository key to the system

            #sudo su

            wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -


            #wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -

            #append the Debian package repository address to the server’s sources.list
            sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

            #run update so that apt will use the new repository
            sudo apt -y update
            # install Jenkins and its dependencies
            sudo apt install -y jenkins
            if [[ $? -eq 0 ]]
            then
                echo "Jenkins is installed successfully"
            else
                sleep 10
                sudo apt install -y jenkins
            fi
            #start Jenkins using systemctl
            sudo systemctl start jenkins
            #Jenkins runs on port 8080, so let’s open that port using ufw
            sudo ufw allow 8080
            #Check ufw’s status to confirm the new rules
            status=$(sudo ufw status | awk -F [:] '{ print $2 }')
            if [ ${status} == inactive ]
            then
                #the following commands will allow OpenSSH and enable the firewall
                sudo ufw allow OpenSSH
                sudo ufw enable
            fi
    }

    install_maven(){
    #Maven can be installed in two ways:
    #Apache Maven can be installed on Ubuntu from the Official website
    #Apache Maven can be installed using Apt
    #If we install using Apt, By default, it will be installed in /usr/share/maven and /etc/maven locations.
    dir="/opt/maven"
    if [[ -d "$dir" ]]
    then
        echo "Maven is installed"
        exit 1
    else
        cd /opt/
        #This example shows version 3.6.3. Substitute the download URL for the most recent version of Apache Maven from the official website. Choose the "Binary tar.gz archive".:
        sudo wget http://apache.mirrors.pair.com/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
        #Once the download has completed, extract the downloaded archive.
        sudo tar -xvzf apache-maven-3.6.3-bin.tar.gz
        #Next, rename the extracted directory.
        sudo mv apache-maven-3.6.3 maven 
        export M2_HOME='/opt/maven'
        export PATH=${M2_HOME}/bin:${PATH}
        #echo $M2_HOME
    fi

    
    source ~/.bashrc
    mvn -v
    echo $M2_HOME
    }

    install_git(){
    #Start by updating the package index
    sudo apt update
    #Run the following command to install Git:
    sudo apt install git

    }

    install_mysql(){
    #use command sudo mysql -u root -p to login so mysql as root user else simply use sudo mysql
    #update the package index on your server with apt
    sudo apt update
    #Then install the default package
    if which mysql &> /dev/null
    then
        echo "mysql is installed"
    else
        echo "Installing mysql"
        sudo apt install mysql-server
    fi
    
    read -p "Please let us know if you want your installation with password or without password: 1.password 2.without password:" passwordforsql
    case $passwordforsql in 
        1) 
        
    #you’ll want to run the included security script. This changes some of the less secure default options for things like remote root logins and sample users.
            sudo mysql_secure_installation
    #The first prompt will ask whether you’d like to set up the Validate Password Plugin, which can be used to test the strength of your MySQL password. 
    #Regardless of your choice, the next prompt will be to set a password for the MySQL root user.
    #From there, you can press Y and then ENTER to accept the defaults for all the subsequent questions. 
            ;;
        2) 
            echo "mysql is installed"
    esac      
    systemctl status mysql.service

    # Follow below steps to configure password authentication for root user
    #sudo mysql
    #SELECT user,authentication_string,plugin,host FROM mysql.user;
    #ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password By 'password'; enter actual password in password string
    #FLUSH PRIVILEGES;
    #SELECT user,authentication_string,plugin,host FROM mysql.user;

    sudo mysql -u root -p << sqlcommands
    SELECT user,authentication_string,plugin,host FROM mysql.user;
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password By 'test1234'; 
    FLUSH PRIVILEGES;
    SELECT user,authentication_string,plugin,host FROM mysql.user;
    CREATE USER 'mahesh'@'localhost' IDENTIFIED BY 'brownie2012';
    GRANT ALL PRIVILEGES ON *.* TO 'mahesh'@'localhost' WITH GRANT OPTION;
sqlcommands
    }

    install_sonarqube(){
    #create the sonarqube user
    sudo adduser --system --no-create-home --group --disabled-login sonarqube
    #this creates a system user that can’t log in to the server directly
    #create the directory to install SonarQube into
    sudo mkdir /opt/sonarqube
    #SonarQube releases are packaged in a zipped format, so install the unzip utility that will allow you to extract those files
    if which unzip &> /dev/null
    then
        echo "unzip is already installed"
    else
        sudo apt-get install unzip
    fi
    #you will create a database and credentials that SonarQube will use. Log in to the MySQL server as the root user 
    
    #sudo mysql -u root -p <<SQL_STATEMENTS
    #CREATE DATABASE sonarqube;
    #CREATE USER sonarqube@'localhost' IDENTIFIED BY 'some_secure_password';
    #GRANT ALL ON sonarqube.* to sonarqube@'localhost';
    #FLUSH PRIVILEGES;
    #EXIT;
    #SQL_STATEMENTS
    #Download and install sonarqube
    
        cd /opt/sonarqube
        #head over to the SonarQube downloads page and grab the download link for SonarQube
        sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.5.zip
        #Unzip the file
        sudo unzip sonarqube-7.5.zip
        #Once the files extract, delete the downloaded zip file, as you no longer need it
        #sudo rm sonarqube-7.5.zip
        #update the permissions so that the sonarqube user will own these files, and be able to read and write files in this directory
        sudo chown -R $(id -u):$(id -g) /opt/sonarqube
        cd /opt/sonarqube/sonarqube-7.5/bin/linux-x86-64
        #sudo su
        
        sudo ./sonar.sh start
        
        sudo ./sonar.sh status
        
        echo "sonarqube is installed and running. However, please note that you have to configure the sonarqube server"
        sudo ./sonar.sh status

    }

    install_aws_cli(){
    
    curl https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o awscli-bundle.zip
    apt install unzip python
    if which unzip &> /dev/null
    then
        unzip awscli-bundle.zip
    else
        sudo apt-get install unzip
        unzip awscli-bundle.zip
    fi
    sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
    echo "Installed AWS CLI successfully"


    }

    install_aws_cli_v1(){
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
    if [[ $? -eq 0 ]]
    then 
        echo "Kubectl is installed using curl........"
    else 
        echo "curl is not installed, trying to install curl and then will install kubectl"
        sudo apt-get -y install curl
        curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    fi 
    
    if which unzip &> /dev/null
    then
        unzip awscli-bundle.zip
    else
        sudo apt-get install unzip
        unzip awscli-bundle.zip
    fi
    sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
    aws --version

    }

    install_aws_cli_v1(){
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    if [[ $? -eq 0 ]]
    then 
        echo "Kubectl is installed using curl........"
    else 
        echo "curl is not installed, trying to install curl and then will install kubectl"
        sudo apt-get -y install curl
        curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    fi 
    if which unzip &> /dev/null
    then
        unzip awscliv2.zip
    else
        sudo apt-get install unzip
        unzip awscliv2.zip
    fi
    sudo ./aws/install
    ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
    aws --version

    }

    install_kubectl(){

    
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    if [[ $? -eq 0 ]]
    then 
        echo "Kubectl is installed using curl........"
    else 
        echo "curl is not installed, trying to install curl and then will install kubectl"
        sudo apt-get -y install curl
        curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    fi 
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
        
    }

    install_kops(){
    curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
    if [[ $? -eq 0 ]]
    then 
    echo "Kops is installed using curl........"
    else 
    echo "curl is not installed, trying to install curl and then will install Kops"
    sudo apt-get -y install curl
    curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
    fi 
    chmod +x kops-linux-amd64
    sudo mv kops-linux-amd64 /usr/local/bin/kops


    }

    install_php(){
    if which apache2 &> /dev/null
    then
        echo "apache2 is installed, its prerequisite"
    else
        echo "Installing apache2 as its prerequisite to install jenkins"
        install_apache
    fi
    if which php &> /dev/null
    then
        echo "php is installed"
    else
        sudo apt-get install php libapache2-mod-php php-mysql
    #Restart apache server to make the changes
        sudo systemctl restart apache2
    #In order to test that our system is configured properly for PHP, we can create a very basic PHP script.
    #We will call this script info.php. In order for Apache to find the file and serve it correctly, it must be saved to a very specific directory, which is called the “web root”.
    fi
    #sudo nano /var/www/html/info.php
    File=/var/www/html/info.php
    sudo chown $(id -u):$(id -g) /var/www/html
    if [[ -f $File ]]
    then
        echo "info.php already exists"
    else
    cat <<phpcomment > $File
        <?php
        phpinfo();
        ?>
phpcomment
    fi

    echo "PHP is installed"
    while true; do
        read -p "Do you wish to install SQL?" yn
        case $yn in
            [Yy]* ) install_mysql; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    }

    install_phpadmin(){

    sudo apt install phpmyadmin php-mbstring php-gettext
    sudo phpenmod mbstring



    #If the ip/phpmyadmin site doesn't open then perform following steps
    #You need to configure your apache2.conf to make phpMyAdmin works.

    #sudo nano /etc/apache2/apache2.conf
    #Then add the following line to the end of the file.
    #Include /etc/phpmyadmin/apache.conf
    sudo chown $(id -u):$(id -g) /etc/phpmyadmin
    sudo echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
    echo "restarting the apache2 server for the changes to get updated"
    sudo systemctl restart apache2

    }

    install_nodejs(){
           echo "Installing nodejs.........."
          curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
          sudo apt-get install -y nodejs
          echo "Installing npm............."
          sudo apt-get install -y npm
    }

    install_serverless(){

        if which node &> /dev/null
        then
          echo "node is installed, its prerequisite"
        else
          echo "Installing node as its prerequisite to install tomcat"
          install_nodejs
        fi
        npm install -g serverless
        read -p "Please enter key:" aws_key
        read -p "Please enter Secret:" aws_secret
        #Need to add serverless-admin IAM user from aws console and provide programatic access
        serverless config credentials --provider aws --key ${aws_key} --secret ${aws_secret} --profile serverless-admin
    }

    install_boto3(){
        pip3 install boto3
    }


    install_nginx(){
    sudo apt update
    sudo apt install nginx
    sudo ufw allow 'Nginx HTTP'
    sudo ufw status
    stats=$(sudo ufw status | awk -F [:] '{ print $2 }')
    if [ ${stats} == inactive ]
    then
    sudo ufw enable
    fi
    sudo systemctl start nginx
    }

    install_prometheus(){
    #Create these two users, and use the --no-create-home and --shell /bin/false options so that these users can’t log into the server.
    sudo useradd --no-create-home --shell /bin/false prometheus
    sudo useradd --no-create-home --shell /bin/false node_exporter
    #Following standard Linux conventions, we’ll create a directory in /etc for Prometheus’ configuration files and a directory in /var/lib for its data.
    echo "Creating /etc/prometheus and /var/lib/prometheus directories"
    sudo mkdir /etc/prometheus
    sudo mkdir /var/lib/prometheus
    #Now, set the user and group ownership on the new directories to the prometheus user.
    echo "Adding user and group ownership of the directories to prometheus user"
    sudo chown prometheus:prometheus /etc/prometheus
    sudo chown prometheus:prometheus /var/lib/prometheus
    #download and unpack the current stable version of Prometheus into your home directory.
    cd ~
    #curl -LO https://github.com/prometheus/prometheus/releases/download/v2.0.0/prometheus-2.0.0.linux-amd64.tar.gz
    echo "Downloading Prometheus"
    url=https://github.com/prometheus/prometheus/releases/download/v2.21.0-rc.0/prometheus-2.21.0-rc.0.linux-amd64.tar.gz
    wget $url
    #Next, use the sha256sum command to generate a checksum of the downloaded file
    sh=sha256sum prometheus-2.21.0-rc.0.linux-amd64.tar.gz | awk -F ' ' '{print $2}'
    #Compare the output from this command with the checksum on the Prometheus download page to ensure that your file is both genuine and not corrupted.
    if [[ $sh == prometheus-2.21.0-rc.0.linux-amd64.tar.gz ]]
    then
        echo "File is genuine and not corrupted"
    else
        echo "There is some issue with the Prometheus file that is downloaded"
    fi
    #Now, unpack the downloaded archive. 
    echo "Unpacking the downloaded archive"
    tar xvf prometheus-2.21.0-rc.0.linux-amd64.tar.gz
    #This will create a directory called prometheus-2.0.0.linux-amd64 containing two binary files (prometheus and promtool), consoles and console_libraries directories containing the web interface files, a license, a notice, and several example files.
    #Copy the two binaries to the /usr/local/bin directory.
    sudo cp prometheus-2.21.0-rc.0.linux-amd64/prometheus /usr/local/bin/
    sudo cp prometheus-2.21.0-rc.0.linux-amd64/promtool /usr/local/bin/
    #Set the user and group ownership on the binaries to the prometheus user created 
    sudo chown prometheus:prometheus /usr/local/bin/prometheus
    sudo chown prometheus:prometheus /usr/local/bin/promtool
    #Copy the consoles and console_libraries directories to /etc/prometheus.
    sudo cp -r prometheus-2.21.0-rc.0.linux-amd64/consoles /etc/prometheus
    sudo cp -r prometheus-2.21.0-rc.0.linux-amd64/console_libraries /etc/prometheus
    #Set the user and group ownership on the directories to the prometheus user. Using the -R flag will ensure that ownership is set on the files inside the directory as well.
    sudo chown -R prometheus:prometheus /etc/prometheus/consoles
    sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
    #Lastly, remove the leftover files from your home directory as they are no longer needed.
    
    rm -rf prometheus-2.21.0-rc.0.linux-amd64.tar.gz prometheus-2.21.0-rc.0.linux-amd64
    #In the global settings, define the default interval for scraping metrics. sudo nano /etc/prometheus/prometheus.yml
    <<promcomment
    sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
    Start up Prometheus as the prometheus user, providing the path to both the configuration file and the data directory.
    sudo -u prometheus /usr/local/bin/prometheus \
        --config.file /etc/prometheus/prometheus.yml \
        --storage.tsdb.path /var/lib/prometheus/ \
        --web.console.templates=/etc/prometheus/consoles \
        --web.console.libraries=/etc/prometheus/console_libraries
        The output contains information about Prometheus’ loading progress, configuration file, and related services. It also confirms that Prometheus is listening on port 9090.
        Now, halt Prometheus by pressing CTRL+C, and then open a new systemd service file.
        sudo nano /etc/systemd/system/prometheus.service
        The service file tells systemd to run Prometheus as the prometheus user, with the configuration file located in the /etc/prometheus/prometheus.yml directory and to store its data in the /var/lib/prometheus directory
        Copy the following content into the file:

    Prometheus service file - /etc/systemd/system/prometheus.service
    [Unit]
    Description=Prometheus
    Wants=network-online.target
    After=network-online.target

    [Service]
    User=prometheus
    Group=prometheus
    Type=simple
    ExecStart=/usr/local/bin/prometheus \
        --config.file /etc/prometheus/prometheus.yml \
        --storage.tsdb.path /var/lib/prometheus/ \
        --web.console.templates=/etc/prometheus/consoles \
        --web.console.libraries=/etc/prometheus/console_libraries

    [Install]
    WantedBy=multi-user.target
    Finally, save the file and close your text editor.

    To use the newly created service, reload systemd.

    sudo systemctl daemon-reload
    You can now start Prometheus using the following command:

    sudo systemctl start prometheus
    To make sure Prometheus is running, check the service’s status.

    sudo systemctl status prometheus

    Lastly, enable the service to start on boot.

    sudo systemctl enable prometheus

promcomment

    }

    install_grafana(){
        #Download the Grafana GPG key with wget, then pipe the output to apt-key. This will add the key to your APT installation’s list of trusted keys, which will allow you to download and verify the GPG-signed Grafana package.
        wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
        #In this command, the option -q turns off the status update message for wget, and -O outputs the file that you downloaded to the terminal. These two options ensure that only the contents of the downloaded file are pipelined to apt-key.
        #Next, add the Grafana repository to your APT sources:
        sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
        #Refresh your APT cache to update your package lists:
        sudo apt update
        #Next, make sure Grafana will be installed from the Grafana repository:
        apt-cache policy grafana
        #You can now proceed with the installation:
        sudo apt install grafana
        #Once Grafana is installed, use systemctl to start the Grafana server:
        sudo systemctl start grafana-server
        #Next, verify that Grafana is running by checking the service’s status:
        #sudo systemctl status grafana-server  
        #If we check the status then it needs manual interuption to end the status command
        #Lastly, enable the service to automatically start Grafana on boot:
        sudo systemctl enable grafana-server
        #Enter admin into both the User and Password fields and then click on the Log in button.

    }

install_node_exporterforprometheus(){
    #cd ~
    wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
    #Now, unpack the downloaded archive.
    echo "Unpacking the tar file"
    tar xvf node_exporter-1.0.1.linux-amd64.tar.gz

    #Copy the binary to the /usr/local/bin directory and set the user and group ownership to the node_exporter
    sudo cp node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin
    sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

    #Lastly, remove the leftover files from your home directory as they are no longer needed.
    rm -rf node_exporter-1.0.1.linux-amd64.tar.gz node_exporter-1.0.1.linux-amd64

    #Start by creating the Systemd service file for Node Exporter.
   # sudo nano /etc/systemd/system/node_exporter.service
    #This service file tells your system to run Node Exporter as the node_exporter user with the default set of collectors enabled.
    #Copy the following content into the service file:
    File=/etc/systemd/system/node_exporter.service
    cat <<nodeexporter > $File
        [Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target

nodeexporter

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl status node_exporter

   
    <<expsysd
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target




Finally, reload systemd to use the newly created service.

sudo systemctl daemon-reload
You can now run Node Exporter using the following command:

sudo systemctl start node_exporter
Verify that Node Exporter’s running correctly with the status command.

sudo systemctl status node_exporter

Lastly, enable Node Exporter to start on boot.

sudo systemctl enable node_exporter
     
expsysd

sudo systemctl enable node_exporter


}

install_aws_kubectl(){
    echo "You are installing Kubernetes 1.17 kubectl........"
    #Please the link for latest updates  https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
    #Download the Amazon EKS vended kubectl binary for your cluster's Kubernetes version from Amazon S3. To download the Arm version, change amd64 to arm64 before running the command.

    curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/kubectl
    if [[ $? -eq 0 ]]
    then 
    echo "kubectl is installed using curl........"
    else 
    echo "curl is not installed, trying to install curl and then will install kubectl"
    sudo apt-get -y install curl
    curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/kubectl
    fi
    #Apply execute permissions to the binary.
    chmod +x ./kubectl
    #Copy the binary to a folder in your PATH. If you have already installed a version of kubectl , then we recommend creating a $HOME/bin/kubectl and ensuring that $HOME/bin comes first in your $PATH.
    mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
    #Add the $HOME/bin path to your shell initialization file so that it is configured when you open a shell.
    echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
    #After you install kubectl , you can verify its version with the following command:
    kubectl version --short --client

}

install_kcli_1.19(){
    curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
    if [[ $? -eq 0 ]]
    then 
    echo "kubectl is installed using curl........"
    else 
    echo "curl is not installed, trying to install curl and then will install kubectl"
    sudo apt-get -y install curl
    curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/kubectl
    fi
    #Apply execute permissions to the binary.
    chmod +x ./kubectl
    #Copy the binary to a folder in your PATH. If you have already installed a version of kubectl , then we recommend creating a $HOME/bin/kubectl and ensuring that $HOME/bin comes first in your $PATH.
    mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
    #Add the $HOME/bin path to your shell initialization file so that it is configured when you open a shell.
    echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
    #After you install kubectl , you can verify its version with the following command:
    kubectl version --short --client
}

install_kcli_1.20(){
    curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.20.4/2021-04-12/bin/linux/amd64/kubectl
    if [[ $? -eq 0 ]]
    then 
    echo "kubectl is installed using curl........"
    else 
    echo "curl is not installed, trying to install curl and then will install kubectl"
    sudo apt-get -y install curl
    curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/kubectl
    fi
    #Apply execute permissions to the binary.
    chmod +x ./kubectl
    #Copy the binary to a folder in your PATH. If you have already installed a version of kubectl , then we recommend creating a $HOME/bin/kubectl and ensuring that $HOME/bin comes first in your $PATH.
    mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
    #Add the $HOME/bin path to your shell initialization file so that it is configured when you open a shell.
    echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
    #After you install kubectl , you can verify its version with the following command:
    kubectl version --short --client
}

install_aws_eksctl(){
    #Download and extract the latest release of eksctl with the following command.
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    if [[ $? -eq 0 ]]
    then 
    echo "eksctl is installed using curl........"
    else 
    echo "curl is not installed, trying to install curl and then will install eksctl"
    sudo apt-get -y install curl
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    fi
    #Move the extracted binary to /usr/local/bin.
    sudo mv /tmp/eksctl /usr/local/bin
    #Test that your installation was successful with the following command.
    eksctl version
    
}



    dpkglock_operation(){
    echo "Verifying in /var/lib/dpkg/lock...."
    
    if read -n1 -d '' < <(sudo lsof /var/lib/dpkg/lock); then
        sudo lsof /var/lib/dpkg/lock
        read -p "Please enter the PID to kill:" pidkill
        sudo kill -9 $pidkill 
    else
        echo "This command doesn't have any output"
    fi
    echo "Verifying in /var/lib/apt/lists/lock...."
    if read -n1 -d '' < <(sudo lsof /var/lib/apt/lists/lock); then
        sudo lsof /var/lib/apt/lists/lock
        read -p "Please enter the PID to kill:" pidkill1
        sudo kill -9 $pidkill1 
    else
        echo "This command doesn't have any output"
    fi
    echo "Verifying in /var/cache/apt/archives/lock....."
    if read -n1 -d '' < <(sudo lsof /var/cache/apt/archives/lock); then
        sudo lsof /var/cache/apt/archives/lock
        read -p "Please enter the PID to kill:" pidkill2
        sudo kill -9 $pidkill2
    else
    echo "This command doesn't have any output"
    fi
    echo "removing all the lock files...."
    sudo rm /var/lib/apt/lists/lock
    sudo rm /var/cache/apt/archives/lock
    sudo rm /var/lib/dpkg/lock
    echo "All the lock files are removed......."

    echo "reconfigure the packages....."
    sudo dpkg --configure -a

    sudo apt update
    }

    connectionrefused_overlay2_network(){
       

        cat <<EOF | sudo tee /etc/docker/daemon.json
        {
         "exec-opts": ["native.cgroupdriver=systemd"],
         "log-driver": "json-file",
         "log-opts": {
         "max-size": "100m"
        },
         "storage-driver": "overlay2"
        }
EOF
        sudo systemctl enable docker
        sudo systemctl daemon-reload
        sudo systemctl restart docker
        sudo kubeadm reset

    }

    dpkgdependency_problem(){
        sudo rm -rf /var/lib/dpkg/updates/*
        sudo apt-get clean
        sudo apt-get update
        sudo dpkg --configure -a
        sudo apt-get -f install -y
        sudo apt install libavahi-glib1 --reinstall
    }


    install_operation()
    {


    #read -p "Please select the software to install: 1.tomcat 2.docker 3.terraform 4.java 5.apache 6.ansible 7.kubernetes(Kubeadm) 8.jenkins 9.maven 10.git 11.mysql 12.sonarqube 13.AWS Cli 14.kubectl 15.Kops 16.Php 17.php-admin 18.nginx:" software
    #WebServers: Tomcat, Nginx, Apache
    #Containerization: Docker, Kubernetes(Kubeadm), Kubectl, Kops
    #Infrastructe As Code: Terraform
    #Configuration Management: Ansible
    #CI/CD: Jenkins
    #Database: mysql
    #Software Management: Java, Maven, Git, PHP, Php-admin
    #Cli: AWS Cli
    #Code Quality: Sonarqube
    echo "Please select what you want to install: 1. Webservers \\n 2. Containerization Technologies \\n 3. Infrastructure As Code \\n 4. Configuration Management \\n5. CI/CD \\n6. Database \\n7. Software Programs(java, Maven, Git, PHP etc) \\n8. CLI \\n9. Code Quality \\n10. Monitoring:" 
    read -r program
    case $program in 
        1) 
            echo "You selected Webservers"
            read -p "Please select the WebServer you want to install: 1. Tomcat \n2. Nginx \n3. Apache2:" webserver
            case $webserver in
                1) echo "You selected tomcat to install"
                    if which tomcat &> /dev/null
                    then
                        echo "tomcat is already installed"
                    else
                        install_tomcat
                    fi
                    ;;
                2) echo "You selected Nginx to install"
                    if which nginx &> /dev/null
                    then
                        echo "nginx is already installed"
                    else
                        install_nginx
                    fi
                    ;;
                3) echo "You selected Apache2 to install"
                    if which apache2 &> /dev/null
                    then
                        echo "Apache2 is already installed"
                    else
                        install_apache
                    fi
                    ;;
            esac      
            ;;
        2)
            echo "You selected Containerization technology to install"
            read -p "Please select Container Technology to install: 1. Docker \\n2. Kubernetes(Kubeadm) \\n3. Kubectl \\n4. Kops:" container
            case $container in
                1) echo "You selected Docker to install"
                    if which docker &> /dev/null
                    then
                        echo "Docker is already installed"
                    else
                        install_docker_latest
                    fi
                    ;;
                2) echo "You selected Kubernetes(Kubeadm) to install"
                    if which kubeadm &> /dev/null
                    then
                        echo "KubeAdm is already installed"
                    else
                        install_kubernetes
                    fi
                    ;;
                3) echo "You selected Kubectl to install"
                    if which kubectl &> /dev/null
                    then
                        echo "Kubectl is already installed"
                    else
                        install_kubectl
                    fi
                    ;;
                4) echo "You selected Kops to install"
                    install_kops
                    ;;   
            esac 
            ;;        
        3) 
            echo "You selected Infrastructure As Code to install" 
            read -p "Please select the Infrastructure As Code to install: 1. Terraform:" iaas
            case $iaas in 
                1) echo "You selected Terraform to install"
                    if which terraform &> /dev/null
                    then 
                        echo "terraform is already installed"
                        exit
                    else
                        install_terraform
                    fi
                    ;;
            esac   
            ;;      
        4) 
            echo "You selected Configuratuon Management to install"
            read -p "Please select the Configuration Management to install: 1. Ansible:" CM
            case $CM in
                1) echo "You selected Ansible to install"
                    if which ansible &> /dev/null
                    then
                        echo "ansible is already installed"
                    else
                        install_ansible
                    fi
                    ;;
            esac    
            ;;     
        5) 
            echo "You selected CI/CD to install"
            read -p "Please select the CI/CD tool to install: 1. Jenkins: 2. Jenkins for Ubuntu 18:" CICD
            case $CICD in
                1) echo "You selected Jenkins to install"  
                    if which jenkins &> /dev/null
                    then 
                        echo "Jenkins is already installed"
                    else 
                        install_jenkins
                    fi
                    ;;
                2) echo "You selected Jenkins for Ubuntu18 to install"
                     if which jenkins &> /dev/null
                     then
                        echo "Jenkins is already installed"
                     else
                        install_jenkins_18ubuntu
                     fi
                     ;;
            esac  
            ;;      
        6) 
            echo "You selected Database to install"
            read -p "Please select the Database to install: 1. mysql:" database
            case $database in
                1) echo "You selected mysql to install" 
                    if which mysql &> /dev/null
                    then
                        echo "mysql is already installed"
                    else
                        install_mysql
                    fi
                    ;;
            esac  
            ;;      
        7) 
            echo "You selected Software Program to install"
            read -p "Please select the Software Program to install: 1. Java \\n2. Maven \\n3. Git \\n4. PHP \\n5. Php-admin \\n6. Node.js 16x \\n7. Serverless:" sp
            case $sp in
                1) echo "You selected Jave to install"
                    if which java &> /dev/null
                    then  
                        echo "java is already installed"
                        exit
                    else
                        install_java
                    fi
                    ;;
                2) echo "You selected Maven to install"
                    if which maven &> /dev/null
                    then
                        echo "Maven is already installed"
                    else
                        install_maven
                    fi
                    ;;   
                3) echo "You selected Git to install"
                    if which git &> /dev/null
                    then
                        echo "Git is already installed"
                    else
                        install_git
                    fi
                    ;; 
                4) echo "You selected PHP to install"
                    install_php
                    ;; 
                5) echo "You selected Php-admin to install"
                    install_phpadmin
                    ;;  
                6) echo "You selected Node.js v16.x to install"
                    install_nodejs
                    ;;
                7) echo "You selected Serverless to install"
                    install_serverless
                    ;;
                8) echo "You selected Boto3 to install"
                    install_boto3
                    ;;
            esac   
            ;;      
        8) 
            echo "You selected CLI to install"
            read -p "Please select the Cli to install: 1. AWS Cli \\n2. AWS Kubectl cli \\n3. AWS eksctl cli:" cli
            case $cli in 
                1) echo "You selected AWS Cli to install"
                   read -p "Please select the AWS Cli Version to install: 1. AWS CLI V1 2. AWS CLI V2:" acli
                    install_aws_cli_v1
                    ;;
                2) echo "You selected AWS Kubectl to install"
                   read -p "Please select the Cli to install: 1. Kubernetes 1.19 2. Kubernetes 1.20:" kcli
                     case $kcli in 
                         1) echo "You selected Kubernetes Cli 1.19 to install"
                              install_kcli_1.19
                              ;;
                         2) echo "You selected Kubernetes Cli 1.20 to install"
                              install_kcli_1.20
                              ;;
                      esac
                    ;;
                3) echo "You selected AWS eksctl to install"
                    install_aws_eksctl
                    ;;
            esac   
            ;;      
        9) 
            echo "You selected Code Quality to install"
            read -p "Please select Code Quality to install: 1. Sonarqube:" cq
            case $cq in
                1) echo "You selected Sonarqube to install"
                    if which sonarqube &> /dev/null
                    then
                        echo "sonarqube is already installed"
                    else
                        install_sonarqube
                    fi
                    ;;
            esac  
            ;;      
        10)
            echo "You selected Monitoring Tool to install"
            read -p "Please select the Monitoring Tool to install: 1. Prometheus \\n2. Grafana \\n3. Node Exporter for Prometheus:" monitor
            case $monitor in
                1) echo "You selected Prometheus to install"
                    if which prometheus &> /dev/null
                    then
                        echo "prometheus is already installed"
                    else
                        install_prometheus
                    fi
                    ;;
                2) echo "You selected Grafana to install"  
                    if which grafana &> /dev/null
                    then
                        echo "grafana is already installed"
                    else
                        install_grafana
                    fi
                    ;;
                3) echo "You selected Node Exporter for prometheus to install"
                   install_node_exporterforprometheus
                   ;;
                    
            esac  
            ;;      
    esac 
    }               




    uninstall_operation()
    {
        #read -p "Please select the software to uninstall: 1.tomcat 2.docker 3.mysql 4.terraform:" uninstall
        read -p "Please select the software to uninstall: 1. Webservers \\n 2. Containerization Technologies \\n 3. Infrastructure As Code \\n 4. Configuration Management \\n5. CI/CD \\n6. Database \\n7. Software Programs(java, Maven, Git, PHP etc) \\n8. CLI \\n9. Code Quality \\n10. Monitoring:" uninstall

    case $uninstall in
        1)
            echo "You selected Webservers to uninstall"
            read -p "Please select the WebServer you want to uninstall: 1. Tomcat \n2. Nginx \n3. Apache2:" webserver
            case $webserver in
                1) 
                   echo "You selected tomcat to be removed......please wait a moment for the comfirmation message"
                   pat=$(ls | grep tomcat)
                   rm -rf $pat &> /dev/null
                   echo "tomcat is removed from the system"
                   ;;
                
                2) echo "You selected Nginx to uninstall"
                   
                   if which nginx &> /dev/null
                   then
                    echo "nginx is not installed"
                   else
                    echo "uninstalling nginx"
                    sudo apt-get purge nginx
                   fi
                   ;;
                3) echo "You selected Apache2 to uninstall"
                   if which nginx &> /dev/null
                   then
                    echo "nginx is not installed"
                   else
                    echo "Please select if you want to purge or remove the Apache2 Note: remove will uninstall Apache from the system, but leave the configuration files behind. Where as Purge will uninstall Apache from the system, along with the configuration files inside /etc/apache2"
                    read -p "Please select the option you want 1. remove 2. purge:" remorpurge
                    case $remorpurge in
                      1) 
                        echo "You selected to remove apache2"
                        sudo apt remove apache2
                        ;;
                      2) 
                        echo "You selected to purge apache2"
                        sudo apt purge apache2
                        ;;
                    esac
                   fi
            esac
            ;;
        2)  echo "You selected Containerization Technology to uninstall"
            read -p "Please select the Containerization Technology you want to uninstall: 1. Docker \n:" cont
            case $cont in
                1) 
                   echo "You selected docker to uninstall.........please wait a moment for the confirmation message"
                   unin=$(dpkg -l | grep -i docker | awk 'NR==1 {print $2}' | awk -F '[-]' '{print$2}')
                   sudo apt-get purge -y docker.${unin} &> /dev/null
                   sudo apt-get autoremove -y --purge docker.${unin} &> /dev/null
                   sudo apt-get autoclean &> /dev/null
                   echo "docker is uninstalled"
                   ;;
            esac
            ;;
        3)
            echo "You selected mysql to uninstall.........please wait a moment for the confirmation message"
            sudo apt-get remove --purge mysql-server mysql-client mysql-common -y
            sudo apt-get autoremove -y
            sudo apt-get autoclean
            #Remove the MySQL folder
            rm -rf /etc/mysql
            #Delete all MySQL files on your server
            sudo find / -iname 'mysql*' -exec rm -rf {} \;
            echo "mysql is uninstalled"
            ;;
        4)
            echo "You selected terraform to unintall........please wait a moment for the confirmation message"
            rm -rf /usr/local/bin/terraform 
            echo "terraform is uninstalled"
            ;;
    esac

    }

    troubleshoot_operation(){

    read -p "Please select the issue you want to troubleshoot: 1.dpkglock 2. check logs 3. connection refused(kubeadm) 4. dpkgdependency problem:" operationtrouble
    case $operationtrouble in
        1)
            echo "You selected dpkglock to troubleshoot"
            dpkglock_operation
            ;;
        2)
            echo "You selected logs to display for troubleshoot"
            sudo cat /var/log/syslog
            ;;

            #The following signatures couldn't be verified because the public key is not available: NO_PUBKEY DA418C88A3219F7B
            #sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DA418C88A3219F7B
            #Replace the key

        3)
           echo "You selected connection refused issue to be fixed while installing Kubeadm"
           connectionrefused_overlay2_network
           ;;

        4) 
           echo "You selected dpkg dependency problem to fix"
           dpkgdependency_problem
    esac
    }
    #echo -p "Enter the Software you want to install" software
    read -p "Please select the operation you want to perform: 1. install 2.uninstall 3.troubleshoot:" operation

    case $operation in
        1)
            echo "You selected install"
            install_operation
            ;;
        2)
            echo "You selected uninstall"
            uninstall_operation
            ;;
        3)
            echo "You selected troubleshoot"
            troubleshoot_operation
            ;;
    esac



