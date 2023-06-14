resource "kubernetes_namespace" "shoe" {
  metadata {
    name = "ms"
  }
}
resource "kubernetes_deployment" "shoe" {
  metadata {
    name      = "shoe"
    namespace = "ms"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "shoe"
      }
    }
    template {
      metadata {
        labels = {
          app = "shoe"
        }
      }
      spec {
        container {
          image = "comdevops/spring:v2"
          name  = "shoe"
          port {
            container_port = 1002
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "shoe" {
  metadata {
    name      = "shoe"
    namespace = "ms"
  }
  spec {
    selector = {
      app = kubernetes_deployment.shoe.spec.0.template.0.metadata.0.labels.app
    }
    type = "ClusterIP"
    port {
      port        = 1002
      target_port = 1002
    }
  }
}