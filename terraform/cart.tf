resource "kubernetes_deployment" "cart" {
  metadata {
    name      = "cart"
    namespace = "ms"

    labels = {
      app = "cart"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "cart"
      }
    }

    replicas = 1

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
          app = "cart"
        }
      }

      spec {
        container {
          name  = "cart"
          image = "comdevops/ui:v4"

          image_pull_policy = "Always"

          port {
            container_port = 1004
            name           = "cart"
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
      app = "cart"
    }

    type = "ClusterIP"

    port {
      name       = "cart"
      port       = 1004
      targetPort = 1004
    }
  }
}
