#!/bin/bash

# Delete old cluster if exists
k3d cluster delete c-argo-cluster

echo "======================================"
echo "🛠  Step 1: Creating k3d cluster 'c-argo-cluster'"
echo "======================================"

k3d cluster create c-argo-cluster \
  --servers 1 \
  --agents 1 \
  -p "6443:6443@server:0" \
  -p "80:80@loadbalancer" \
  -p "443:443@loadbalancer" \
  -p "31080:31080@loadbalancer" \
  -p "20080:20080@loadbalancer" \
  --k3s-arg "--disable=traefik@server:0" \
  --wait

echo "✅ Cluster 'c-argo-cluster' created successfully!"
echo ""

echo "======================================"
echo "🛠  Step 2: Setting kubectl context to the new cluster"
echo "======================================"

kubectl config use-context k3d-c-argo-cluster
echo "✅ kubectl context switched to 'k3d-c-argo-cluster'"
echo ""

echo "======================================"
echo "🛠  Step 3: Listing cluster nodes"
echo "======================================"

kubectl get nodes
echo "✅ Nodes listed above"
echo ""