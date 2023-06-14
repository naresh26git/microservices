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
    #host = "https://api-naresh-k8s-local-l7m81e-495f234ae5e25657.elb.ap-south-1.amazonaws.com"
}
