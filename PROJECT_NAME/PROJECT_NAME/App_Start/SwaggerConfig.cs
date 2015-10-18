using System.Web.Http;
using Swashbuckle.Application;

namespace PROJECT_NAME
{
    public class SwaggerConfig
    {
        public static void Register()
        {
            GlobalConfiguration.Configuration.EnableSwagger(c => { c.SingleApiVersion("v1", "PROJECT_NAME"); }).EnableSwaggerUi();
        }
    }
}