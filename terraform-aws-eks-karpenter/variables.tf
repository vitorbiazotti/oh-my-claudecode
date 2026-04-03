variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "eks-karpenter-bottlerocket"
}

variable "cluster_version" {
  description = "Versão do Kubernetes"
  type        = string
  default     = "1.35"
}

variable "region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Addons Flags
variable "enable_argocd" {
  description = "Ativar ArgoCD"
  type        = bool
  default     = true
}

variable "enable_keda" {
  description = "Ativar KEDA"
  type        = bool
  default     = true
}

variable "enable_external_secrets" {
  description = "Ativar External Secrets"
  type        = bool
  default     = true
}

variable "enable_kyverno" {
  description = "Ativar Kyverno"
  type        = bool
  default     = true
}

variable "enable_reloader" {
  description = "Ativar Reloader"
  type        = bool
  default     = true
}

variable "enable_aws_load_balancer_controller" {
  description = "Ativar AWS Load Balancer Controller"
  type        = bool
  default     = true
}

variable "enable_metrics_server" {
  description = "Ativar Metrics Server"
  type        = bool
  default     = true
}

variable "enable_external_dns" {
  description = "Ativar External DNS"
  type        = bool
  default     = true
}

variable "enable_cert_manager" {
  description = "Ativar Cert Manager"
  type        = bool
  default     = true
}

variable "enable_prometheus" {
  description = "Ativar Kube Prometheus Stack"
  type        = bool
  default     = true
}

variable "enable_vpa" {
  description = "Ativar Vertical Pod Autoscaler"
  type        = bool
  default     = true
}

variable "enable_descheduler" {
  description = "Ativar Descheduler"
  type        = bool
  default     = true
}
