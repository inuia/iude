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

# Create resource group
az group create --name "${resourceGroup}" --location "eastus"

# deploy 4-1106-8w
export regions=(AustraliaEast CanadaEast FranceCentral)
# Create Azure OpenAI resource in each region
for region in "${regions[@]}"
do
    echo "Creating resource in ${region}..."
    
    openai_name="isde-${region}-${subnum}"

    az cognitiveservices account create \
        --name "${openai_name}" \
        --resource-group "${resourceGroup}" \
        --kind "OpenAI" \
        --sku "S0" \
        --location "${region}" \
        --custom-domain "${openai_name}" \
        --yes

curl -X PUT "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.CognitiveServices/accounts/${accountName}/deployments/${deploymentName}?api-version=2023-10-01-preview" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $accessToken" \
  -d '{
    "sku": {
      "name": "Standard",
      "capacity": 80
    },
    "properties": {
      "dynamicThrottlingEnabled": true,
      "model": {
      "format": "OpenAI",
      "name": "gpt-4",
      "version": "1106-Preview"
      },
      "raiPolicyName":"Microsoft.Nil"
  }
  } '
  done

# Create resource group
az group create --name "${resourceGroup}" --location "eastus"

# deploy 4-1106-4w
export regions=(switzerlandnorth)
# Create Azure OpenAI resource in each region
for region in "${regions[@]}"
do
    echo "Creating resource in ${region}..."
    
    openai_name="isde-${region}-${subnum}"

    az cognitiveservices account create \
        --name "${openai_name}" \
        --resource-group "${resourceGroup}" \
        --kind "OpenAI" \
        --sku "S0" \
        --location "${region}" \
        --custom-domain "${openai_name}" \
        --yes

curl -X PUT "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.CognitiveServices/accounts/${accountName}/deployments/${deploymentName}?api-version=2023-10-01-preview" \
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
      "raiPolicyName":"Microsoft.Nil"
  }
  } '
  done

# deploy 4-1106-15w
export regions=(snorthcentralus swedencentral southindia)
# Create Azure OpenAI resource in each region
for region in "${regions[@]}"
do
    echo "Creating resource in ${region}..."
    
    openai_name="isde-${region}-${subnum}"

    az cognitiveservices account create \
        --name "${openai_name}" \
        --resource-group "${resourceGroup}" \
        --kind "OpenAI" \
        --sku "S0" \
        --location "${region}" \
        --custom-domain "${openai_name}" \
        --yes

curl -X PUT "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.CognitiveServices/accounts/${accountName}/deployments/${deploymentName}?api-version=2023-10-01-preview" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $accessToken" \
  -d '{
    "sku": {
      "name": "Standard",
      "capacity": 150
    },
    "properties": {
      "dynamicThrottlingEnabled": true,
      "model": {
      "format": "OpenAI",
      "name": "gpt-4",
      "version": "1106-Preview"
      },
      "raiPolicyName":"Microsoft.Nil"
  }
  } '
  done

  
  


#deploy GPT4-32K
export regions=(australiaeast CanadaEast SwedenCentral SwitzerlandNorth)

# Create Azure OpenAI resource in each region
for region in "${regions[@]}"
do
echo "Creating resource in ${region}..."

openai_name="isde-${region}-${subnum}"

az cognitiveservices account create \
        --name "${openai_name}" \
        --resource-group "${resourceGroup}" \
        --kind "OpenAI" \
        --sku "S0" \
        --location "${region}" \
        --custom-domain "${openai_name}" \
        --yes
# Deploy gpt-4-32k model to each resource

az cognitiveservices account deployment create \
--name "${openai_name}" \
--resource-group "${resourceGroup}" \
--deployment-name "${deploymentNameGpt432k}" \
--model-name gpt-4-32k \
--model-version "0613" \
--model-format OpenAI \
--sku-capacity "80" \
--sku-name "Standard"

done

export regions=(FranceCentral)
# Create Azure OpenAI resource in each region
echo "Creating resource in ${region}..."
openai_name="isde-${region}-${subnum}"
az cognitiveservices account deployment create \
--name "${openai_name}" \
--resource-group "${resourceGroup}" \
--deployment-name "${deploymentNameGpt432k}" \
--model-name gpt-4-32k \
--model-version "0613" \
--model-format OpenAI \
--sku-capacity "60" \
--sku-name "Standard"

