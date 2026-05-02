#!/bin/bash
set -e

echo "Loading Docker image into Kind cluster..."
kind load docker-image container-assessment-backend:latest --name muchtodo-cluster

echo "Applying Kubernetes manifests..."
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/mongodb/mongodb-secret.yaml
kubectl apply -f kubernetes/mongodb/mongodb-configmap.yaml
kubectl apply -f kubernetes/mongodb/mongodb-pvc.yaml
kubectl apply -f kubernetes/mongodb/mongodb-deployment.yaml
kubectl apply -f kubernetes/mongodb/mongodb-service.yaml
kubectl apply -f kubernetes/backend/backend-secret.yaml
kubectl apply -f kubernetes/backend/backend-configmap.yaml
kubectl apply -f kubernetes/backend/backend-deployment.yaml
kubectl apply -f kubernetes/backend/backend-service.yaml
kubectl apply -f kubernetes/ingress.yaml

echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=mongodb -n muchtodo --timeout=120s
kubectl wait --for=condition=ready pod -l app=muchtodo-backend -n muchtodo --timeout=120s

echo "Deployment complete! Current status:"
kubectl get all -n muchtodo
