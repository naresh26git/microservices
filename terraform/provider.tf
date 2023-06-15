terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.17.0"
    }
  }
  backend local {
    path = "tmp/terraform.tfstate"
  }
}

provider "kubernetes" {
    config_path    = "/root/.kube/config"
    config_context = "naresh.k8s.local"
    #host = "https://192.168.58.2:8443"
}