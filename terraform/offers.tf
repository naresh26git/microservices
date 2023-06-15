resource "kubernetes_deployment" "offer" {
  metadata {
    name      = "offer"
    namespace = "ms"

    labels = {
      app = "offer"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "offer"
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
          app = "offer"
        }
      }

      spec {
        container {
          name  = "offer"
          image = "comdevops/spring:v1"

          port {
            container_port = 1001
            name           = "offer"
          }
        }

        image_pull_secrets {
          name = "javapipe"
        }
      }
    }
  }
}

resource "kubernetes_service" "offer" {
  metadata {
    name      = "offer"
    namespace = "ms"
  }

  spec {
    selector = {
      app = "offer"
    }

    type = "ClusterIP"

    port {
      name       = "shoe"
      port       = 1001
      targetPort = 1001
    }
  }
}
