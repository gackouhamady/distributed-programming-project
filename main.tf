terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }

  # Configuration du backend GCS :end 
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

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Création de l'in-stance GCE uniquement si elle n'existe pas déjà
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

# ClusterRole pour permettre l'accès à toutes les ressources
resource "kubernetes_cluster_role" "cluster_admin" {
  metadata {
    name = "cluster-admin"
  }

  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

# ClusterRoleBinding pour associer le ClusterRole à un utilisateur
resource "kubernetes_cluster_role_binding" "admin_binding" {
  metadata {
    name = "admin-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cluster_admin.metadata[0].name
  }

  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
}

# PeerAuthentication pour activer le mTLS
resource "kubernetes_manifest" "peer_authentication" {
  provider = kubernetes

  manifest = {
    apiVersion = "security.istio.io/v1beta1"
    kind       = "PeerAuthentication"
    metadata = {
      name      = "default"
      namespace = "istio-system"
    }
    spec = {
      mtls = {
        mode = "STRICT"
      }
    }
  }
}

# Gateway avec TLS
resource "kubernetes_manifest" "tls_gateway" {
  provider = kubernetes

  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "Gateway"
    metadata = {
      name      = "tls-gateway"
      namespace = "default"
    }
    spec = {
      selector = {
        istio = "ingressgateway"
      }
      servers = [
        {
          port = {
            number   = 443
            name     = "https"
            protocol = "HTTPS"
          }
          tls = {
            mode           = "SIMPLE"
            credentialName = "my-certificate"
          }
          hosts = ["example.com"]
        }
      ]
    }
  }
}

# Déploiement Kubernetes pour MySQL
resource "kubernetes_deployment" "mysql" {
  metadata {
    name = "mysql"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "hamadygackou/mysql-custom:latest"

          port {
            container_port = 3306
          }

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "password"
          }
          env {
            name  = "MYSQL_DATABASE"
            value = "carrentaldb"
          }
          env {
            name  = "MYSQL_USER"
            value = "user"
          }
          env {
            name  = "MYSQL_PASSWORD"
            value = "password"
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "500Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "1Gi"
            }
          }

          volume_mount {
            name       = "mysql-persistent-storage"
            mount_path = "/var/lib/mysql"
          }
        }

        volume {
          name = "mysql-persistent-storage"
          persistent_volume_claim {
            claim_name = "mysql-pv-claim"
          }
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true  # Créer le nouveau déploiement avant de détruire l'ancien
  }
}

# Service Kubernetes pour exposer MySQL en mode LoadBalancer
resource "kubernetes_service" "mysql" {
  metadata {
    name = "mysql"
  }

  spec {
    selector = {
      app = "mysql"
    }

    port {
      port        = 3306
      target_port = 3306
    }

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.mysql]

  lifecycle {
    create_before_destroy = true  # Créer le nouveau service avant de détruire l'ancien
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
              cpu    = "100m"
              memory = "200Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "400Mi"
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

# Déploiement Kubernetes pour phpMyAdmin
resource "kubernetes_deployment" "phpmyadmin" {
  metadata {
    name = "phpmyadmin"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "phpmyadmin"
      }
    }

    template {
      metadata {
        labels = {
          app = "phpmyadmin"
        }
      }

      spec {
        container {
          name  = "phpmyadmin"
          image = "phpmyadmin/phpmyadmin"

          port {
            container_port = 80
          }

          env {
            name  = "PMA_HOST"
            value = "mysql"  # Nom du service MySQL
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "200Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "400Mi"
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

# Service Kubernetes pour exposer phpMyAdmin en mode LoadBalancer
resource "kubernetes_service" "phpmyadmin" {
  metadata {
    name = "phpmyadmin"
  }

  spec {
    selector = {
      app = "phpmyadmin"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.phpmyadmin]

  lifecycle {
    create_before_destroy = true  # Créer le nouveau service avant de détruire l'ancien
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

    type = "ClusterIP"
  }

  depends_on = [kubernetes_deployment.user-service]

  lifecycle {
    create_before_destroy = true  # Créer le nouveau service avant de détruire l'ancien
  }
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
              cpu    = "100m"
              memory = "200Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "400Mi"
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

    type = "ClusterIP"
  }

  depends_on = [kubernetes_deployment.booking-service]

  lifecycle {
    create_before_destroy = true  # Créer le nouveau service avant de détruire l'ancien
  }
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
              cpu    = "100m"
              memory = "200Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "400Mi"
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

    type = "ClusterIP"
  }

  depends_on = [kubernetes_deployment.payment-service]

  lifecycle {
    create_before_destroy = true  # Créer le nouveau service avant de détruire l'ancien
  }
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
              cpu    = "100m"
              memory = "200Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "400Mi"
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

    type = "ClusterIP"
  }

  depends_on = [kubernetes_deployment.car-service]

  lifecycle {
    create_before_destroy = true  # Créer le nouveau service avant de détruire l'ancien
  }
}


### End project 