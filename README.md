# Projet Car-Rental

## Objectif du Projet :
Le projet **Car-Rental** vise à développer un  backend  sécurisé d’une mini-application de location de voitures. L'application est basée sur une architecture microservices, déployée dans un environnement cloud, et utilise des technologies modernes pour assurer scalabilité, performance et sécurité. 

## Contexte Technologique :

- Le projet s'inscrit dans le cadre d'un cours sur les architectures cloud-native et les pratiques DevSecOps. Il met en œuvre les technologies suivantes : 

- Microservices : Développés en Java Spring Boot pour une modularité et une maintenabilité accrues. 

- Docker : Pour la conteneurisation des services. 

- Kubernetes : Pour l'orchestration des conteneurs et la gestion du cluster. 

- Google Cloud Platform (GCP) : Pour l'hébergement de l'infrastructure. 

- Terraform : Pour l'automatisation du déploiement de l'infrastructure (Infrastructure as Code). 

- Service Mesh (Istio) : Pour la gestion de la communication sécurisée entre les services. 

## Architecture simplifiée du Projet 
L'application est divisée en plusieurs microservices, chacun ayant une responsabilité spécifique. Voici un aperçu de l'architecture :
   ```
+-------------------+       +-------------------+       +-------------------+
|    Client         | ----> | API Gateway       | ----> | User Service      |
| (Navigateur/App)  |       | (Istio gateway )    |       | (Spring Boot)     |
+-------------------+       +-------------------+       +-------------------+
                                |                           |
                                v                           v
                    +-------------------+       +-------------------+
                    | Car Service       |       | Booking Service   |
                    | (Spring Boot)    |       | (Spring Boot)     |
                    +-------------------+       +-------------------+
                                |                           |
                                v                           v
                    +-------------------+       +-------------------+
                    | Payment Service   |       | Base de Données   |
                    | (Spring Boot)    |       | (MySQL dans un conteneur GKE)       |
                    +-------------------+       +-------------------+
                                |
                                v
                    +-------------------+
                    | Service Mesh      |
                    | (Istio)           |
                    +-------------------+
                                |
                                v
                    +-------------------+
                    | Terraform        |
                    | (Infra as Code)  |
                    +-------------------+
                                |
                                v
                    +-------------------+
                    | Google Cloud      |
                    | Platform (GCP)    |
                    +-------------------+


   ```

### Diagramme d'Architecture
![Architecture Car-Rental](architecture_car_rental.png)

## Architecture Globale :

L'application est divisée en plusieurs microservices, chacun ayant une responsabilité spécifique. L'architecture globale est la suivante : 

API Gateway : Un point d'entrée unique pour toutes les requêtes, qui les route vers les microservices appropriés. 

### Microservices : 

- User Service : Gère l'authentification et les informations des utilisateurs. 

- Car Service : Gère le catalogue des voitures disponibles. 

- Booking Service : Gère les réservations de voitures. 

- Payment Service : Gère les transactions de paiement. 

- Base de Données : Une base de données relationnelle (MySQL) stocke les données des utilisateurs, des voitures et des réservations. 

- Cluster Kubernetes : Les microservices sont déployés dans un cluster Kubernetes hébergé sur Google Kubernetes Engine (GKE). 

- Service Mesh (Istio) : Pour la gestion de la communication sécurisée entre les services et la configuration de l'api  gateway + virtual gateway vers les microservices. 

- Terraform : Automatise le déploiement de l'infrastructure sur GCP. 

Chaque  microservice est  une application autonome et développé séparément . 

## Diagramme d'Architecture 



## Technologies Utilisées
### Développement
- **Java Spring Boot** : Framework pour développer les microservices REST.
- **Service Mesh Istio** : Pour implémenter l'API Gateway.
- **Docker** : Pour conteneuriser les microservices.
- **Kubernetes** : Pour orchestrer les conteneurs et gérer le cluster.
- **Terraform** : Pour l'automatisation de l'infrastructure.

### Infrastructure
- **Google Cloud Platform (GCP)** :
  - **Google Kubernetes Engine (GKE)** : Pour héberger le cluster Kubernetes.
  - **Cloud SQL** : Pour la base de données MySQL/PostgreSQL.
  - **Cloud Storage** : Optionnel, pour stocker des fichiers (par exemple, des images de voitures).
- **Service Mesh (Istio)** : Pour la communication sécurisée entre les services.

### Sécurité
- **RBAC (Role-Based Access Control)** : Pour gérer les permissions dans Kubernetes.
- **mTLS (Mutual TLS)** : Pour chiffrer la communication entre les services.
- **Docker Content Trust** : Pour signer et vérifier les images Docker.

## Pipeline CI/CD avec Terraform et Kubernetes

Cette etape décrit les étapes du pipeline CI/CD pour déployer  l'application de location de voitures sur Google Cloud Platform (GCP) en utilisant Terraform et Kubernetes. Le pipeline inclut des aspects de sécurité et d'optimisation.

## 1. **Configuration de Terraform**

### 1.1. **Fournisseurs**
- **Google Cloud** : Utilisé pour gérer les ressources GCP.
- **Kubernetes** : Pour déployer et gérer les ressources Kubernetes.
- **Helm** : Pour gérer les charts Helm dans le cluster Kubernetes.

### 1.2. **Backend GCS**
- **Bucket** : `car-rental-bucket-2` pour stocker l'état de Terraform.
- **Prefix** : `terraform/state` pour organiser les fichiers d'état.

### 1.3. **Configuration des Providers**
- **Google** : Projet `car-rental-project-453100`, région `europe-west1`, zone `europe-west1-c`.
- **Kubernetes** : Utilise le fichier de configuration `~/.kube/config`.
- **Helm** : Utilise également `~/.kube/config`.

## 2. **Déploiement des Ressources**

### 2.1. **Instance GCE**
- **Nom** : `terraform`
- **Type de machine** : `e2-medium`
- **Image** : `debian-cloud/debian-11`
- **Réseau** : `default` avec une IP publique.
- **Cycle de vie** : Création avant destruction pour éviter les temps d'arrêt.

### 2.2. **ClusterRole et ClusterRoleBinding**
- **ClusterRole** : `cluster-admin` avec accès à toutes les ressources.
- **ClusterRoleBinding** : Associe `cluster-admin` à l'utilisateur `admin`.

### 2.3. **PeerAuthentication et Gateway TLS**
- **PeerAuthentication** : Active le mTLS en mode `STRICT` dans `istio-system`.
- **Gateway TLS** : Configure une passerelle TLS pour `example.com` avec un certificat `my-certificate`.

## 3. **Déploiement des Services**

### 3.1. **MySQL**
- **Déploiement** : Utilise l'image `hamadygackou/mysql-custom:latest`.
- **Service** : Exposé en mode `LoadBalancer` sur le port `3306`.
- **Stockage** : Utilise un `PersistentVolumeClaim` pour `/var/lib/mysql`.

### 3.2. **phpMyAdmin**
- **Déploiement** : Utilise l'image `phpmyadmin/phpmyadmin`.
- **Service** : Exposé en mode `LoadBalancer` sur le port `80`.

### 3.3. **User-Service**
- **Déploiement** : Utilise l'image `hamadygackou/user-service:latest`.
- **Service** : Exposé en mode `ClusterIP` sur le port `80`.

### 3.4. **Booking-Service**
- **Déploiement** : Utilise l'image `hamadygackou/booking-service:latest`.
- **Service** : Exposé en mode `ClusterIP` sur le port `80`.

### 3.5. **Payment-Service**
- **Déploiement** : Utilise l'image `hamadygackou/payment-service:latest`.
- **Service** : Exposé en mode `ClusterIP` sur le port `80`.

### 3.6. **Car-Service**
- **Déploiement** : Utilise l'image `hamadygackou/car-service:latest`.
- **Service** : Exposé en mode `ClusterIP` sur le port `80`.

## 4. **Sécurité**

### 4.1. **mTLS**
- **PeerAuthentication** : Active le mTLS pour sécuriser les communications entre les services.

### 4.2. **RBAC**
- **ClusterRole et ClusterRoleBinding** : Limite les permissions aux utilisateurs et services nécessaires.

### 4.3. **TLS**
- **Gateway TLS** : Sécurise les communications externes avec des certificats TLS.

## 5. **Optimisation**

### 5.1. **Cycle de Vie**
- **Création avant destruction** : Minimise les temps d'arrêt lors des mises à jour.

### 5.2. **Ressources**
- **Limites de ressources** : Définit des limites de CPU et mémoire pour chaque service pour éviter la surconsommation.

Ce pipeline CI/CD utilise Terraform pour provisionner les ressources sur GCP et Kubernetes pour déployer les services. Les aspects de sécurité comme le mTLS, RBAC, et TLS sont intégrés pour protéger l'application. Les ressources sont optimisées pour minimiser les temps d'arrêt et éviter la surconsommation.

Ci  après le code complet du pipeline  :

``` terraform
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

```


 
