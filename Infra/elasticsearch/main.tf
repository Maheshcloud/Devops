resource "aws_elasticsearch_domain" "kubernetes_logs" {
  domain_name           = "example"
  elasticsearch_version = "7.10"

    access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "*",
    }
  ]
}
POLICY

  cluster_config {
    instance_type = "t3.medium.search"
    instance_count = 1
  }

  tags = {
    Domain = "TestDomain"
  }

  ebs_options {
    ebs_enabled = "true"
    volume_type = "standard"
    volume_size = 50
  }

  vpc_options {
    subnet_ids = [var.subnet_private_1]
    security_group_ids = [var.sg_internal_communication]
  }

}

output "elasticsearch_endpoint" {
    value = aws_elasticsearch_domain.kubernetes_logs.endpoint
}