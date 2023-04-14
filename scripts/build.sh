cd src
dotnet tool restore

dotnet build
dotnet publish Example.Api --output publish
dotnet publish Example.Api.v3 --output publish


dotnet tool run swagger tofile --output swagger.v1.json publish/Example.Api.dll v1
dotnet tool run swagger tofile --output swagger.v2.json publish/Example.Api.dll v2
dotnet tool run swagger tofile --output swagger.v3.json publish/Example.Api.v3.dll v1