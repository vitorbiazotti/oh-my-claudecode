# Proxmox Connection
variable "proxmox_endpoint" {
  description = "URL da API do Proxmox"
  type        = string
  default     = "https://192.168.88.82:8006/"
}

variable "proxmox_api_token" {
  description = "Token de API do Proxmox (id=secret)"
  type        = string
  sensitive   = true
  default     = "root@pam!tokentest=49980f05-1787-41d5-9f20-c952b71e17af"
}

variable "node_name" {
  description = "Nome do node do Proxmox"
  type        = string
  default     = "pve"
}

# Cluster Config
variable "cluster_name" {
  description = "Nome do cluster Kubernetes"
  type        = string
  default     = "64GB"
}

variable "cluster_endpoint" {
  description = "IP do primeiro Control Plane"
  type        = string
  default     = "192.168.88.90"
}

# VM Resources
variable "control_plane_count" {
  type    = number
  default = 3
}

variable "worker_count" {
  type    = number
  default = 3
}

# Addons Flags
variable "enable_argocd" {
  type    = bool
  default = true
}

variable "enable_keda" {
  type    = bool
  default = true
}

variable "enable_external_secrets" {
  type    = bool
  default = true
}

variable "enable_kyverno" {
  type    = bool
  default = true
}

variable "enable_reloader" {
  type    = bool
  default = true
}

variable "enable_metrics_server" {
  type    = bool
  default = true
}

variable "enable_prometheus" {
  type    = bool
  default = true
}

variable "enable_cert_manager" {
  type    = bool
  default = true
}

variable "enable_vpa" {
  type    = bool
  default = true
}

variable "enable_descheduler" {
  type    = bool
  default = true
}

# Proxmox Specific Addons
variable "enable_metallb" {
  description = "Ativar MetalLB"
  type        = bool
  default     = true
}

variable "enable_longhorn" {
  description = "Ativar Longhorn"
  type        = bool
  default     = true
}

variable "metallb_ip_range" {
  description = "Range de IPs para o MetalLB"
  type        = string
  default     = "192.168.88.200-192.168.88.250"
}
