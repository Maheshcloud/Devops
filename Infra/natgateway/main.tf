variable "subnetid" {
    default = ""
}

resource "aws_eip" "eip_addr" {
    vpc = true
}

resource "aws_nat_gateway" "natgw" {
    subnet_id = var.subnetid
    allocation_id = aws_eip.eip_addr.id

    tage = {
        Name = "Nat Gateway"
    }

}

output "natgw" {
    value = aws_nat_gateway.natgw.id
}