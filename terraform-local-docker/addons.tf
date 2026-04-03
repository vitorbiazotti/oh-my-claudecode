# 1. ArgoCD
resource "helm_release" "argocd" {
  count            = var.enable_argocd ? 1 : 0
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  depends_on       = [k3d_cluster.local]

  # Configuração básica recomendada
  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }
}

# 2. Argo Rollouts
resource "helm_release" "argo_rollouts" {
  count            = var.enable_argo_rollouts ? 1 : 0
  name             = "argo-rollouts"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-rollouts"
  namespace        = "argo-rollouts"
  create_namespace = true
  depends_on       = [k3d_cluster.local]
}

# 3. KEDA
resource "helm_release" "keda" {
  count            = var.enable_keda ? 1 : 0
  name             = "keda"
  repository       = "https://kedacore.github.io/charts"
  chart            = "keda"
  namespace        = "keda"
  create_namespace = true
  depends_on       = [k3d_cluster.local]
}

# 5. Metrics Server (necessário para o KEDA/HPA)
resource "helm_release" "metrics_server" {
  count      = var.enable_metrics_server ? 1 : 0
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  depends_on = [k3d_cluster.local]

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }
}

