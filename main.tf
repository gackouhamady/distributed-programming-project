terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }

  backend "gcs" {
    bucket = "car-rental-bucket-2"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "car-rental-project-453100"
  region  = "europe-west1"
  zone    = "europe-west1-c"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

locals {
  services = ["user-service", "booking-service", "payment-service", "car-service"]
}

resource "kubernetes_deployment" "services" {
  for_each = toset(local.services)

  metadata {
    name = each.key
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = each.key
      }
    }

    template {
      metadata {
        labels = {
          app = each.key
        }
      }

      spec {
        container {
          name  = each.key
          image = "hamadygackou/${each.key}:latest"

          port {
            container_port = 8080
          }
          resources {
            requests = {
              cpu    = "250m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "1Gi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "services" {
  for_each = toset(local.services)

  metadata {
    name = each.key
  }

  spec {
    selector = {
      app = each.key
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

# Autoscaling pour chaque service
resource "kubernetes_horizontal_pod_autoscaler" "services" {
  for_each = toset(local.services)

  metadata {
    name = each.key
  }

  spec {
    scale_target_ref {
      kind = "Deployment"
      name = each.key
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 5

    metrics {
      type = "Resource"
      resource {
        name  = "cpu"
        target {
          type    = "Utilization"
          average_utilization = 50  # Autoscale si CPU > 50%
        }
      }
    }
  }
}
