

variable "sg_ids" {
    default = ""
}

variable "eks_role_arn" {
    default = ""
}

variable "nodegroup_arn" {
    default = ""
}

variable "subnet_private_1" {
    default = ""
}

variable "sg_internal_communication" {
    default = ""
}


variable "subnet_private_1" {
    default = ""
}

variable "subnet_private_2" {
    default = ""
}

variable "subnet_public_1" {
    default = ""
}

variable "subnet_public_2" {
    default = ""
}

variable "external_sg" {
    default = ""
}

variable "vpc_id" {
    default = ""
}

variable "allocated-storage" {
    description = "storage for the db"
    default = "100"
}

variable "storage_type" {
    description = "storage type"
    default = "gp2"
}

variable "engine" {
    description = "db engine"
    default = "postgres"
}

variable "engine_version" {
    description = "version of engine needs to be used"
    default = "13.3"
}

variable "instance_class" {
    description = "instance class needs to be used"
    default = "db.m5.large"
}

variable "name_master" {
    description = "name of the master can be used as identifier"
    default = "postgresmaster"
}

variable "username" {
    description = "user name of the database"
    default = "testuser"
}

variable "password" {
    description = "password of the database"
    default = "postgresql"
}

variable "availability_zone" {
    description = "availability zone  which we want to deploy"
    default = "us-east-1"
}

variable "enabled_cloudwatch_logs_exports" {
    description = "Cloudwatch logs"
    default = ["postgresql","upgrade"]
}

variable "storage_encrypted" {
    description = "enabling the storage encryption"
    default = "true"
}

variable "backup_retention_period" {
    description = "backup retention days"
    default = "5"
}

variable "backup_window" {
    description = "backup window time for database"
    default = "12:30-04:30"
}

variable "copy_tags_to_snapshot" {
    description = "copying tags to the snapshot"
    default = "true"
}

variable "delete_automated_backups" {
    description = "deleting backuops"
    default = "true"
}

variable "deletion_protection" {
    description = "deleting database"
    default = "false"
}

variable "database-port" {
    description = "database port"
    default = "5432"
}

variable "vpc_sg_ids" {
    description = "security group for databae"
    default = [""]
}



