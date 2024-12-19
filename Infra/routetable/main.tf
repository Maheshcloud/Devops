variable "vpcid" {
    default = ""
}

variable "igwid" {
    default = ""
}

resource "aws_route_table" "art" {
    vpc_id = var.vpcid
    tags = {
        Name = "internet route table"
    }
}

resource "aws_route_table" "art_nat" {
    vpc_id = var.vpcid
    tags = {
        Name = "nat_route_table"
    }
}

output "artid" {
    value = aws_route_table.art.id
}

output "artid_nat" {
    value = aws_route_table.art_nat.id
}
