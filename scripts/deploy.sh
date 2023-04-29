RESOURCE_GROUP=xpto
DOCKER_NAMESPACE=murilobeltrame

az containerapp up \
    --name example-dotnet-api \
    --resource-group $RESOURCE_GROUP \
    --source ./src/Example.Api \
    --ingress external \
    --target-port 8080

az containerapp up \
    --name example-dotnet-api-v3 \
    --resource-group $RESOURCE_GROUP \
    --source ./src/Example.Api.v3 \
    --ingress external \
    --target-port 8080

docker build \
    --platform linux/amd64 \
    --file src/spring/example/Dockerfile \
    --tag $DOCKER_NAMESPACE/spring-test \
    src/spring/example/
docker push $DOCKER_NAMESPACE/spring-test
az containerapp up \
    --name example-spring-api \
    --resource-group $RESOURCE_GROUP \
    --image docker.io/murilobeltrame/spring-test \
    --ingress external \
    --target-port 8080