#!/bin/bash
sudo apt-get -y update
wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
tar zxvf openjdk-11+28_linux-x64_bin.tar.gz
sudo mv jdk-11* /usr/local/
export JAVA_HOME=/usr/local/jdk-11
export PATH=$PATH:$JAVA_HOME/bin

#Install Tomcat

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

tomcat_version=9.0.65
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




