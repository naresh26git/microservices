resource "kubernetes_namespace" "react-ui" {
  metadata {
    name = "ms"
  }
}
resource "kubernetes_deployment" "react-ui" {
  metadata {
    name      = "react-ui"
    namespace = "ms"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "react-ui"
      }
    }
    template {
      metadata {
        labels = {
          app = "react-ui"
        }
      }
      spec {
        container {
          image = "comdevops/ui:v1"
          name  = "react-ui"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "react-ui" {
  metadata {
    name      = "react-ui"
    namespace = "ms"
  }
  spec {
    selector = {
      app = kubernetes_deployment.react-ui.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      node_port   = 30202
      port        = 8081
      target_port = 8080
    }
  }
}