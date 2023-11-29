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

# export regions=(australiaeast)
# export regions=(CanadaEast SwedenCentral AustraliaEast)

export resourceGroup="openai" # Your resource group name
export deploymentName="gpt-35-turbo"
export deploymentName16k="gpt-35-turbo-16k"
export deploymentNameGpt4="gpt-4"
export deploymentNameGpt432k="gpt-4-32k"

# deploy gpt3.5
export regions=(AustraliaEast CanadaEast EastUS EastUS2 FranceCentral JapanEast NorthCentralUS SwedenCentral SwitzerlandNorth UKSouth westeurope)
# Create resource group
az group create --name "${resourceGroup}" --location "eastus"

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

    # 35
    Deploy GPT-35-Turbo model to each resource
    az cognitiveservices account deployment create \
      --name "${openai_name}" \
      --resource-group "${resourceGroup}" \
      --deployment-name "${deploymentName}" \
      --model-name gpt-35-turbo \
      --model-version "0613"  \
      --model-format OpenAI \
      --sku-capacity "240" \
      --sku-name "Standard"
# 35 - 16k
# Deploy GPT-35-Turbo-16k model to each resource
az cognitiveservices account deployment create \
--name "${openai_name}" \
--resource-group "${resourceGroup}" \
--deployment-name "${deploymentName16k}" \
--model-name gpt-35-turbo-16k \
--model-version "0613" \
--model-format OpenAI \
--sku-capacity "240" \
--sku-name "Standard"

done

# Deploy GPT-35-Turbo model to WestEuro
regions=(westeurope)
    az cognitiveservices account deployment create \
      --name "${openai_name}" \
      --resource-group "${resourceGroup}" \
      --deployment-name "${deploymentName}" \
      --model-name gpt-35-turbo \
      --model-version "0301"  \
      --model-format OpenAI \
      --sku-capacity "240" \
      --sku-name "Standard"

#deploy GPT4-0613
export regions=(SWITZERLANDNORTH)
az cognitiveservices account deployment create \
--name "${openai_name}" \
--resource-group "${resourceGroup}" \
--deployment-name "${deploymentNameGpt4}" \
--model-name gpt-4 \
--model-version "0613" \
--model-format OpenAI \
--sku-capacity "40" \
--sku-name "Standard"

#deploy GPT4-32K
export regions=(CanadaEast SwedenCentral SwitzerlandNorth)

# Create Azure OpenAI resource in each region
for region in "${regions[@]}"
do
echo "Creating resource in ${region}..."

openai_name="isde-${region}-${subnum}"

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

# 4-1106
# Deploy gpt-4-1106 model to each resource : 150K
export regions=(southIndia NORWAYEAST SWEDENCENTRAL)
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
        
# Deploy gpt-4-1106-preview model to each resource
# az cognitiveservices account deployment create \
# --name "${openai_name}" \
# --resource-group "${resourceGroup}" \
# --deployment-name "${deploymentNameGpt4}" \
# --model-name gpt-4 \
# --model-version "1106-Preview" \
# --model-format OpenAI \
# --sku-capacity "150" \
# --sku-name "Standard"
# Deploy gpt-4-1106-preview model to each resource and close filter 150K      
  accountNames="isde-${region}-${subnum}"
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

# Deploy gpt-4-1106-preview model to each resource and close filter: 80K
export deploymentName="gpt-4"
export accessToken=$(az account get-access-token --resource https://management.core.windows.net -o json | jq -r .accessToken)
export regions=(AustraliaEast UKSOUTH eastus2 westus FRANCECENTRAL CANADAEAST)
for region in "${regions[@]}"
do
  echo "Creating resource in ${region}..."
  openai_name="isde-${region}-${subnum}"
# Create Azure OpenAI resource in each region
  az cognitiveservices account create \
        --name "${openai_name}" \
        --resource-group "${resourceGroup}" \
        --kind "OpenAI" \
        --sku "S0" \
        --location "${region}" \
        --custom-domain "${openai_name}" \
        --yes
# Deploy gpt-4-1106-preview model to each resource and close filter 80       
  accountNames="isde-${region}-${subnum}"
#  az cognitiveservices account deployment create \
#  --name "${openai_name}" \
#  --resource-group "${resourceGroup}" \
#  --deployment-name "${deploymentNameGpt4}" \
#  --model-name gpt-4 \
#  --model-version "1106-Preview" \
#  --model-format OpenAI \
#  --sku-capacity "80" \
#  --sku-name "Standard"
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



#close content filter
export deploymentName="gpt-35-turbo"
export accessToken=$(az account get-access-token --resource https://management.core.windows.net -o json | jq -r .accessToken)
export accountNames=$(az cognitiveservices account list -g ${resourceGroup} -o json | jq '.[] | select(.kind == "OpenAI") | .name' | tr -d '"')

for accountName in $accountNames
do
  curl -X PUT "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.CognitiveServices/accounts/${accountName}/deployments/${deploymentName}?api-version=2023-05-01" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $accessToken" \
  -d '{
    "sku": {
      "name": "Standard",
      "capacity": 240
    },
    "properties": {
      "model": {
      "format": "OpenAI",
      "name": "gpt-35-turbo",
      "version": "0613"
      },
      "raiPolicyName":"Microsoft.Nil"
  }
  } '
done
export deploymentName="gpt-35-turbo-16k"
for accountName in $accountNames
do
  curl -X PUT https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.CognitiveServices/accounts/${accountName}/deployments/${deploymentName}?api-version=2023-05-01 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $accessToken" \
  -d '{
    "sku": {
      "name": "Standard",
      "capacity": 240
    },
    "properties": {
      "model": {
      "format": "OpenAI",
      "name": "gpt-35-turbo-16k",
      "version": "0613"
      },
      "raiPolicyName":"Microsoft.Nil"
  }
  } '
done

deploymentName="gpt-35-turbo"
openai_name="isde-westeurope-${subnum}"
  curl -X PUT "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.CognitiveServices/accounts/${openai_name}/deployments/${deploymentName}?api-version=2023-05-01" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $accessToken" \
  -d '{
    "sku": {
      "name": "Standard",
      "capacity": 240
    },
    "properties": {
      "model": {
      "format": "OpenAI",
      "name": "gpt-35-turbo",
      "version": "0301"
      },
      "raiPolicyName":"Microsoft.Nil"
  }
  } '
