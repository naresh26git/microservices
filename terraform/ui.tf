provider "kubernetes" {
  config_context_cluster = "naresh.k8s.local"
}

resource "kubernetes_deployment" "example_deployment" {
  metadata {
    name      = "example-deployment"
    namespace = "example-namespace"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "example-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "example-app"
        }
      }

      spec {
        container {
          image = "your-container-image"
          name  = "example-container"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example_service" {
  metadata {
    name      = "example-service"
    namespace = "example-namespace"
  }

  spec {
    selector = {
      app = "example-app"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
