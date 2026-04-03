resource "k3d_cluster" "local" {
  name    = var.cluster_name
  servers = var.control_plane_count
  agents  = var.worker_count

  kubeconfig {
    update_default_kubeconfig = true
    switch_current_context    = true
  }

  k3d {
    disable_load_balancer = false
    disable_image_volume  = false
  }

  kube_api {
    host_port = 6443
  }

  # Port mapping for ingress (HTTP/HTTPS)
  port {
    host_port      = 8080
    container_port = 80
    node_filters = [
      "loadbalancer",
    ]
  }

  port {
    host_port      = 8443
    container_port = 443
    node_filters = [
      "loadbalancer",
    ]
  }
}
