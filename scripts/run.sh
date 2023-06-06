#!/bin/bash

OUTPUT_PATH="$(pwd)/output"

# 1. export swaggerfiles
#   a. for netcore (apis-netcore.sh)
bash scripts/apis-netcore.sh "./src/netcore/Example.Api" "Example.Api.csproj" $OUTPUT_PATH "api.yaml"
#   b. for spring (apis-spring.sh)
bash scripts/apis-spring.sh "./src/spring/example" $OUTPUT_PATH "api.yaml"
#   c. for fastapi (apis-fastapi.sh)
bash scripts/apis-fastapi.sh "./src/fastapi" $OUTPUT_PATH "api.yaml"

RESOURCE_GROUP=poc-rg
SERVICE_NAME=mbcpocapim

# 2. provision apim environment (environment.sh)
bash scripts/environment.sh $RESOURCE_GROUP $SERVICE_NAME

# 3. publish apis (publish.sh)
bash scipts/publish.sh $RESOURCE_GROUP $SERVICE_NAME $OUTPUT_PATH
