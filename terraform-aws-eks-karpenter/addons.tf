# 6. EKS Blueprints Addons
module "eks_blueprints_addons" {
  source  = "terraform-aws-modules/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  # Core Addons
  enable_metrics_server = var.enable_metrics_server
  
  # AWS Load Balancer Controller
  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller
  aws_load_balancer_controller = {
    wait_for_load_balancer = true
  }

  # ArgoCD
  enable_argocd = var.enable_argocd
  argocd = {
    name             = "argocd"
    namespace        = "argocd"
    create_namespace = true
    values           = [yamlencode({
      server = {
        service = {
          type = "LoadBalancer"
        }
      }
    })]
  }

  # KEDA
  enable_keda = var.enable_keda

  # External Secrets
  enable_external_secrets = var.enable_external_secrets

  # External DNS
  enable_external_dns = var.enable_external_dns

  # Kyverno
  enable_kyverno = var.enable_kyverno

  # Cert-manager
  enable_cert_manager = var.enable_cert_manager
  cert_manager = {
    set = [{
      name  = "installCRDs"
      value = "true"
    }]
  }

  # Kube Prometheus Stack (Grafana, Prometheus)
  enable_kube_prometheus_stack = var.enable_prometheus

  # Vertical Pod Autoscaler
  enable_vpa = var.enable_vpa
}

# Addon Reloader (Stakater)
resource "helm_release" "reloader" {
  count      = var.enable_reloader ? 1 : 0
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  namespace  = "kube-system"
  version    = "v1.0.69"

  depends_on = [module.eks]
}

# Addon Descheduler
resource "helm_release" "descheduler" {
  count      = var.enable_descheduler ? 1 : 0
  name       = "descheduler"
  repository = "https://kubernetes-sigs.github.io/descheduler"
  chart      = "descheduler"
  namespace  = "kube-system"
  version    = "0.29.0"

  values = [
    yamlencode({
      deschedulerPolicy = {
        strategies = {
          RemoveDuplicates = { enabled = true }
          RemovePodsViolatingInterPodAntiAffinity = { enabled = true }
          LowNodeUtilization = { enabled = true }
        }
      }
    })
  ]

  depends_on = [module.eks]
}
