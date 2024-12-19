resource "aws_efs_file_system" "efs" {
    creation_token = "efs"
    performance_mode = "generalPurpose"
    throughput_mode = "bursting"
    encrypted = "true"

  tags = {
    Name = "MyProduct"
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.aws_subnet_private_1
  security_groups = [var.sg_ids]
}

resource "aws_efs_mount_target" "efs_mnt" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.aws_subnet_private_2
  security_groups = [var.sg_ids]
}

output "efs_id" {
    value = "aws_efs_file_system.efs.id"
}