# Projet Car-Rental

## Description du Projet
Le projet **Car-Rental** est une application de location de voitures en ligne qui permet aux utilisateurs de rechercher, réserver et payer des voitures de manière simple et sécurisée. L'application est basée sur une architecture microservices, déployée dans un environnement cloud, et utilise des technologies modernes pour assurer scalabilité, performance et sécurité.

## Architecture du Projet
L'application est divisée en plusieurs microservices, chacun ayant une responsabilité spécifique. Voici un aperçu de l'architecture :
   ```
+-------------------+       +-------------------+       +-------------------+
|    Client         | ----> | API Gateway       | ----> | User Service      |
| (Navigateur/App)  |       | (Spring Cloud)    |       | (Spring Boot)     |
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
                    | (Spring Boot)    |       | (Cloud SQL)       |
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

## Étapes Initiales du Projet
1. **Configuration de l'Environnement** :
   - Installation des outils : Docker, Kubernetes (Minikube pour le développement local), Terraform, et les SDK GCP.
   - Création d'un projet sur GCP et activation des API nécessaires (GKE, Cloud SQL, etc.).
2. **Développement du Premier Microservice** :
   - Développement d'un microservice Spring Boot pour gérer l'authentification et les utilisateurs.
   - Dockerisation et publication de l'image Docker sur Google Container Registry (GCR).
3. **Déploiement Local avec Kubernetes** :
   - Création d'un cluster local avec Minikube.
   - Déploiement du User Service dans le cluster.
4. **Automatisation avec Terraform** :
   - Configuration de Terraform pour déployer l'infrastructure sur GCP (GKE, Cloud SQL).
   - Déploiement initial avec Terraform.

## Prochaines Étapes
1. **Développement des Autres Microservices** :
   - Car Service, Booking Service, et Payment Service.
2. **Intégration de l'API Gateway** :
   - Configuration de Spring Cloud Gateway pour router les requêtes.
3. **Ajout d'un Service Mesh** :
   - Configuration d'Istio pour la communication sécurisée entre les services.
4. **Déploiement dans le Cloud** :
   - Déploiement de l'application sur GCP avec Terraform.
5. **Tests et Validation** :
   - Tests fonctionnels, tests de performance, et validation de la sécurité.

## Comment Contribuer
1. Clonez le dépôt :
   ```bash
   git clone https://github.com/votre-utilisateur/car-rental.git
