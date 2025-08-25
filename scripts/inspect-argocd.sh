#!/bin/bash

# Wait until argocd-server pod is ready
echo "⏳ Waiting for argocd-server pod to be ready..."
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=180s

# Get the ArgoCD admin password
PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode)

# Get the NodePort for argocd-server (explicitly for port 443)
NODEPORT=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.spec.ports[?(@.port==443)].nodePort}')

# Local host
HOST="localhost"

# Docker internal IP
DOCKER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' k3d-c-argo-cluster-server-0)

# Pretty output
echo "======================================"
echo " 🚀 ArgoCD UI is available at:"
echo "     https://$HOST:$NODEPORT"
echo "     https://$DOCKER_IP:$NODEPORT"
echo ""
echo " 🔑 Login credentials:"
echo "     Username: admin"
echo "     Password: $PASSWORD"
echo "======================================"