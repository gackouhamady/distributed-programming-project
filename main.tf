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
    create_before_destroy = true      # Créer la nouvelle instance avant de détruire l'ancienne
    ignore_changes = [
      # Si vous voulez ignorer des changements spécifiques
      name,
      machine_type
    ]
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
    create_before_destroy = true      # Créer le nouveau déploiement avant de détruire l'ancien
    ignore_changes = [
      # Vous pouvez ignorer des changements spécifiques
      replicas
    ]
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
    create_before_destroy = true      # Créer le nouveau service avant de détruire l'ancien
    ignore_changes = [
      # Vous pouvez ignorer des changements spécifiques
      selector
    ]
  }
}
