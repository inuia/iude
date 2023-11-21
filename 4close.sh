#!/bin/bash

if [ -z "$1" ]
   then
     echo "No argument supplied"
     exit 1
fi

export subscriptionId=$1

export resourceGroup="openai"
export deploymentName="gpt-35-turbo"
export accessToken=$(az account get-access-token --resource https://management.core.windows.net -o json | jq -r .accessToken)
export accountNames=$(az cognitiveservices account list -g ${resourceGroup} -o json | jq '.[] | select(.kind == "OpenAI") | .name' | tr -d '"')


export deploymentName="gpt-4"
for accountName in $accountNames
do
  curl -X PUT https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.CognitiveServices/accounts/${accountName}/deployments/${deploymentName}?api-version=2023-05-01 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $accessToken" \
  -d '{
    "properties": {
      "model": {
      "format": "OpenAI",
      "name": "gpt-4",
      "version": "0613"
      },
      "raiPolicyName":"Microsoft.Nil"
  }
  } '
done
for accountName in $accountNames
do
  curl -X PUT https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.CognitiveServices/accounts/${accountName}/deployments/${deploymentName}?api-version=2023-05-01 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $accessToken" \
  -d '{
    "properties": {
      "model": {
      "format": "OpenAI",
      "name": "gpt-4",
      "version": "0613"
      },
      "raiPolicyName":"Microsoft.Nil"
  }
  } '
done
export deploymentName="gpt-4-32k"
for accountName in $accountNames
do
  curl -X PUT https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.CognitiveServices/accounts/${accountName}/deployments/${deploymentName}?api-version=2023-05-01 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $accessToken" \
  -d '{
    "properties": {
      "model": {
      "format": "OpenAI",
      "name": "gpt-4-32k",
      "version": "0613"
      },
      "raiPolicyName":"Microsoft.Nil"
  }
  } '
done
for accountName in $accountNames
do
  curl -X PUT https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.CognitiveServices/accounts/${accountName}/deployments/${deploymentName}?api-version=2023-05-01 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $accessToken" \
  -d '{
    "properties": {
      "model": {
      "format": "OpenAI",
      "name": "gpt-4-32k",
      "version": "0613"
      },
      "raiPolicyName":"Microsoft.Nil"
  }
  } '
done
