#!/bin/bash

# Step 1: Create namespace
kubectl create namespace argocd

# Step 2: Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait until argocd-server pod is ready
echo "⏳ Waiting for argocd-server pod to be ready..."
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=180s

kubectl apply -f ../setup/argocd-server-nodeport.yaml