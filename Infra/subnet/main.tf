variable "vpcid" {
    default = ""
}

variable "artid" {
    default = ""
}

variable "igwid" {
    default = ""
}

variable "artid_nat" {
    default = ""
}

variable "natgw" {
    default = ""
}

resource "aws_subnet" "subnet1" {
    vpc_id = var.vpcid
    cidr_block = "172.1.0.0/16"
    availability_zone = "us-east-1"
    tags = {
        Name = "public access subnet1"
    }
}

resource "aws_subnet" "subnet2" {
    vpc_id = var.vpcid
    cidr_block = "172.2.0.0/16"
    availability_zone = "us-east-1"
    tags = {
        Name = "public access subnet2"
    }
}

resource "aws_route_table_association" "public_subnet1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = var.artid
}

resource "aws_route_table_association" "public_subnet2" {
    subnet_id = aws_subnet.subnet2.id
    route_table_id = var.artid
}

resource "aws_route" "route" {
    route_table_id = var.artid
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = var.igwid
}



resource "aws_subnet" "private_subnet1" {
    vpc_id = var.vpcid
    cidr_block = "172.10.0.0/16"
    availability_zone = "us-east-1"
    tags = {
        Name = "private access subnet1"
    }
}

resource "aws_subnet" "private_subnet2" {
    vpc_id = var.vpcid
    cidr_block = "172.20.0.0/16"
    availability_zone = "us-east-1"
    tags = {
        Name = "private access subnet2"
    }
}

resource "aws_route_table_association" "privatesubnet1" {
    subnet_id = aws_subnet.private_subnet1.id
    route_table_id = var.artid
}

resource "aws_route_table_association" "privatesubnet2" {
    subnet_id = aws_subnet.private_subnet2.id
    route_table_id = var.artid
}

resource "aws_route" "route" {
    route_table_id = var.artid
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = var.igwid
}

output "sub_pub1" {
    value = aws_subnet.subnet1.id
}

output "sub_pub2" {
    value = aws_subnet.subnet2.id
}


output "sub_private1" {
    value = aws_subnet.privatesubnet1.id
}


output "sub_private2" {
    value = aws_subnet.privatesubnet2.id
}





