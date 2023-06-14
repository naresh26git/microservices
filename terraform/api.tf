resource "kubernetes_namespace" "zuul-api" {
  metadata {
    name = "ms"
  }
}
resource "kubernetes_deployment" "zuul-api" {
  metadata {
    name      = "zuul-api"
    namespace = "ms"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "zuul-api"
      }
    }
    template {
      metadata {
        labels = {
          app = "zuul-api"
        }
      }
      spec {
        affinity {
          pod_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  app = "react-ui"
                }
              }
              topology_key = "kubernetes.io/hostname"
            }
          }
        }
        container {
          image = "comdevops/api:v1"
          name  = "zuul-api"
          port {
            container_port = 9999
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "zuul-api" {
  metadata {
    name      = "zuul-api"
    namespace = "ms"
  }
  spec {
    selector = {
      app = kubernetes_deployment.zuul-api.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      node_port   = 32470
      port        = 9999
      target_port = 9999
    }
  }
}
