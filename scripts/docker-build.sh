#!/bin/bash
set -e

echo "Building Docker image..."
docker build -t container-assessment-backend:latest .
echo "Docker image built successfully!"
docker images | grep container-assessment
