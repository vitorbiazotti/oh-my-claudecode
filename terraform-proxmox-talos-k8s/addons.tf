# 1. MetalLB
resource "helm_release" "metallb" {
  count      = var.enable_metallb ? 1 : 0
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  namespace  = "metallb-system"
  create_namespace = true
  depends_on = [talos_cluster_kubeconfig.this]
}

# 2. Longhorn
resource "helm_release" "longhorn" {
  count      = var.enable_longhorn ? 1 : 0
  name       = "longhorn"
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  namespace  = "longhorn-system"
  create_namespace = true
  depends_on = [talos_cluster_kubeconfig.this]
}

# 3. ArgoCD
resource "helm_release" "argocd" {
  count      = var.enable_argocd ? 1 : 0
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true
  depends_on = [talos_cluster_kubeconfig.this]
}

# 4. KEDA
resource "helm_release" "keda" {
  count      = var.enable_keda ? 1 : 0
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  namespace  = "keda"
  create_namespace = true
  depends_on = [talos_cluster_kubeconfig.this]
}

# 5. External Secrets
resource "helm_release" "external_secrets" {
  count      = var.enable_external_secrets ? 1 : 0
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "external-secrets"
  create_namespace = true
  depends_on = [talos_cluster_kubeconfig.this]
}

# 6. Kyverno
resource "helm_release" "kyverno" {
  count      = var.enable_kyverno ? 1 : 0
  name       = "kyverno"
  repository = "https://kyverno.github.io/kyverno"
  chart      = "kyverno"
  namespace  = "kyverno"
  create_namespace = true
  depends_on = [talos_cluster_kubeconfig.this]
}

# 7. Metrics Server
resource "helm_release" "metrics_server" {
  count      = var.enable_metrics_server ? 1 : 0
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  depends_on = [talos_cluster_kubeconfig.this]
}

# 8. Prometheus Stack
resource "helm_release" "prometheus" {
  count      = var.enable_prometheus ? 1 : 0
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  create_namespace = true
  depends_on = [talos_cluster_kubeconfig.this]
}

# 9. Cert Manager
resource "helm_release" "cert_manager" {
  count      = var.enable_cert_manager ? 1 : 0
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  create_namespace = true
  set {
    name  = "installCRDs"
    value = "true"
  }
  depends_on = [talos_cluster_kubeconfig.this]
}

# 10. Reloader
resource "helm_release" "reloader" {
  count      = var.enable_reloader ? 1 : 0
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  namespace  = "kube-system"
  depends_on = [talos_cluster_kubeconfig.this]
}

# 11. VPA
resource "helm_release" "vpa" {
  count      = var.enable_vpa ? 1 : 0
  name       = "vpa"
  repository = "https://kubernetes-sigs.github.io/vertical-pod-autoscaler"
  chart      = "vertical-pod-autoscaler"
  namespace  = "kube-system"
  depends_on = [talos_cluster_kubeconfig.this]
}

# 12. Descheduler
resource "helm_release" "descheduler" {
  count      = var.enable_descheduler ? 1 : 0
  name       = "descheduler"
  repository = "https://kubernetes-sigs.github.io/descheduler"
  chart      = "descheduler"
  namespace  = "kube-system"
  depends_on = [talos_cluster_kubeconfig.this]
}
