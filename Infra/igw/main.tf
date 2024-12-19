resource "aws_internet_gateway" "igw" {
    vpc_id = var.vpcid

  tags = {
    Name = "main"
  }
}

output "igwid" {
    value = aws_internet_gateway.igw.id
}