#!/bin/bash

# Variables
ACR_NAME="acrpetstoredev01"
RESOURCE_GROUP="rg-charlie"
WEB_APP_NAME="petstore-web-app" # Replace with your Web App name
LOCATION="australiaeast"
DOCKER_IMAGES=("petstoreapp" "petstoreorderservice" "petstorepetservice" "petstoreproductservice")

# Step 1: Authenticate to Azure and ACR
echo "Logging in to Azure..."
az login --output none

echo "Logging in to ACR..."
az acr login --name $ACR_NAME

# Step 2: Build and push Docker images
for image in "${DOCKER_IMAGES[@]}"; do
  echo "Building and pushing Docker image for $image..."
  docker build -t $ACR_NAME.azurecr.io/$image:latest ./app/$image
  docker push $ACR_NAME.azurecr.io/$image:latest
done

# Step 3: Configure the Web App to pull the images
for image in "${DOCKER_IMAGES[@]}"; do
  echo "Updating Web App $WEB_APP_NAME to pull the latest Docker image for $image..."
  az webapp config container set \
    --name $WEB_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --docker-custom-image-name $ACR_NAME.azurecr.io/$image:latest \
    --docker-registry-server-url https://$ACR_NAME.azurecr.io \
    --docker-registry-server-user $(az acr credential show --name $ACR_NAME --query username -o tsv) \
    --docker-registry-server-password $(az acr credential show --name $ACR_NAME --query passwords[0].value -o tsv)
done

echo "Docker images built, pushed to ACR, and Web App configured successfully!"
