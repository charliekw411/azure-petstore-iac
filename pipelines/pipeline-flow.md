### Summary of Flow:
- The pipeline builds and pushes Docker images to the ACR.
- The pipeline also deploys the docker-compose.yaml file to the App Service.
- The App Service then reads the docker-compose.yaml and pulls the relevant images from ACR to run the multi-container app.