#!/bin/bash

PROJECT_FOLDER=$1
PROJECT_FILE_NAME=$2
OUTPUT_DIR_PATH=$3
API_CONFIGURATION_FILE=$4

CURRENT_FOLDER=$(pwd)
PROJECT_NAME=$(basename $PROJECT_FILE_NAME .csproj)

cd $PROJECT_FOLDER

dotnet publish --output $OUTPUT_DIR_PATH

API_NAME=$(yq eval '.api.name' "$API_CONFIGURATION_FILE")
API_PATH=$(yq eval '.api.path' "$API_CONFIGURATION_FILE")
API_VERSIONS_NO=$(yq eval '.api.versions | length' "$API_CONFIGURATION_FILE")

for ((i=0; i<API_VERSIONS_NO; i++)); do
    API_VERSION_NAME=$(yq eval ".api.versions[$i].name" "$API_CONFIGURATION_FILE")
    API_VERSION_BACKEND=$(yq eval ".api.versions[$i].backend" "$API_CONFIGURATION_FILE")

    JSON_PATH=$OUTPUT_DIR_PATH/$API_PATH.$API_VERSION_NAME.swagger.json
    dotnet tool run swagger tofile --output $JSON_PATH $OUTPUT_DIR_PATH/$PROJECT_NAME.dll $API_VERSION_NAME

    # Update the title using jq
    jq --arg new_title "$API_NAME" '.info.title = $new_title' "$JSON_PATH" > tmp.json && mv tmp.json "$JSON_PATH"

    # Check if servers array exists and set/replace servers[0].url
    jq --arg new_url "$API_VERSION_BACKEND" 'if has("servers") then .servers[0].url = $new_url else . + {servers: [{"url": $new_url}]} end' "$JSON_PATH" > tmp.json && mv tmp.json "$JSON_PATH"

done

cd $CURRENT_FOLDER