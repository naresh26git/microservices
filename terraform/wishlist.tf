resource "kubernetes_namespace" "wishlist" {
  metadata {
    name = "ms"
  }
}
resource "kubernetes_deployment" "wishlist" {
  metadata {
    name      = "wishlist"
    namespace = "ms"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "wishlist"
      }
    }
    template {
      metadata {
        labels = {
          app = "wishlist"
        }
      }
      spec {
        container {
          image = "comdevops/python:v1"
          name  = "wishlist"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "wishlist" {
  metadata {
    name      = "wishlist"
    namespace = "ms"
  }
  spec {
    selector = {
      app = kubernetes_deployment.wishlist.spec.0.template.0.metadata.0.labels.app
    }
    type = "ClusterIP"
    port {
      port        = 1003
      target_port = 5000
    }
  }
}