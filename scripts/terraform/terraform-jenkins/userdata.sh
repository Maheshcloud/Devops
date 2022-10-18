#!/bin/bash
sudo apt-get -y update
wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
tar zxvf openjdk-11+28_linux-x64_bin.tar.gz
sudo mv jdk-11* /usr/local/
export JAVA_HOME=/usr/local/jdk-11
export PATH=$PATH:$JAVA_HOME/bin
# Install Jenkins
sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo echo "deb https://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list
sudo apt-get -y update
sudo apt-get -y install jenkins


# Install terraform
sudo apt-get install wget unzip -y
sudo wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip
sudo unzip terraform_0.14.7_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Install aws cli

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#Install Git

sudo apt update
#Run the following command to install Git:
sudo apt install git


#Install maven


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
