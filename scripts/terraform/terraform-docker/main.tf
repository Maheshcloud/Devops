provider "aws" {
  region  = var.region
}
resource "aws_security_group" "DockerSG" {
  name = "Docker SG"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "DockerEC2" {
  instance_type          = var.instance_type
  ami                    = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.DockerSG.id]
  key_name               = var.ssh_key_name

  tags = {
    Name = "terraform-Docker"
  }
  user_data = file("userdata.sh")

  provisioner "file" {
    source      = "Dockerfile"
    destination = "/home/ubuntu/Dockerfile"
    connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("tomcat.pem")
    host     = self.public_ip
   }
  }

  provisioner "file" {
    source      = "plugins.txt"
    destination = "/home/ubuntu/plugins.txt"
    connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("tomcat.pem")
    host     = self.public_ip
   }
  }

  provisioner "remote-exec" {
    connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("tomcat.pem")
    host     = self.public_ip
  }
    inline = [
      "chmod +x Dockerfile",
      "chmod +x plugins.txt",
      "docker build -t maheshcloud84/jenkinsserver .",
      "sudo docker run -p 8080:8080 maheshcloud84/jenkinsserver"
      # \\wsl$\docker-desktop
      # docker run -d -v C:\Users\mahes\Desktop\Mahesh\Jenkins:/var/jenkins_home -p 8080:8080 -p 50000:50000 --restart=on-failure maheshcloud84/jenkinsserver:v3
    /*
    docker run  -u  --privileged --name jenkins -it -d -p 8080:8080 -p 50000:50000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(which docker):/usr/bin/docker \
    -v C:\Users\mahes\Desktop\Mahesh\Jenkins:/var/jenkins_home \ 
    jenkins/jenkins:latest
    */


    ]

  }

}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]

}

