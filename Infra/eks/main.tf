resource "aws_eks_cluster" "my-cluster" {
    name = "my-cluster"
    role_arn = aws_iam_role.example.arn
    version = "1.29"

  vpc_config {
    subnet_ids = [var.subnet_private_1, var.subnet_private_2]
  }
  tage = {
    Name = "EKS"
  }
}

resource "aws_eks_node_group" "nodegroup" {
  cluster_name    = aws_eks_cluster.my-cluster.name
  node_group_name = "nodegroup"
  node_role_arn   = var.nodegroup_arn
  subnet_ids      = [var.subnet_private_1, var.subnet_private_2]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  tage = {
    Name = "EKSNodegroup"
  }

  update_config {
    max_unavailable = 1
  }

}

output "eksarn" {
    value = aws_eks_cluster.my-cluster.arn
}