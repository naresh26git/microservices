provider "kubernetes" {
  config_context_cluster = "naresh.k8s.local"
}

resource "kubernetes_deployment" "zuul_api" {
  metadata {
    name      = "zuul-api"
    namespace = "ms"
    
    labels = {
      app = "zuul-api"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "zuul-api"
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
          app = "zuul-api"
        }
      }

      spec {
        container {
          name  = "zuul-api"
          image = "comdevops/api:v1"

          ports {
            name          = "zuul-api"
            container_port = 9999
          }
        }

        image_pull_secrets {
          name = "javapipe"
        }

        affinity {
          pod_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["react-ui"]
                }
              }
              topology_key = "kubernetes.io/hostname"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "zuul_api" {
  metadata {
    name      = "zuul-api"
    namespace = "ms"
  }

  spec {
    selector = {
      app = "zuul-api"
    }

    type = "NodePort"

    ports {
      name       = "zuul-api"
      port       = 9999
      target_port = 9999
      node_port  = 32470
    }
  }
}