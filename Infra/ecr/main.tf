#Defining Resource - ECR Repository
resource "aws_ecr_repository" "ecr_repo" {
    count = length(var.ecr_repo)
    tage ={
        Name = var.ecr_repo[count.index]
    }
    name = var.ecr_repo[count.index]
}

# Policy Module
#Defining Resource - ECR Life Cycle Policy
resource "aws_ecr_lifecycle_policy" "ecr_lifecyclepolicy" {
    count = length(var.ecr_repo)
    repository = aws_exr_repository.ecr_repo[count.index].name

      policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF

}

# Defining Resource - ECR Repository Policy
resource "aws_ecr_repository_policy" "ecr_repopolicy"{
    count = length(var.ecr_repo)
    repository = aws_ecr_repository.ecr_repo[count.index.name]

    policy = <<EOF
    {
        "Version": "2008-10-17",
        "Statement": [
            {
                "Sid": "ECRPolicyForPullPublishAndDelete",
                "Effect": "Allow",
                "Principal": "*",
                "Action": [
                     "ecr:GetDownloadUrlForLayer",
                     "ecr:BatchGetImage",
                     "ecr:BatchCheckLayerAvailability",
                     "ecr:PutImage",
                     "ecr:InitiateLayerUpload",
                     "ecr:UploadLayerPart",
                     "ecr:CompleteLayerUpload",
                     "ecr:DescribeRepositories",
                     "ecr:GetRepositoryPolicy",
                     "ecr:ListImages",
                     "ecr:DeleteRepository",
                     "ecr:BatchDeleteImage",
                     "ecr:SetRepositoryPolicy",
                     "ecr:DeleteRepositoryPolicy",
                ]
            }
        ]
    }
    EOF
}