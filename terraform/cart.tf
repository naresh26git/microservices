resource "kubernetes_namespace" "cart" {
  metadata {
    name = "ms"
  }
}
resource "kubernetes_deployment" "cart" {
  metadata {
    name      = "cart"
    namespace = "ms"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "cart"
      }
    }
    template {
      metadata {
        labels = {
          app = "cart"
        }
      }
      spec {
        container {
          image = "comdevops/ui:v2"
          name  = "cart"
          port {
            container_port = 1004
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "cart" {
  metadata {
    name      = "cart"
    namespace = "ms"
  }
  spec {
    selector = {
      app = kubernetes_deployment.cart.spec.0.template.0.metadata.0.labels.app
    }
    type = "ClusterIP"
    port {
      port        = 1004
      target_port = 1004
    }
  }
}