if [ -z "$1" ]
   then
     echo "No argument supplied"
     exit 1
fi
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
