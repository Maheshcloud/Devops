variable "vpcid" {
    default = ""
}

resource "aws_security_group" "internalsg" {
    name = "allow internation communication within VPC"
    description = "allow traffic within VPC"
    vpc_id = var.vpcid
    ingress{
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 9090
      to_port = 9090
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 3000
      to_port = 3000
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 5000
      to_port = 5000
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 30000
      to_port = 32000
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
      
}

resource "aws_security_group" "externalsg" {
    name = "allow internation communication within VPC"
    description = "allow traffic within VPC"
    vpc_id = var.vpcid
    ingress{
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 9090
      to_port = 9090
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 3000
      to_port = 3000
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 5000
      to_port = 5000
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 30000
      to_port = 32000
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
      
}
