terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.40.0"  
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name = "SEI-Cluster"
  cluster_version = "1.30"

  vpc_id = "vpc-0ab91873"
  subnet_ids = ["subnet-0a83906c", "subnet-ae0ae8e5", "subnet-92acf0c8"]

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      min_size = 1
      max_size = 2
      desired_size = 1
    }
  }
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}