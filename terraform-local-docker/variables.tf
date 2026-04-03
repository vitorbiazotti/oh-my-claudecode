variable "cluster_name" {
  description = "Nome do cluster k3d"
  type        = string
  default     = "local-dev"
}

variable "control_plane_count" {
  description = "Número de control plane nodes"
  type        = number
  default     = 1
}

variable "worker_count" {
  description = "Número de worker nodes"
  type        = number
  default     = 2
}

# Addons Flags
variable "enable_argocd" {
  description = "Habilitar ArgoCD"
  type        = bool
  default     = true
}

variable "enable_argo_rollouts" {
  description = "Habilitar Argo Rollouts"
  type        = bool
  default     = true
}

variable "enable_keda" {
  description = "Habilitar KEDA"
  type        = bool
  default     = true
}

variable "enable_external_secrets" {
  description = "Habilitar External Secrets"
  type        = bool
  default     = true
}

variable "enable_metrics_server" {
  description = "Habilitar Metrics Server (necessário para o KEDA)"
  type        = bool
  default     = true
}
