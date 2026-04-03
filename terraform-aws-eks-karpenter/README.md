# AWS EKS with Karpenter and Addons (Bottlerocket)

Este módulo Terraform provisiona um cluster EKS (v1.35) configurado com:
- **CoreDNS e Karpenter no Fargate**: Arquitetura serverless para componentes críticos.
- **Karpenter (v1.10.0)**: Gerenciamento dinâmico de nodes utilizando **Bottlerocket**.
- **Addons**: ArgoCD, KEDA, External Secrets, Kyverno, Reloader, Metrics Server, AWS Load Balancer Controller, External DNS, **Cert-manager**, **Kube-Stack-Prometheus**, **Vertical Pod Autoscaler (VPA)** e **Descheduler**.

## Requisitos
- Terraform >= 1.5.0
- AWS CLI configurado
- Helm e Kubectl instalados localmente (para o provider)

## Como Usar

```hcl
module "eks_cluster" {
  source = "./terraform-aws-eks-karpenter"

  cluster_name    = "meu-cluster-eks"
  cluster_version = "1.35"
  region          = "us-east-1"

  enable_argocd        = true
  enable_keda          = true
  enable_kyverno       = true
  enable_reloader      = true
  # ... outros addons
}
```

## Arquitetura
1. **VPC**: Criada com subnets públicas e privadas, incluindo as tags necessárias para o Karpenter.
2. **EKS**: Cluster provisionado com suporte a Pod Identity.
3. **Fargate**: Profiles criados para os namespaces `kube-system` e `karpenter`.
4. **Karpenter**: Instalado via Helm no Fargate, configurado para provisionar instâncias Bottlerocket via `EC2NodeClass`.
5. **Addons**: Gerenciados via `eks-blueprints-addons`.

## Notas sobre EKS 1.35
O módulo utiliza a versão **1.35** e Karpenter **1.10.0** conforme solicitado.
