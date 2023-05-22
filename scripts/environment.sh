RESOURCE_NAME=$1
SERVICE_NAME=$2

LOCATION=eastus

# CREATING RESOURCE GROUP
az group show --name $RESOURCE_NAME &>/dev/null

if [ $? -ne 0 ]; then
    az group create --name $RESOURCE_NAME --location $LOCATION
    echo "Resource Group $RESOURCE_NAME created"
else 
    echo "Resource Group $RESOURCE_NAME already exists"
fi

# CREATING APIM
az apim show --name $SERVICE_NAME --resource-group $RESOURCE_NAME &>/dev/null

if [ $? -ne 0 ]; then
    az apim create --name $SERVICE_NAME --resource-group $RESOURCE_NAME --location $LOCATION --publisher-email foo@bar.net --publisher-name "Foo Bar"
    echo "API Management instance created"
else
    echo "API Management instance already created"
fi
