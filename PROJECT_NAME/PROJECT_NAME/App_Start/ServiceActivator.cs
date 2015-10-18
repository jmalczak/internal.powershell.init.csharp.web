using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Web;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Dispatcher;

using StructureMap;
using WebConfigSvc.Services.Interfaces;
using WebConfigSvc.Services;
using Aws53Svc.Services;
using Aws53Svc.Services.Interfaces;
using SharpRaven;

namespace WebConfigSvc.App_Start
{
    public class ServiceActivator : IHttpControllerActivator
    {
        public ServiceActivator(HttpConfiguration configuration) { }

        public IHttpController Create(HttpRequestMessage request
            , HttpControllerDescriptor controllerDescriptor, Type controllerType)
        {
            var controller = ObjectFactory.Container.GetInstance(controllerType) as IHttpController;
            return controller;
        }


    }
    public static class ObjectFactory
    {
        private static readonly Lazy<StructureMap.Container> _containerBuilder =
                new Lazy<StructureMap.Container>(DefaultContainer, LazyThreadSafetyMode.ExecutionAndPublication);

        public static StructureMap.IContainer Container
        {
            get { return _containerBuilder.Value; }
        }

        private static StructureMap.Container DefaultContainer()
        {
            var dns = ConfigurationManager.AppSettings["revenDns"];           

            IRavenClient revenClient = new RavenClient(new Dsn(dns));
            return new StructureMap.Container(x =>
            {
                x.For<IDNSService>().Add<DNSService>();
                x.For<I_IISService>().Add<IISService>();
                x.For<IRavenClient>().Add(revenClient);
            });
        }
    }
}