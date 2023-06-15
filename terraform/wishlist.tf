resource "kubernetes_deployment" "wishlist" {
  metadata {
    name      = "wishlist"
    namespace = "ms"

    labels = {
      app = "wishlist"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "wishlist"
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
          app = "wishlist"
        }
      }

      spec {
        container {
          name  = "offer"
          image = "comdevops/python:v1"

          port {
            container_port = 5000
            name           = "wishlist"
          }
        }

        image_pull_secrets {
          name = "javapipe"
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
      app = "wishlist"
    }

    type = "ClusterIP"

    port {
      name       = "wishlist"
      port       = 1003
      targetPort = 5000
    }
  }
}
