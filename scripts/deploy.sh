

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



RESOURCE_GROUP=rg-enoughtrout
SERVICE_NAME=apimenoughtrout
API_NAME=Test
VERSION_SET_ID=
VERSION_SETS=$(az apim api versionset list --resource-group $RESOURCE_GROUP --service-name $SERVICE_NAME)
VERSION_SET_FOUND=$(echo "${VERSION_SETS[@]}" | jq -r '.[] | select(.displayName == "'"$API_NAME"'")')
if [ -z "$VERSION_SET_FOUND" ]; then
    echo "There isnt VersionSet created for $API_NAME. Creating ... "
    VERSION_SET_ID=$(basename $(az apim api versionset create --display-name $API_NAME --resource-group $RESOURCE_GROUP --service-name $SERVICE_NAME --versioning-scheme "Segment" | jq -r '.id'))
else 
    VERSION_SET_ID=$(basename $(echo "$VERSION_SET_FOUND" | jq -r '.id'))
    echo "Theres a VersionSet created. VersionSet id $VERSION_SET_ID"
fi