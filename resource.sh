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
export regions=(AustraliaEast CanadaEast EastUS EastUS2 FranceCentral JapanEast NorthCentralUS SwedenCentral SwitzerlandNorth UKSouth WestEurope NORWAYEAST SouthIndia)
# Create resource group
export resourceGroup="openai" # Your resource group name
az group create --name "${resourceGroup}" --location "eastus"
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

done

az account set --subscription ${subscriptionId}
export resourceGroup="openai" 

# 获取订阅下的所有认知服务帐户
accounts=$(az cognitiveservices account list --subscription ${subscriptionId} --resource-group ${resourceGroup} -o json)

# 遍历每个帐户并提取API密钥和部署ID
for account in $(echo $accounts | jq -r '.[] | @base64'); do
  account_name=$(echo $account | base64 --decode | jq -r '.name')
  resource_group=$(echo $account | base64 --decode | jq -r '.resourceGroup')
  api_key1=$(az cognitiveservices account keys list --name $account_name --resource-group $resourceGroup --subscription ${subscriptionId} --query 'key1' -o tsv)
  api_key2=$(az cognitiveservices account keys list --name $account_name --resource-group $resourceGroup --subscription ${subscriptionId} --query 'key2' -o tsv)
  location=$(az cognitiveservices account show --name $account_name --resource-group $resourceGroup --subscription ${subscriptionId} --query 'location' -o tsv)
  endpoint=$(az cognitiveservices account show --name $account_name --resource-group $resourceGroup --subscription ${subscriptionId} --query 'properties.endpoint' -o tsv)
  echo "${subscriptionId},$account_name,$api_key1,$api_key2,$endpoint,$location"
            
  # append to csv
  echo "${subscriptionId},$account_name,$api_key1,$api_key2,$endpoint,$location" >> openai_accounts.csv
done
