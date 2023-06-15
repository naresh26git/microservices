resource "kubernetes_deployment" "shoe" {
  metadata {
    name      = "shoe"
    namespace = "ms"

    labels = {
      app = "shoe"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "shoe"
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
          app = "shoe"
        }
      }

      spec {
        container {
          name  = "shoe"
          image = "comdevops/spring:v2"

          port {
            container_port = 1002
            name           = "shoe"
          }
        }

        image_pull_secrets {
          name = "javapipe"
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
      app = "shoe"
    }

    type = "ClusterIP"

    port {
      name       = "shoe"
      port       = 1002
      targetPort = 1002
    }
  }
}
