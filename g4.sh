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
export regions=(australiaeast canadaeast  swedencentral)
# export regions=(australiaeast)
# export regions=(CanadaEast SwedenCentral AustraliaEast)

export resourceGroup="openai" # Your resource group name
export deploymentName="gpt-35-turbo"
export deploymentName16k="gpt-35-turbo-16k"
export deploymentNameGpt4="gpt-4"
export deploymentNameGpt432k="gpt-4-32k"
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
Deploy gpt-4 model to each resource
az cognitiveservices account deployment create \
--name "${openai_name}" \
--resource-group "${resourceGroup}" \
--deployment-name "${deploymentNameGpt4}" \
--model-name gpt-4 \
--model-version "0613" \
--model-format OpenAI \
--sku-capacity "40" \
--sku-name "Standard"

done
