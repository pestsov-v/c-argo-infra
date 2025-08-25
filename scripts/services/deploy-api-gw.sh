#!/bin/bash

K8S_DIR="../../k8s/base/api-gw"

echo "======================================"
echo "🛠  Step 1: Apply SealedSecret"
echo "======================================"
kubectl apply -f "$K8S_DIR/sealed-secret.yaml"

echo ""
echo "======================================"
echo "🛠  Step 2: Apply Redis Deployment + Service"
echo "======================================"
kubectl apply -f "$K8S_DIR/redis-deployment.yaml"
kubectl apply -f "$K8S_DIR/redis-service.yaml"

echo ""
echo "======================================"
echo "🛠  Step 3: Apply API-GW Deployment + Service"
echo "======================================"
kubectl apply -f "$K8S_DIR/api-gw-deployment.yaml"
kubectl apply -f "$K8S_DIR/api-gw-service.yaml"

echo ""
echo "⏳ Waiting for API-GW pod to be ready..."
kubectl wait --for=condition=Ready pod -l app=api-gw-service --timeout=180s

echo "✅ Deployment complete!"
kubectl get pods -l app=api-gw-service
kubectl get svc api-gw-service