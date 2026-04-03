# 1. Gerar segredos do Talos
resource "talos_machine_secrets" "this" {}

# 2. Configuração do Control Plane
data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.cluster_endpoint}:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

# 3. Configuração do Worker
data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.cluster_endpoint}:6443"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

# 4. Aplicar configurações aos Nodes
resource "talos_machine_configuration_apply" "controlplane" {
  count                       = var.control_plane_count
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  endpoint                    = var.cluster_endpoint
  node                        = var.cluster_endpoint 

  depends_on = [proxmox_virtual_environment_vm.control_plane]
}

# 5. Bootstrap do Cluster
resource "talos_machine_bootstrap" "this" {
  depends_on           = [talos_machine_configuration_apply.controlplane]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.cluster_endpoint
}

# 6. Gerar Kubeconfig
resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.cluster_endpoint
}
