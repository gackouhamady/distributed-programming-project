resource "kubernetes_deployment" "user-service" {
  metadata {
    name = "user-service"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "user-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "user-service"
        }
      }

      spec {
        container {
          name  = "user-service"
          image = "hamadygackou/user-service:latest"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "user-service" {
  metadata {
    name = "user-service"
  }

  spec {
    selector = {
      app = "user-service"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}