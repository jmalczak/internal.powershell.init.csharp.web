using System.Web.Http;

namespace PROJECT_NAME.Api
{
    public class HelloWorldController : ApiController
    {
        [HttpGet]
        public string Get()
        {
            return "Hello world";
        }
    }
}