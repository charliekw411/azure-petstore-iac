# **azure-petstore-iac**

Rebuilding the Azure Pet Store project using Infrastructure as Code (IaC) with Terraform, focusing on containerization, Azure services, and streamlined deployments.

## **Overview**
This project demonstrates the use of Azure Developer CLI (`azd`) and Terraform for deploying containerized microservices to Azure, leveraging the following services:
- **Azure Container Registry (ACR):** For storing Docker images.
- **Azure App Service Plan:** Hosting the web applications.
- **Azure Web Apps:** Running containerized microservices.

---

## **Intended Deployment Workflow**

The deployment workflow is divided into two main stages:
1. **Provisioning Infrastructure with `azd`**
2. **Building and Deploying Applications with the `deploy.sh` Helper Script**

### **1. Provisioning Infrastructure with `azd`**

**What Gets Deployed:**
- **Azure Resource Group:** Hosts all resources. Note: I was using a pre-existing rg, so to create a new one, uncomment the `resource_group.tf` file
- **Azure Container Registry (ACR):** Stores Docker images for the microservices.
- **Azure App Service Plan:** Scales and hosts web apps.
- **Azure Web Apps:** Configured to pull container images from ACR.

**Commands to Run:**

1. **Initialize the environment:**
   ```bash
   azd auth login
   azd env new <environment-name> e.g dev, test, prod

2. **Provision resources:**
```bash
azd provision
```

### Building and Deploying the PetStore App with the Helper Script

- Builds Docker images for the Pet Store microservices.

- Pushes the images to ACR.

- Configures the Azure Web Apps to pull the latest images and run them.


Run the helper script:
```bash
./helpers/deploy.sh
```
The script performs the following steps:

Builds Docker images for:
petstoreapp
petstoreorderservice
petstorepetservice
petstoreproductservice

Pushes these images to ACR.

Updates the Azure Web Apps to pull and run the latest images.

