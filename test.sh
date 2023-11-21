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
Deploy GPT-35-Turbo-16k model to each resource
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


#deploy GPT4
export regions=(CanadaEast SwedenCentral SwitzerlandNorth)
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

# 4
# Deploy gpt-4 model to each resource
az cognitiveservices account deployment create \
--name "${openai_name}" \
--resource-group "${resourceGroup}" \
--deployment-name "${deploymentNameGpt4}" \
--model-name gpt-4 \
--model-version "0613" \
--model-format OpenAI \
--sku-capacity "40" \
--sku-name "Standard"

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
for region in "${regions[@]}"
do
echo "Creating resource in ${region}..."

openai_name="isde-${region}-${subnum}"
done

az cognitiveservices account deployment create \
--name "${openai_name}" \
--resource-group "${resourceGroup}" \
--deployment-name "${deploymentNameGpt432k}" \
--model-name gpt-4-32k \
--model-version "0613" \
--model-format OpenAI \
--sku-capacity "60" \
--sku-name "Standard"

az cognitiveservices account deployment create \
--name "${openai_name}" \
--resource-group "${resourceGroup}" \
--deployment-name "${deploymentNameGpt4}" \
--model-name gpt-4 \
--model-version "0613" \
--model-format OpenAI \
--sku-capacity "20" \
--sku-name "Standard"
