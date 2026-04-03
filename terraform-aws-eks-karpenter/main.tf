data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

# 1. VPC Configuration
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.cluster_name
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k + 4)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    # Tags para descoberta automática pelo Karpenter
    "karpenter.sh/discovery" = var.cluster_name
  }
}

# 2. EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Pod Identity (Recomendado para Karpenter e Addons modernos)
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    # CoreDNS configurado para rodar no Fargate
    coredns = {
      configuration_values = jsonencode({
        computeType = "Fargate"
      })
    }
    vpc-cni    = {}
    kube-proxy = {}
  }

  # Fargate Profiles
  # Note: kube-system é necessário para o CoreDNS
  fargate_profiles = {
    kube-system = {
      selectors = [
        { namespace = "kube-system" }
      ]
    }
    karpenter = {
      selectors = [
        { namespace = "karpenter" }
      ]
    }
  }

  # Node Groups: Não criamos nenhum node group EC2 inicial, 
  # confiando no Fargate para os componentes críticos e Karpenter para o resto.
}
