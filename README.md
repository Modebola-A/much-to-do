# MuchTodo Container Assessment

## Overview
This project containerizes the MuchTodo Golang backend API with MongoDB using Docker and Kubernetes (Kind).

## Prerequisites
- Docker
- Docker Compose
- kubectl
- Kind

## Project Structure
container-assessment/
├── Dockerfile
├── docker-compose.yaml
├── .dockerignore
├── .env
├── kubernetes/
│   ├── namespace.yaml
│   ├── mongodb/
│   │   ├── mongodb-secret.yaml
│   │   ├── mongodb-configmap.yaml
│   │   ├── mongodb-pvc.yaml
│   │   ├── mongodb-deployment.yaml
│   │   └── mongodb-service.yaml
│   ├── backend/
│   │   ├── backend-secret.yaml
│   │   ├── backend-configmap.yaml
│   │   ├── backend-deployment.yaml
│   │   └── backend-service.yaml
│   └── ingress.yaml
├── scripts/
│   ├── docker-build.sh
│   ├── docker-run.sh
│   ├── k8s-deploy.sh
│   └── k8s-cleanup.sh
└── evidence/
Phase 1: Docker Setup
Build and Run with Docker Compose
bash# Build the image
./scripts/docker-build.sh

# Run with docker compose
./scripts/docker-run.sh

# Test the application
curl http://localhost:8080/health
curl http://localhost:8080/ping
Phase 2: Kubernetes Deployment
Create Kind Cluster
bashkind create cluster --config kind-cluster-config.yaml
Deploy to Kubernetes
bash./scripts/k8s-deploy.sh
Test the application
bashcurl http://localhost:30080/health
curl http://localhost:30080/ping
Cleanup
bash./scripts/k8s-cleanup.sh

| Variable             | Description                  | Default                                    |
|----------------------|------------------------------|--------------------------------------------|
| PORT                 | Application port             | 8080                                       |
| MONGO_URI            | MongoDB connection string    | mongodb://mongodb:27017/much_todo_db       |
| DB_NAME              | Database name                | much_todo_db                               |
| JWT_SECRET_KEY       | JWT signing key              | your-super-secret-key                      |
| JWT_EXPIRATION_HOURS | JWT token expiry in hours    | 72                                         |
| LOG_LEVEL            | Logging level                | INFO                                       |
| LOG_FORMAT           | Log format (json or text)    | json                                       |
| ENABLE_CACHE         | Enable Redis caching         | false                                      |
| REDIS_ADDR           | Redis address                | localhost:6379                             |
| REDIS_PASSWORD       | Redis password               | ""                                         |

---

### Verify everything is in place:
```bash
ls ~/container-assessment/scripts/
ls ~/container-assessment/kubernetes/
ls ~/container-assessment/kubernetes/mongodb/
ls ~/container-assessment/kubernetes/backend/
```
