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

# Création d'une instance Google Compute Engine
resource "google_compute_instance" "terraform" {
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

  # Dépendance explicite sur le déploiement
  depends_on = [kubernetes_deployment.user-service]

  lifecycle {
    create_before_destroy = true  # Créer le nouveau service avant de détruire l'ancien
  }
}
