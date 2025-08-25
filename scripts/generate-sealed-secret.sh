#!/bin/bash
set -e

# ===================================================
# Script to generate a SealedSecret for Kubernetes
# ===================================================

# Parameters
SERVICE_NAME="$1"       # Name of the service (for reference)
SECRET_NAME="$2"        # Name of the Kubernetes Secret
OUTPUT_DIR="$3"         # Directory to save sealed-secret.yaml
USERNAME="$4"           # REDIS_USERNAME or other user
PASSWORD="$5"           # REDIS_PASSWORD or other secret

# Check for required arguments
if [ -z "$SERVICE_NAME" ] || [ -z "$SECRET_NAME" ] || [ -z "$OUTPUT_DIR" ] || [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
  echo "Usage: $0 <service_name> <secret_name> <output_dir> <username> <password>"
  exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Temporary Secret file
TEMP_SECRET="$OUTPUT_DIR/secret-template.yaml"

# Final SealedSecret file
SEALED_SECRET="$OUTPUT_DIR/sealed-secret.yaml"

# Step 1: Create temporary Kubernetes Secret
echo "Creating temporary Secret..."
kubectl create secret generic "$SECRET_NAME" \
  --from-literal=REDIS_USERNAME="$USERNAME" \
  --from-literal=REDIS_PASSWORD="$PASSWORD" \
  --dry-run=client -o yaml > "$TEMP_SECRET"

# Step 2: Seal the Secret using kubeseal
echo "Sealing the Secret..."
kubeseal --format=yaml < "$TEMP_SECRET" > "$SEALED_SECRET"

# Step 3: Clean up temporary secret
echo "Cleaning up temporary secret..."
rm "$TEMP_SECRET"

# Done
echo "✅ SealedSecret created at $SEALED_SECRET"