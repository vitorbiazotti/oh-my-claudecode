terraform {
  required_version = ">= 1.5.0"

  required_providers {
    k3d = {
      source  = "pvotal-tech/k3d"
      version = "0.0.7"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}

provider "k3d" {}

provider "kubernetes" {
  host                   = k3d_cluster.local.credentials[0].host
  client_certificate     = k3d_cluster.local.credentials[0].client_certificate
  client_key             = k3d_cluster.local.credentials[0].client_key
  cluster_ca_certificate = k3d_cluster.local.credentials[0].cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = k3d_cluster.local.credentials[0].host
    client_certificate     = k3d_cluster.local.credentials[0].client_certificate
    client_key             = k3d_cluster.local.credentials[0].client_key
    cluster_ca_certificate = k3d_cluster.local.credentials[0].cluster_ca_certificate
  }
}
