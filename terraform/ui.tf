provider "kubernetes" {
  config_context_cluster = "naresh.k8s.local"
  // Configure your Kubernetes provider settings here
}

resource "kubernetes_deployment" "react_ui" {
  metadata {
    name      = "react-ui"
    namespace = "ms"

    labels = {
      app = "react-ui"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "react-ui"
      }
    }

    strategy {
      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }
      type = "RollingUpdate"
    }

    template {
      metadata {
        labels = {
          app = "react-ui"
        }
      }

      spec {
        container {
          name  = "react-ui"
          image = "comdevops/ui:v1"

          image_pull_policy = "Always"

          port {
            container_port = 8080
            name           = "react-ui"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "react_ui" {
  metadata {
    name      = "react-ui"
    namespace = "ms"
  }

  spec {
    selector = {
      app = "react-ui"
    }

    type = "NodePort"

    port {
      name       = "react-ui"
      port       = 8081
      targetPort = 8080
    }
  }
}
