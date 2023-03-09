dotnet build .\src\Example.sln

dotnet publish .\src\Example.Api --output publish
dotnet publish .\src\Example.Api.v3 --output publish

cd src
dotnet tool run swagger tofile --output ..\swagger.v1.json ..\publish\Example.Api.dll v1
dotnet tool run swagger tofile --output ..\swagger.v2.json ..\publish\Example.Api.dll v2
dotnet tool run swagger tofile --output ..\swagger.v3.json ..\publish\Example.Api.v3.dll v1