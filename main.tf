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

# Vérification de l'existence du déploiement Kubernetes
data "kubernetes_deployment" "existing_deployment" {
  metadata {
    name = "user-service"
    namespace = "default"
  }
}

# Création du déploiement Kubernetes uniquement s'il n'existe pas déjà
resource "kubernetes_deployment" "user-service" {
  count = data.kubernetes_deployment.existing_deployment == null ? 1 : 0

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

# Vérification de l'existence du service Kubernetes
data "kubernetes_service" "existing_service" {
  metadata {
    name = "user-service"
    namespace = "default"
  }
}

# Création du service Kubernetes uniquement s'il n'existe pas déjà
resource "kubernetes_service" "user-service" {
  count = data.kubernetes_service.existing_service == null ? 1 : 0

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