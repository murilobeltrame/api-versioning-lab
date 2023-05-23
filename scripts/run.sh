#!/bin/bash

# 1. export swaggerfiles
#   a. for netcore (apis-netcore.sh)
bash scripts/apis-netcore.sh "./src/netcore/Example.Api" "Example.Api.csproj" "$(pwd)/output" "api.yaml"
#   b. for spring (apis-spring.sh)
bash scripts/apis-spring.sh "./src/spring/example" "$(pwd)/output" "api.yaml"
#   c. for fastapi (apis-fastapi.sh)
bash scripts/apis-fastapi.sh "./src/fastapi" "$(pwd)/output" "api.yaml"

# 2. provision apim environment (environment.sh)

# 3. publish apis (publish.sh)

