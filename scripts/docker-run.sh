#!/bin/bash
set -e

echo "Starting application with Docker Compose..."
docker compose down --remove-orphans
docker compose up --build -d

echo "Waiting for services to be healthy..."
sleep 10

echo "Checking service health..."
curl -s http://localhost:8080/health
echo ""
echo "Application is running at http://localhost:8080"
docker ps
