output "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.cluster_name
}

output "vpc_id" {
  description = "ID da VPC"
  value       = module.vpc.vpc_id
}

output "karpenter_node_role_name" {
  description = "Nome da Role de IAM para os nodes do Karpenter"
  value       = module.karpenter.node_iam_role_name
}
