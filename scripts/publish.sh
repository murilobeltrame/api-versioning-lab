#!/bin/bash

RESOURCE_GROUP=$1
SERVICE_NAME=$2
SWAGGER_DIR_PATH=$3

VERSION_SET_ID=
SPECIFICATION_FILES=$SWAGGER_DIR_PATH/*.swagger.json
for SWAGGER_FILE in $SPECIFICATION_FILES; do
    if [[ -f "$SWAGGER_FILE" ]]; then
        FILE_NAME=$(basename "$SWAGGER_FILE")
        API_NAME=$(cat $SWAGGER_FILE | jq -r '.info.title')
        API_PATH=$(echo "$FILE_NAME" | awk -F '.' '{print $1}')
        API_VERSION=$(echo "$FILE_NAME" | awk -F '.' '{print $2}')

        echo "API_NAME: $API_NAME"
        echo "API_PATH: $API_PATH"
        echo "API_VERSION: $API_VERSION"
        echo "File: $FILE_NAME"
        echo "---"

        VERSION_SETS=$(az apim api versionset list --resource-group $RESOURCE_GROUP --service-name $SERVICE_NAME)
        VERSION_SET_FOUND=$(echo "${VERSION_SETS[@]}" | jq -r '.[] | select(.displayName == "'"$API_NAME"'")')
        if [ -z "$VERSION_SET_FOUND" ]; then
            echo "There isnt VersionSet created for $API_NAME. Creating ..."
            VERSION_SET_ID=$(basename $(az apim api versionset create --display-name "$API_NAME" --resource-group $RESOURCE_GROUP --service-name $SERVICE_NAME --versioning-scheme "Segment" | jq -r '.id'))
        else 
            VERSION_SET_ID=$(basename $(echo "$VERSION_SET_FOUND" | jq -r '.id'))
            echo "Theres a VersionSet created. VersionSet ID is $VERSION_SET_ID."
        fi

        API_VERSIONS=$(az apim api list --resource-group $RESOURCE_GROUP --service-name $SERVICE_NAME)
        API_VERSION_FOUND=$(echo "${API_VERSIONS[@]}" | jq -r '.[] | select(.path == "'"$API_PATH"'" and .apiVersion == "'"$API_VERSION"'")')
        if [ -z "$API_VERSION_FOUND" ]; then
            echo "There isnt API Version created for $API_VERSION. Creating ..."
            az apim api import --path $API_PATH \
                --resource-group $RESOURCE_GROUP \
                --service-name $SERVICE_NAME \
                --specification-format "OpenApiJson" \
                --api-version $API_VERSION \
                --api-version-set-id $VERSION_SET_ID \
                --display-name "$API_NAME" \
                --specification-path $SWAGGER_FILE
        else
            API_VERSION_ID=$(basename $(echo "$API_VERSION_FOUND" | jq -r '.id'))
            echo "Theres a API Version created for $API_VERSION. Version ID is $API_VERSION_ID."
            az apim api import --path $API_PATH \
                --api-id $API_VERSION_ID \
                --resource-group $RESOURCE_GROUP \
                --service-name $SERVICE_NAME \
                --specification-format "OpenApiJson" \
                --api-version $API_VERSION \
                --api-version-set-id $VERSION_SET_ID \
                --display-name "$API_NAME" \
                --specification-path $SWAGGER_FILE
        fi
    fi
done
