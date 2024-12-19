resource "aws_vpc" "vpc" {
    enable_dns_support = true
    enable_dns_hostname = true
    tags = {
        Name = "VPC"
    }
}

output "vpc_out" {
    value = aws_vpc.vpc.id
}