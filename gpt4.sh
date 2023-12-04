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
export regions=(AustraliaEast CanadaEast EastUS EastUS2 FranceCentral JapanEast NorthCentralUS SwedenCentral SwitzerlandNorth UKSouth westeurope)
# Create resource group
export resourceGroup="openai" # Your resource group name
az group create --name "${resourceGroup}" --location "eastus"



export deploymentName="gpt-35-turbo"
export deploymentName16k="gpt-35-turbo-16k"
export deploymentNameGpt4="gpt-4"
export deploymentNameGpt432k="gpt-4-32k"


#deploy GPT4
export regions=(CanadaEast SwedenCentral SwitzerlandNorth AustraliaEast)

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

#1106
# 4-1106
# Deploy gpt-4-1106 model to each resource : 150K
export regions=(southIndia NORWAYEAST)
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
 az cognitiveservices account deployment create \
 --name "${openai_name}" \
 --resource-group "${resourceGroup}" \
 --deployment-name "${deploymentNameGpt4}" \
 --model-name gpt-4 \
 --model-version "1106-Preview" \
 --model-format OpenAI \
 --sku-capacity "150" \
 --sku-name "Standard"
Deploy gpt-4-1106-preview model to each resource and close filter 150K      
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

export subs=$1
for sub in "${subs[@]}"
do
    echo "Subscription ID: ${sub}"
    az account set --subscription ${sub}

    export resourceGroup="openai" 

    # 获取订阅下的所有认知服务帐户
    accounts=$(az cognitiveservices account list --subscription ${sub} --resource-group ${resourceGroup} -o json)

    # 遍历每个帐户并提取API密钥和部署ID
    for account in $(echo $accounts | jq -r '.[] | @base64'); do
        account_name=$(echo $account | base64 --decode | jq -r '.name')
        resource_group=$(echo $account | base64 --decode | jq -r '.resourceGroup')
        api_key1=$(az cognitiveservices account keys list --name $account_name --resource-group $resourceGroup --subscription $sub --query 'key1' -o tsv)
        api_key2=$(az cognitiveservices account keys list --name $account_name --resource-group $resourceGroup --subscription $sub --query 'key2' -o tsv)
        location=$(az cognitiveservices account show --name $account_name --resource-group $resourceGroup --subscription $sub --query 'location' -o tsv)
        endpoint=$(az cognitiveservices account show --name $account_name --resource-group $resourceGroup --subscription $sub --query 'properties.endpoint' -o tsv)

        echo "$sub,$account_name,$api_key1,$api_key2,$endpoint,$location"
            
        # append to csv
        echo "$sub,$account_name,$api_key1,$api_key2,$endpoint,$location" >> openai_accounts.csv
        
    done
done
