

resource "aws_eks_cluster" "aws_eks" {
  name     = "eks_cluster_demo"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = module.vpc.public_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,  
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]

  tags = {
    Name = "EKS_Cluster_demo"
  }
}
  
  resource "aws_security_group" "allowed_security_group"{
    name = "allowed security group"
    vpc_id = module.vpc.vpc_id
      
    ingress{
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress{
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress{
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 30000
      to_port = 32000
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
      }

resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = "node_eks"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = module.vpc.public_subnets

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
