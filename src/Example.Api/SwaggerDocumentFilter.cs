using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace Example.Api
{
    public class SwaggerDocumentFilter : IDocumentFilter
    {
        public void Apply(OpenApiDocument swaggerDoc, DocumentFilterContext context)
        {
            var version = swaggerDoc.Paths.First().Key.Split("/").First(s => !string.IsNullOrWhiteSpace(s)).ToLowerInvariant();
            swaggerDoc.Servers.Add(new OpenApiServer { Url = "/" + version });

            var dictionaryPath = swaggerDoc
                .Paths
                .ToDictionary(x => "/" + x.Key.Split("/").Last().ToLowerInvariant(), x => x.Value);
            var newPaths = new OpenApiPaths();
            foreach (var path in dictionaryPath)
            {
                newPaths.Add(path.Key, path.Value);
            }
            swaggerDoc.Paths = newPaths;
        }
    }
}
