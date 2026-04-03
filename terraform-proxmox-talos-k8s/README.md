# Proxmox Kubernetes Cluster com Talos Linux

Este módulo automatiza a criação de um cluster Kubernetes imutável e seguro no Proxmox utilizando **Talos Linux**.

## Arquitetura e Equivalências (AWS vs Proxmox)

Para manter a paridade com o módulo EKS, foram feitas as seguintes substituições:

| Componente | AWS (EKS) | Proxmox (Local) |
| :--- | :--- | :--- |
| **Orquestrador** | EKS | Talos Linux (Kubernetes) |
| **Sistema Operacional** | Bottlerocket | Talos Linux |
| **Autoscale de Nodes** | Karpenter | Node Pools Estáticos (VMs Proxmox) |
| **Load Balancer** | AWS LBC | MetalLB |
| **Storage** | EBS | Longhorn |

## Requisitos
- Proxmox VE com API Token configurado.
- Template ou ISO do Talos Linux disponível no Proxmox.
- Terraform >= 1.5.0.

## Como Usar

```hcl
module "proxmox_k8s" {
  source = "./terraform-proxmox-talos-k8s"

  proxmox_endpoint  = "https://192.168.1.10:8006/"
  proxmox_api_token = "root@pam!token=secret"
  cluster_endpoint  = "192.168.1.50" # VIP ou IP do primeiro CP
  
  control_plane_count = 3
  worker_count        = 3

  enable_metallb   = true
  metallb_ip_range = "192.168.1.200-192.168.1.250"
  enable_longhorn  = true
  
  # Outros addons (ArgoCD, KEDA, Prometheus, etc)
  enable_argocd    = true
}
```

## Addons Incluídos
Todos os 12 addons do módulo EKS estão presentes, adaptados para o ambiente on-premises, garantindo a mesma stack tecnológica (GitOps, Observabilidade, Escalonamento).
