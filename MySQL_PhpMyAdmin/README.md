# Instruction  to  deploy  Mysql  database on the google cloud : GKE

Proceed to run theses commands lines  one  by  one  


kubectl apply -f mysql-pvc.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml


# Pour  le PhpMyAdmin

kubectl apply -f phpmyadmin-deployment.yaml
kubectl apply -f phpmyadmin-service.yaml