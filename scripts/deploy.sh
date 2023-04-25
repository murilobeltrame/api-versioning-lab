RESOURCE_GROUP=rg-wittylobster

az containerapp up --name example-dotnet-api \
    --resource-group $RESOURCE_GROUP \
    --source ./src/Example.Api \
    --ingress external \
    --target-port 8080

az containerapp up --name example-dotnet-api-v3 \
    --resource-group $RESOURCE_GROUP \
    --source ./src/Example.Api.v3 \
    --ingress external \
    --target-port 8080