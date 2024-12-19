provider "aws" {
    region = "us-east-1"
}

module "vpc" {
    source = "./modules/vpc"
}

module "internet_gateway" {
    source = "./modules/igw"
    vpcid = module.vpc.vpc_out
}

module "route_table" {
    source = "./modules/route_table"
    vpcid = module.vpc.vpc_out
    igwid = module.internet_gateway.igwid
}

module "subnet" {
    source = "./modules/subnet"
    vpcid = module.vpc.vpc_out
    artid = module.route_table.artid
    igwid = module.internet_gateway.igwid
    artid_nat = module.route_table.artid_nat
    natgw = module.nat_gateway.natgw
}

module "nat_gateway" {
    source = "./modules/natgw"
    subnetid = modules.subnet.sub_pub1
}

module "security_group" {
    source = "./modules/security_group"
    vpcid = module.vpc.vpc_out
}

module "rds" {
    source = "./modules/rds"
    subnet_private_1 = module.subnet.sub_private1
    subnet_private_2 = module.subnet.sub_private2
    vpc_sg_ids = module.security_group.internalsg
    subnet_public_1 = module.subnet.sub_pub1
    subnet_public_2 = module.subnet.sub_pub2
    external_sg = module.security_group.externalsg
    vpc_id = module.vpc.vpc_out
}

module "roles" {
    source = "./modules/roles"
}

module "eks_cluster" {
    source = "./modules/eks"
    subnet_private_1 = module.subnet.sub_private1
    subnet_private_2 = module.subnet.sub_private2
    eks_role_arn = module.roles.eks_role_arn
    nodegroup_arn = module.roles.eks_nodegroup_arn
}

module "ecr" {
    source = "./modules/ecr"
}

module "efs" {
    source = "./modules/efs"
    subnet_private_1 = module.subnet.sub_private1
    subnet_private_2 = module.subnet.sub_private2
    vpc_sg_ids = module.security_group.internalsg
}

module "secret_manager" {
    source = "./modules/secrets"
}

module "elasticsearch" {
    source = "./modules/elasticsearch"
    subnet_private_1 = module.subnet.sub_private1
    sg_internal_communication = module.security_group.internalsg
}

module "route53" {
    source = "./modules/route53"
    db_dnsname = module.rds.network_postgres_lb
    db_zoneid = module.rds.network_postgres_lb_zoneid
    vpc_id = module.vpc.vpc_out
}


output "efs_id" {
    value = "aws_efs_file_system.efs.id"
}

output "eksarn" {
    value = aws_eks_cluster.my-cluster.arn
}

output "elasticsearch_endpoint" {
    value = aws_elasticsearch_domain.kubernetes_logs.endpoint
}

output "igwid" {
    value = aws_internet_gateway.igw.id
}

output "natgw" {
    value = aws_nat_gateway.natgw.id
}

output "subnet_group_id" {
    value = aws_db_subnet_group.subnetforPostgres.id
}

output "rdsdatabase" {
    value = aws_db_instance.RDSPostgressqlMaster.endpoint
}

output "network_postgres_lb_zoneid" {
    value = aws_lb.postgres_networklb.zone_id
}

output "network_postgres_lb" {
    value = aws_lb.postgres_networklb.dns_name
}

output "postgres_db_ip" {
    value = join(",", data.dns_a_record_set.postgres_db_dns.addrs)
}

output "route53zoneid" {
    value = aws_route53_zone.privatedomain.zone_id
}

output "artid" {
    value = aws_route_table.art.id
}

output "artid_nat" {
    value = aws_route_table.art_nat.id
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


output "vpc_out" {
    value = aws_vpc.vpc.id
}














