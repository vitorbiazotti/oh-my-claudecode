output "cluster_name" {
  value = k3d_cluster.local.name
}

output "kubeconfig" {
  value     = k3d_cluster.local.kubeconfig
  sensitive = true
}

output "instructions" {
  value = <<EOF
Cluster k3d '${var.cluster_name}' criado com sucesso!

Para acessar o cluster:
1. O kubeconfig foi atualizado automaticamente.
2. Verifique os nodes: kubectl get nodes
3. Verifique os addons:
   - ArgoCD: kubectl get pods -n argocd
   - Argo Rollouts: kubectl get pods -n argo-rollouts
   - KEDA: kubectl get pods -n keda
   - External Secrets: kubectl get pods -n external-secrets

Acesso HTTP (80) mapeado para localhost:8080
Acesso HTTPS (443) mapeado para localhost:8443
EOF
}
