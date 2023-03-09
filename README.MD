# API and API Management version management

This repo shows how to publish multiple Rest API versions on Azure API Management using generated Open Api documentation files.

## Build

To build and generated documentation files:
```sh
./script/build
```

## Deploy

To deploy Azure API Management and publish APIs
```sh
cd environment
terraform init
terraform apply
```
