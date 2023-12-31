#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]
then
echo "No argument supplied"
exit 1
fi

export subscriptionId=$1
export subnum=$2

echo "Subscription ID: ${subscriptionId}"

az account set --subscription ${subscriptionId}

# change the following regions to alias as above

export resourceGroup="openai" # Your resource group name
export deploymentName="gpt-35-turbo"
export deploymentName16k="gpt-35-turbo-16k"
export deploymentNameGpt4="gpt-4"
export deploymentNameGpt432k="gpt-4-32k"
export accessToken=$(az account get-access-token --resource https://management.core.windows.net -o json | jq -r .accessToken)

# Create resource group
az group create --name "${resourceGroup}" --location "eastus"

# deploy 4-1106-4w
export regions=(CanadaEast)
# Create Azure OpenAI resource in each region
for region in "${regions[@]}"
do
    echo "Creating resource in ${region}..."
    
    openai_name="${region}-${subnum}"

    az cognitiveservices account create \
        --name "${openai_name}" \
        --resource-group "${resourceGroup}" \
        --kind "OpenAI" \
        --sku "S0" \
        --location "${region}" \
        --custom-domain "${openai_name}" \
        --yes

# Deploy gpt-4-1106 model to each resource

az cognitiveservices account deployment create \
 --name "${openai_name}" \
 --resource-group "${resourceGroup}" \
 --deployment-name "$deploymentNameGpt4" \
 --model-name gpt-4 \
 --model-version "1106-Preview" \
 --model-format OpenAI \
 --sku-capacity "40" \
 --sku-name "Standard"


curl -X PUT "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.CognitiveServices/accounts/${accountName}/deployments/${openai_name}?api-version=2023-10-01-preview" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $accessToken" \
  -d '{
    "sku": {
      "name": "Standard",
      "capacity": 40
    },
    "properties": {
      "dynamicThrottlingEnabled": true,
      "model": {
      "format": "OpenAI",
      "name": "gpt-4",
      "version": "1106-Preview"
      },
     "rateLimits": {
      
      }, 
      "raiPolicyName":"Microsoft.Nil"
  }
  } '
  done



