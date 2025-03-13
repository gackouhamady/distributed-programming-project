terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }

  # Configuration du backend GCS
  backend "gcs" {
    bucket = "car-rental-bucket-2"    # Nom du bucket
    prefix = "terraform/state"        # Dossier pour stocker l'état
  }
}

provider "google" {
  project = "car-rental-project-453100"
  region  = "europe-west1"
  zone    = "europe-west1-c"
}

# Configuration du fournisseur Kubernetes
provider "kubernetes" {
  config_path = "~/.kube/config"  # Chemin vers votre fichier kubeconfig
}

# Vérification de l'existence de l'instance GCE
data "google_compute_instance" "existing_instance" {
  name   = "terraform"
  zone   = "europe-west1-c"
}

# Création de l'instance GCE uniquement si elle n'existe pas déjà
resource "google_compute_instance" "terraform" {
  count = data.google_compute_instance.existing_instance == null ? 1 : 0

  name         = "terraform"
  machine_type = "e2-medium"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Configuration pour une IP publique
    }
  }

  allow_stopping_for_update = true

  lifecycle {
    create_before_destroy = true  # Créer la nouvelle instance avant de détruire l'ancienne
  }
}

# Déploiement Kubernetes pour le user-service
resource "kubernetes_deployment" "user-service" {
  metadata {
    name = "user-service"
  }

  spec {
    replicas = 1

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

          resources {
            requests = {
              cpu    = "200m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true  # Créer le nouveau déploiement avant de détruire l'ancien
  }
}

# Service Kubernetes pour exposer le user-service
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

  depends_on = [kubernetes_deployment.user-service]

  lifecycle {
    create_before_destroy = true  # Créer le nouveau service avant de détruire l'ancien
  }
}

# Horizontal Pod Autoscaler pour le user-service
resource "kubernetes_horizontal_pod_autoscaler" "user-service" {
  metadata {
    name = "user-service-hpa"
  }

  spec {
    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.user-service.metadata[0].name
    }

    min_replicas = 1
    max_replicas = 10

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 80
        }
      }
    }
  }

  depends_on = [kubernetes_deployment.user-service]
}

# Déploiement Kubernetes pour le booking-service
resource "kubernetes_deployment" "booking-service" {
  metadata {
    name = "booking-service"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "booking-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "booking-service"
        }
      }

      spec {
        container {
          name  = "booking-service"
          image = "hamadygackou/booking-service:latest"

          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = "200m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true  # Créer le nouveau déploiement avant de détruire l'ancien
  }
}

# Service Kubernetes pour exposer le booking-service
resource "kubernetes_service" "booking-service" {
  metadata {
    name = "booking-service"
  }

  spec {
    selector = {
      app = "booking-service"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.booking-service]

  lifecycle {
    create_before_destroy = true  # Créer le nouveau service avant de détruire l'ancien
  }
}

# Horizontal Pod Autoscaler pour le booking-service
resource "kubernetes_horizontal_pod_autoscaler" "booking-service" {
  metadata {
    name = "booking-service-hpa"
  }

  spec {
    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.booking-service.metadata[0].name
    }

    min_replicas = 1
    max_replicas = 10

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 80
        }
      }
    }
  }

  depends_on = [kubernetes_deployment.booking-service]
}

# Déploiement Kubernetes pour le payment-service
resource "kubernetes_deployment" "payment-service" {
  metadata {
    name = "payment-service"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "payment-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "payment-service"
        }
      }

      spec {
        container {
          name  = "payment-service"
          image = "hamadygackou/payment-service:latest"

          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = "200m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true  # Créer le nouveau déploiement avant de détruire l'ancien
  }
}

# Service Kubernetes pour exposer le payment-service
resource "kubernetes_service" "payment-service" {
  metadata {
    name = "payment-service"
  }

  spec {
    selector = {
      app = "payment-service"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.payment-service]

  lifecycle {
    create_before_destroy = true  # Créer le nouveau service avant de détruire l'ancien
  }
}

# Horizontal Pod Autoscaler pour le payment-service
resource "kubernetes_horizontal_pod_autoscaler" "payment-service" {
  metadata {
    name = "payment-service-hpa"
  }

  spec {
    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.payment-service.metadata[0].name
    }

    min_replicas = 1
    max_replicas = 10

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 80
        }
      }
    }
  }

  depends_on = [kubernetes_deployment.payment-service]
}

# Déploiement Kubernetes pour le car-service
resource "kubernetes_deployment" "car-service" {
  metadata {
    name = "car-service"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "car-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "car-service"
        }
      }

      spec {
        container {
          name  = "car-service"
          image = "hamadygackou/car-service:latest"

          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = "200m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true  # Créer le nouveau déploiement avant de détruire l'ancien
  }
}

# Service Kubernetes pour exposer le car-service
resource "kubernetes_service" "car-service" {
  metadata {
    name = "car-service"
  }

  spec {
    selector = {
      app = "car-service"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.car-service]

  lifecycle {
    create_before_destroy = true  # Créer le nouveau service avant de détruire l'ancien
  }
}

# Horizontal Pod Autoscaler pour le car-service
resource "kubernetes_horizontal_pod_autoscaler" "car-service" {
  metadata {
    name = "car-service-hpa"
  }

  spec {
    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.car-service.metadata[0].name
    }

    min_replicas = 1
    max_replicas = 10

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 80
        }
      }
    }
  }

  depends_on = [kubernetes_deployment.car-service]
}