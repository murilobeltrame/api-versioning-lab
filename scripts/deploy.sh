

# APIM_SETTINGS=$(cat apim-configuration.yaml | yq e -)
# # readarray APIM_DEFINITIONS < <(echo $APIM_SETTINGS | yq e -o=j -I=0 '.apimDefinitions.[]' -)
# readarray APIM_DEFINITIONS <<(echo "$APIM_SETTINGS" | yq e -o=j -I=0 '.apimDefinitions.[]' -)

# for APIM_DEFINITION in "$APIM_DEFINITIONS[@]"; do
#     echo $("$APIM_DEFINITION" | yq -e '.suffix')
# done

# for f in src/swagger*.json
# do
#     # echo "$f"
#     API_NAME=$(cat $f|jq -r '.info.title')
#     API_VERSION=$(cat $f|jq -r '.info.version')
#     echo "$API_NAME $API_VERSION"
# done



RESOURCE_GROUP=rg-wittylobster
SERVICE_NAME=apimwittylobster

SPECIFICATION_FILES=src/swagger*.json
API_NAME="Example" #$(cat $(ls $SPECIFICATION_FILES | head -n 1) | jq -r '.info.title')
API_PATH="example"
VERSION_SET_ID=

echo "Creating $API_NAME Api ..."

VERSION_SETS=$(az apim api versionset list --resource-group $RESOURCE_GROUP --service-name $SERVICE_NAME)
VERSION_SET_FOUND=$(echo "${VERSION_SETS[@]}" | jq -r '.[] | select(.displayName == "'"$API_NAME"'")')
if [ -z "$VERSION_SET_FOUND" ]; then
    echo "There isnt VersionSet created for $API_NAME. Creating ..."
    VERSION_SET_ID=$(basename $(az apim api versionset create --display-name $API_NAME --resource-group $RESOURCE_GROUP --service-name $SERVICE_NAME --versioning-scheme "Segment" | jq -r '.id'))
else 
    VERSION_SET_ID=$(basename $(echo "$VERSION_SET_FOUND" | jq -r '.id'))
    echo "Theres a VersionSet created. VersionSet ID is $VERSION_SET_ID."
fi

for FILE in $SPECIFICATION_FILES
do
    API_VERSION=$(cat $FILE | jq -r '.info.version')
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
            --display-name $API_NAME \
            --specification-path $FILE
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
            --display-name $API_NAME \
            --specification-path $FILE
    fi

done