resource "aws_db_subnet_group" "subnetforPostgres" {
  name       = "subnetforPostgre"
  subnet_ids = [var.subnet_private_1, var.subnet_private_2]
  description = "Private subnets for database"

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "RDSPostgressqlMaster" {
  allocated_storage    = var.allocated-allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.name_master
  username             = var.username
  password             = var.password
  identifier           = var.name_master
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.vpc_sg_ids, var.external_sg]
  availability_zone    = var.availability_zone
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  storage_encrypted    = var.storage_encrypted
  db_subnet_group_name = aws_db_subnet_group.subnetforPostgres.id
  backup_retention_period = var.backup_retention_period
  backup_window        = var.backup_window
  copy_tags_to_snapshot = var.copy_tags_to_snapshot
  delete_automated_backups = var.delete_automated_backups
  deletion_protection  = var.deletion_protection
  port                 = var.database-port
  tags = {
    Name = "RDS Postgress SQL"
  }
}

// IP address of postgressql DB
data "dns_a_record_set" "postgres_db_dns" {
    host = aws_db_instance.RDSPostgressqlMaster.address
}

//Load balancer tp access the database
resource "aws_lb" "postgres_networklb" {
    name       = "postgresnetworklb"
    internal   = false
    load_balancer_type = "network"
    subnets    = [var.subnet_public_1, var.subnet_public_2]
    enable_deletion_protection = false
    tags = {
        Name = "NetworkLB-Postgressql"
    }
}

resource "aws_lb_target_group" "nlb_target_group" {
    name        = "nlb-targetgrp-postgres"
    port        = 5432
    protocol    = "TCP"
    target_type = "ip"
    vpc_id      = var.vpc_id
    tags = {
        Name = "nlb-targetgrp-postgres"
    }
}

resource "aws_lb_target_group_attachment" "nlb-targetgrp-rule-postgres" {
    target_group_arn = aws_lb_target.nlb-targetgrp-postgres.arn
    target_id        = join(",", data.dns_a_record_set.postgres_db_dns.addrs)
    port             = 5432
}

resource "aws_lb_listener" "postgres_nlb_listener" {
    load_balancer_arn = aws_lb.postgres_networklb.arn
    port              = "5432"
    protocol          = "TCP"

    default_action {
        type       = "forward"
        target_group_arn = aws_lb_target_group.nlb-targetgrp-postgres.arn
    }
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