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

## Architecture du Projet
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

### Composants Principaux
1. **Client** : L'interface utilisateur (navigateur web ou application mobile) interagit avec l'application via des API REST.
2. **API Gateway** : Un point d'entrée unique pour toutes les requêtes, qui les route vers les microservices appropriés.
3. **Microservices** :
   - **User Service** : Gère l'authentification et les informations des utilisateurs.
   - **Car Service** : Gère le catalogue des voitures disponibles.
   - **Booking Service** : Gère les réservations de voitures.
   - **Payment Service** : Gère les transactions de paiement.
4. **Base de Données** : Une base de données relationnelle (MySQL ou PostgreSQL) stocke les données des utilisateurs, des voitures et des réservations.
5. **Cluster Kubernetes** : Les microservices sont déployés dans un cluster Kubernetes hébergé sur Google Kubernetes Engine (GKE).
6. **Service Mesh (Istio)** : Facultatif, pour la gestion de la communication sécurisée entre les services.
7. **Terraform** : Automatise le déploiement de l'infrastructure sur GCP.

## Technologies Utilisées
### Développement
- **Java Spring Boot** : Framework pour développer les microservices REST.
- **Spring Cloud Gateway** : Pour implémenter l'API Gateway.
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

# Pipeline CI/CD avec Terraform et Kubernetes

Ce document décrit les étapes du pipeline CI/CD pour déployer une application de location de voitures sur Google Cloud Platform (GCP) en utilisant Terraform et Kubernetes. Le pipeline inclut des aspects de sécurité et d'optimisation.

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

## 6. **Conclusion**
Ce pipeline CI/CD utilise Terraform pour provisionner les ressources sur GCP et Kubernetes pour déployer les services. Les aspects de sécurité comme le mTLS, RBAC, et TLS sont intégrés pour protéger l'application. Les ressources sont optimisées pour minimiser les temps d'arrêt et éviter la surconsommation.


## Comment Contribuer
1. Clonez le dépôt :
   ```bash
   git clone https://github.com/votre-utilisateur/car-rental.git
