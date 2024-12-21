# Source the secrets.ps1 file to get the necessary environment variables
. ../secrets.ps1

Write-host "Subscription ID: $env:ARM_SUBSCRIPTION_ID"

# Check if the necessary environment variables are set
if (-not $env:ARM_TENANT_ID -or -not $env:ARM_SUBSCRIPTION_ID) {
    Write-Warning "Please set ARM_TENANT_ID and ARM_SUBSCRIPTION_ID in the secrets.ps1 file."
    return
}

# Authenticate to Azure using az CLI
try {
    az login --tenant $env:ARM_TENANT_ID
    Write-Host "Authenticated to Azure successfully."
}
catch {
    Write-Error "Failed to authenticate to Azure using az CLI. Please check your secrets.ps1 values."
    return
}

# Variables for the new User Managed Identity (UMI)
$umiName = "petstore-umi"    # Change this name to your desired UMI name
$rgName = "rg-azure-petstore-auea"  # Name of the resource group
$location = "AustraliaEast"          # Azure region for UMI
$role = "Contributor"                # Role to assign to the UMI
$storageRole = "Storage Blob Data Contributor"  # Role to assign to the UMI for storage account

# check if the UMI already exists
try {
    $umi = az identity show --name $umiName --resource-group $rgName --subscription "27f32cc1-e01f-493b-8f40-dc7a879baa65" --query "{clientId:clientId, principalId:principalId, id:id}" -o json | ConvertFrom-Json
    if ($null -ne $umi) {
        Write-Host "User Managed Identity '$umiName' already exists."
    }
    else {
        Write-Host "User Managed Identity '$umiName' does not exist. Creating new UMI..."
        $umi = az identity create --name $umiName --resource-group $rgName --location $location --subscription "27f32cc1-e01f-493b-8f40-dc7a879baa65" --query "{clientId:clientId, principalId:principalId, id:id}" -o json | ConvertFrom-Json
        Write-Host "User Managed Identity '$umiName' created successfully."
    }
}
catch {
    Write-Error "Failed to check or create User Managed Identity. Error: $_"
    return
}

# Create the User Managed Identity in the specified resource group
try {
    $umi = az identity create --name $umiName --resource-group $rgName --location $location --subscription "27f32cc1-e01f-493b-8f40-dc7a879baa65" --query "{clientId:clientId, principalId:principalId, id:id}" -o json | ConvertFrom-Json
    Write-Host "User Managed Identity '$umiName' created successfully."
    Write-Host "Details:"
    Write-Host "-------------------------------------"
    Write-Host "Client ID (ApplicationId): $($umi.clientId)"
    Write-Host "Principal ID: $($umi.principalId)"
    Write-Host "Resource ID: $($umi.id)"
    Write-Host "Resource Group: $rgName"
    Write-Host "Subscription ID: 27f32cc1-e01f-493b-8f40-dc7a879baa65"
    Write-Host "-------------------------------------"
    Write-Host "Please make sure to securely store these details."
}
catch {
    Write-Error "Failed to create User Managed Identity. Error: $_"
}
############################################
# Assign roles to the User Managed Identity
############################################

# Assign Contributor role to the UMI at the subscription level. This will allow the pipeline to deploy resources using this UMI
try {
    az role assignment create --assignee-object-id $umi.principalId --role $role --scope "/subscriptions/$subscriptionId" --assignee-principal-type ServicePrincipal
    Write-Host "Assigned '$role' role to UMI '$umiName' at subscription level successfully."
}
catch {
    Write-Error "Failed to assign role to UMI. Error: $_"
}

# Assign ACRPush role to the UMI at the resource level. This will allow the pipeline to push images to the ACR
try {
    # Get the ACR ID
    # Get the ACR resource ID
    $acrName = "acrpetstoredev01"  # Name of your ACR
    $acrId = az acr show --name $acrName --resource-group $rgName --query "id" -o tsv
    
    # Assign the AcrPush role to the UMI
    az role assignment create --assignee-object-id $umi.principalId --role $acrRole --scope $acrId --assignee-principal-type ServicePrincipal
    Write-Host "Assigned '$acrRole' role to UMI '$umiName' at ACR level successfully."
}
catch {
    Write-Error "Failed to assign AcrPush role to UMI. Error: $_"
}

# Assign Storage Blob Data Contributor role to the UMI at the storage account level
try {
    # Get the storage account ID
    $storageAccountName = "sttfpetstoredev01"  # Replace with your storage account name
    $storageAccountId = az storage account show --name $storageAccountName --resource-group $rgName --query "id" -o tsv
    
    # Assign the Storage Blob Data Contributor role to the UMI
    az role assignment create --assignee-object-id $umi.principalId --role $storageRole --scope $storageAccountId --assignee-principal-type ServicePrincipal
    Write-Host "Assigned '$storageRole' role to UMI '$umiName' at storage account level successfully."
}
catch {
    Write-Error "Failed to assign $storageRole role to UMI. Error: $_"
}
