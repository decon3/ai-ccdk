# [PROJECT NAME] - .NET Framework 4.7.2 AI Context

This file provides guidance to Claude Code (claude.ai/code) when working with this .NET Framework 4.7.2 project.

## 1. Project Overview
- **Vision:** [Describe your project's vision and goals]
- **Current Phase:** [Current development phase and status]
- **Key Architecture:** .NET Framework 4.7.2 application with [specify architecture pattern]
- **Development Strategy:** [Development approach and strategy notes]

## 2. Project Structure

**⚠️ CRITICAL: AI agents MUST read the [Project Structure documentation](/docs/ai-context/project-structure.md) before attempting any task to understand the complete technology stack, file tree and project organization.**

This .NET Framework 4.7.2 project follows traditional .NET Framework conventions and enterprise patterns. For the complete tech stack and file tree structure, see [docs/ai-context/project-structure.md](/docs/ai-context/project-structure.md).

## 3. .NET Framework 4.7.2 Coding Standards & AI Instructions

### General Instructions
- Follow Microsoft's .NET Framework coding conventions and naming guidelines
- Use defensive programming practices - validate inputs, handle exceptions properly
- Prefer composition over inheritance, favor interfaces for abstraction
- Write clean, self-documenting code with meaningful names
- Never commit secrets to git - use configuration files or environment variables
- Focus on Windows-specific deployment and enterprise integration patterns

### File Organization & Solution Structure
- Organize code into logical projects within the solution (.sln)
- Use meaningful folder structures (Controllers, Models, Services, etc.)
- Keep classes focused on single responsibilities
- Separate concerns: business logic, data access, presentation, services
- Use consistent namespace naming following project structure
- Place shared code in Common or Shared projects

### Project Types & Patterns
- **Web API Projects**: ASP.NET Web API 2 controllers with proper routing
- **Console Applications**: Traditional console apps with proper logging and error handling
- **Windows Services**: Background services using TopShelf or native Windows Service base
- **Class Libraries**: Shared business logic and data access layers
- **Unit Test Projects**: NUnit, MSTest, or xUnit with .NET Framework support

### Naming Conventions (Microsoft Standards)
- **Classes/Interfaces**: PascalCase (e.g., `CustomerService`, `IRepository`)
- **Methods/Properties**: PascalCase (e.g., `GetCustomerById`, `FirstName`)
- **Fields**: camelCase with underscore prefix for private (e.g., `_connectionString`)
- **Constants**: PascalCase (e.g., `MaxRetryAttempts`)
- **Parameters/Variables**: camelCase (e.g., `customerId`, `connectionString`)
- **Namespaces**: PascalCase following assembly structure (e.g., `MyCompany.MyProject.Services`)

### .NET Framework 4.7.2 Specific Features
- **C# 7.3**: Use latest language features available (pattern matching, tuples, ref locals)
- **Task-based Asynchronous Pattern**: async/await for I/O operations
- **Generic Collections**: Use generic collections from System.Collections.Generic
- **LINQ**: Leverage LINQ to Objects, LINQ to Entities for data queries
- **Nullable Reference Types**: Not available - use explicit null checks
- **Dependency Injection**: Use Autofac, Unity, or other DI containers

### Documentation Requirements
- Use XML documentation comments for all public APIs
- Include <summary>, <param>, <returns>, and <exception> tags
- Document complex business logic and architectural decisions
- Use clear, concise comments that explain "why" not "what"
- Include examples in documentation when helpful

### Error Handling & Logging
- Use specific exception types over generic Exception
- Implement proper exception handling with try-catch-finally blocks
- Use structured logging with NLog, Serilog, or log4net
- Log at appropriate levels (Debug, Info, Warn, Error, Fatal)
- Include context in log messages for debugging
- Never log sensitive information (passwords, API keys)

### Configuration Management
- Use app.config for console applications
- Use web.config for Web API applications
- Use ConfigurationManager for reading configuration
- Store connection strings in connectionStrings section
- Use appSettings for application-specific settings
- Consider configuration transformations for different environments

### Security Best Practices
- Validate all user inputs at API boundaries
- Use parameterized queries to prevent SQL injection
- Implement proper authentication and authorization
- Use HTTPS for all production web communications
- Store sensitive configuration in encrypted sections
- Implement proper session management for web applications
- Use strong typing for security-sensitive operations

### Performance & Memory Management
- Dispose of resources properly (using statements, IDisposable)
- Use async/await for I/O operations to avoid blocking threads
- Implement proper caching strategies (MemoryCache, Redis)
- Consider database query optimization and connection pooling
- Use StringBuilder for string concatenation in loops
- Avoid memory leaks in long-running services

### Web API Specific Patterns
- Use attribute routing for clean URL patterns
- Implement proper HTTP status codes and error responses
- Use model binding and validation attributes
- Implement proper CORS configuration
- Use dependency injection for service resolution
- Follow REST principles for API design

### Windows Service Patterns
- Use TopShelf for easy service development and deployment
- Implement proper service lifecycle management
- Use configuration files for service settings
- Implement health checks and monitoring
- Use structured logging for service diagnostics
- Handle service start/stop/pause operations gracefully

### Console Application Patterns
- Use proper command-line argument parsing
- Implement exit codes for automation scenarios
- Use structured logging with appropriate appenders
- Handle console cancellation (Ctrl+C) gracefully
- Provide help text and usage information
- Use dependency injection for testability

### Testing Standards
- Write unit tests for all business logic
- Use AAA pattern (Arrange, Act, Assert)
- Mock external dependencies using Moq or NSubstitute
- Write integration tests for API endpoints
- Use meaningful test names that describe behavior
- Achieve high code coverage (>80%) for critical paths

### Dependency Management
- Use NuGet Package Manager for external dependencies
- Pin package versions for reproducible builds
- Use packages.config or PackageReference format
- Keep packages updated for security patches
- Document any non-standard or internal packages
- Use binding redirects for version conflicts

### Database Integration
- Use Entity Framework 6.x for ORM scenarios
- Use ADO.NET for performance-critical database operations
- Implement proper connection string management
- Use transactions for data consistency
- Implement retry logic for transient failures
- Use async methods for database operations

### Deployment Considerations
- Build for x86, x64, or Any CPU as appropriate
- Use MSBuild for automated builds
- Implement proper configuration transformations
- Use Windows Installer (MSI) for desktop applications
- Deploy Web APIs to IIS with proper application pools
- Use Windows Service installer for services

## 4. Multi-Agent Workflows & Context Injection

### Automatic Context Injection for Sub-Agents
When using the Task tool to spawn sub-agents, the core project context (CLAUDE.md, project-structure.md, docs-overview.md) is automatically injected into their prompts via the subagent-context-injector hook. This ensures all sub-agents have immediate access to essential .NET Framework project documentation.

## 5. MCP Server Integrations

### Context7 Integration for .NET Framework
**When to use:**
- Working with .NET Framework libraries and NuGet packages
- Implementing .NET Framework-specific patterns
- Working with ASP.NET Web API 2 and Windows Services
- Database integration with Entity Framework 6.x
- Windows-specific development scenarios

**Usage patterns:**
```csharp
// Get current .NET Framework documentation
mcp__context7__resolve_library_id(libraryName=".net-framework")
mcp__context7__get_library_docs(
    context7CompatibleLibraryID="/microsoft/dotnet-framework",
    topic="web-api",
    tokens=8000
)
```

### Gemini Consultation for .NET Framework Architecture
**When to use:**
- Complex .NET Framework architecture decisions
- Legacy system integration patterns
- Windows Service implementation strategies
- Web API security and authentication
- Database design and Entity Framework optimization

## 6. Post-Task Completion Protocol

### .NET Framework 4.7.2 Specific Quality Checks
After completing any coding task:

1. **Build and Restore**
   ```bash
   nuget restore YourSolution.sln
   msbuild YourSolution.sln /p:Configuration=Release
   ```

2. **Code Analysis**
   ```bash
   # Visual Studio Code Analysis
   msbuild YourSolution.sln /p:RunAnalysis=true /p:TreatWarningsAsErrors=true
   
   # FxCop analysis (if available)
   FxCopCmd.exe /f:YourAssembly.dll /o:CodeAnalysisResults.xml
   ```

3. **Unit Testing**
   ```bash
   # NUnit
   nunit3-console.exe YourProject.Tests.dll
   
   # MSTest
   mstest.exe /testcontainer:YourProject.Tests.dll
   
   # xUnit
   xunit.console.exe YourProject.Tests.dll
   ```

4. **Security and Dependencies**
   ```bash
   # Check for vulnerable packages
   nuget audit
   
   # Verify package integrity
   nuget verify -signatures
   ```

### Verification Checklist
- [ ] Code follows .NET Framework conventions and naming standards
- [ ] All unit tests pass with appropriate coverage
- [ ] No security vulnerabilities in NuGet packages
- [ ] Proper exception handling and logging implemented
- [ ] Configuration management properly implemented
- [ ] Memory management and resource disposal handled
- [ ] Documentation updated for public APIs

## 7. .NET Framework 4.7.2 Development Patterns

### Web API Controller Pattern
```csharp
[RoutePrefix("api/customers")]
public class CustomersController : ApiController
{
    private readonly ICustomerService _customerService;

    public CustomersController(ICustomerService customerService)
    {
        _customerService = customerService ?? throw new ArgumentNullException(nameof(customerService));
    }

    [HttpGet]
    [Route("{id:int}")]
    public async Task<IHttpActionResult> GetCustomer(int id)
    {
        try
        {
            var customer = await _customerService.GetCustomerAsync(id);
            if (customer == null)
            {
                return NotFound();
            }
            return Ok(customer);
        }
        catch (Exception ex)
        {
            _logger.Error(ex, "Error retrieving customer {CustomerId}", id);
            return InternalServerError();
        }
    }

    [HttpPost]
    [Route("")]
    public async Task<IHttpActionResult> CreateCustomer([FromBody] CreateCustomerRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        try
        {
            var customer = await _customerService.CreateCustomerAsync(request);
            return CreatedAtRoute("GetCustomer", new { id = customer.Id }, customer);
        }
        catch (Exception ex)
        {
            _logger.Error(ex, "Error creating customer");
            return InternalServerError();
        }
    }
}
```

### Windows Service Pattern (TopShelf)
```csharp
public class MyWindowsService
{
    private readonly ILogger _logger;
    private readonly IServiceWorker _worker;
    private Timer _timer;

    public MyWindowsService(ILogger logger, IServiceWorker worker)
    {
        _logger = logger;
        _worker = worker;
    }

    public bool Start(HostControl hostControl)
    {
        _logger.Info("Service starting...");
        
        _timer = new Timer(DoWork, null, TimeSpan.Zero, TimeSpan.FromMinutes(5));
        
        _logger.Info("Service started successfully");
        return true;
    }

    public bool Stop(HostControl hostControl)
    {
        _logger.Info("Service stopping...");
        
        _timer?.Dispose();
        _worker?.Dispose();
        
        _logger.Info("Service stopped successfully");
        return true;
    }

    private void DoWork(object state)
    {
        try
        {
            _worker.ProcessWork();
        }
        catch (Exception ex)
        {
            _logger.Error(ex, "Error processing work");
        }
    }
}

// Program.cs
class Program
{
    static void Main(string[] args)
    {
        var container = ConfigureContainer();
        
        HostFactory.Run(x =>
        {
            x.Service<MyWindowsService>(s =>
            {
                s.ConstructUsing(name => container.Resolve<MyWindowsService>());
                s.WhenStarted((tc, hostControl) => tc.Start(hostControl));
                s.WhenStopped((tc, hostControl) => tc.Stop(hostControl));
            });
            
            x.RunAsLocalSystem();
            x.SetDescription("My Windows Service Description");
            x.SetDisplayName("My Windows Service");
            x.SetServiceName("MyWindowsService");
        });
    }
}
```

### Console Application Pattern
```csharp
class Program
{
    private static readonly ILogger Logger = LogManager.GetCurrentClassLogger();
    
    static async Task<int> Main(string[] args)
    {
        try
        {
            // Configure logging
            ConfigureLogging();
            
            // Configure dependency injection
            var container = ConfigureContainer();
            
            // Parse command line arguments
            var options = ParseArguments(args);
            if (options == null)
            {
                ShowUsage();
                return 1;
            }
            
            // Execute application logic
            var app = container.Resolve<IApplication>();
            await app.RunAsync(options);
            
            Logger.Info("Application completed successfully");
            return 0;
        }
        catch (Exception ex)
        {
            Logger.Fatal(ex, "Application failed with unhandled exception");
            return -1;
        }
    }
    
    private static void ConfigureLogging()
    {
        var config = new NLogLoggingConfiguration();
        config.AddRule(LogLevel.Info, LogLevel.Fatal, new ConsoleTarget());
        LogManager.Configuration = config;
    }
}
```

### Entity Framework 6.x Pattern
```csharp
public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext() : base("DefaultConnection")
    {
        Configuration.LazyLoadingEnabled = false;
        Configuration.ProxyCreationEnabled = false;
    }

    public DbSet<Customer> Customers { get; set; }
    public DbSet<Order> Orders { get; set; }

    protected override void OnModelCreating(DbModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Customer>()
            .HasKey(c => c.Id)
            .Property(c => c.Email)
            .IsRequired()
            .HasMaxLength(255);

        modelBuilder.Entity<Order>()
            .HasRequired(o => o.Customer)
            .WithMany(c => c.Orders)
            .HasForeignKey(o => o.CustomerId);
    }
}

public class CustomerRepository : ICustomerRepository
{
    private readonly ApplicationDbContext _context;

    public CustomerRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Customer> GetByIdAsync(int id)
    {
        return await _context.Customers
            .Include(c => c.Orders)
            .FirstOrDefaultAsync(c => c.Id == id);
    }

    public async Task<Customer> CreateAsync(Customer customer)
    {
        _context.Customers.Add(customer);
        await _context.SaveChangesAsync();
        return customer;
    }
}
```

### Dependency Injection Pattern (Autofac)
```csharp
public class AutofacConfig
{
    public static IContainer ConfigureContainer()
    {
        var builder = new ContainerBuilder();

        // Register services
        builder.RegisterType<CustomerService>()
            .As<ICustomerService>()
            .InstancePerRequest();

        builder.RegisterType<CustomerRepository>()
            .As<ICustomerRepository>()
            .InstancePerRequest();

        // Register DbContext
        builder.RegisterType<ApplicationDbContext>()
            .AsSelf()
            .InstancePerRequest();

        // Register controllers
        builder.RegisterAssemblyTypes(typeof(WebApiApplication).Assembly)
            .Where(t => t.Name.EndsWith("Controller"))
            .AsSelf()
            .InstancePerRequest();

        return builder.Build();
    }
}

// Global.asax.cs
public class WebApiApplication : System.Web.HttpApplication
{
    protected void Application_Start()
    {
        var container = AutofacConfig.ConfigureContainer();
        var config = GlobalConfiguration.Configuration;
        
        config.DependencyResolver = new AutofacWebApiDependencyResolver(container);
        
        WebApiConfig.Register(config);
    }
}
```

## 8. Common .NET Framework 4.7.2 Libraries

### Web Development
- **ASP.NET Web API 2**: RESTful web services
- **OWIN**: Open Web Interface for .NET
- **Microsoft.AspNet.WebApi.Owin**: OWIN integration
- **Microsoft.AspNet.Cors**: Cross-origin resource sharing

### Data Access
- **Entity Framework 6.x**: Object-relational mapping
- **Dapper**: Lightweight micro-ORM
- **ADO.NET**: Direct database access
- **System.Data.SqlClient**: SQL Server connectivity

### Dependency Injection
- **Autofac**: Mature IoC container
- **Unity**: Microsoft's dependency injection container
- **Ninject**: Lightweight dependency injection framework
- **Castle Windsor**: Feature-rich IoC container

### Logging
- **NLog**: Flexible logging framework
- **Serilog**: Structured logging
- **log4net**: Apache logging framework
- **Microsoft.Extensions.Logging**: Microsoft's logging abstraction

### Testing
- **NUnit**: Unit testing framework
- **MSTest**: Microsoft's testing framework
- **xUnit**: Modern testing framework
- **Moq**: Mocking framework for unit tests

### Utilities
- **Newtonsoft.Json**: JSON serialization
- **AutoMapper**: Object-to-object mapping
- **FluentValidation**: Validation library
- **Polly**: Resilience and transient-fault handling

## 9. Configuration Examples

### App.config (Console Application)
```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <configSections>
    <section name="nlog" type="NLog.Config.ConfigSectionHandler, NLog" />
  </configSections>

  <startup>
    <supportedRuntime version="v4.0" sku=".NETFramework,Version=v4.7.2" />
  </startup>

  <connectionStrings>
    <add name="DefaultConnection" 
         connectionString="Data Source=server;Initial Catalog=database;Integrated Security=true" 
         providerName="System.Data.SqlClient" />
  </connectionStrings>

  <appSettings>
    <add key="ApiBaseUrl" value="https://api.example.com" />
    <add key="ProcessingIntervalMinutes" value="5" />
    <add key="MaxRetryAttempts" value="3" />
  </appSettings>

  <nlog>
    <targets>
      <target name="console" xsi:type="Console" 
              layout="${longdate} ${level:uppercase=true} ${logger} ${message} ${exception:format=tostring}" />
      <target name="file" xsi:type="File" fileName="logs/app.log" 
              layout="${longdate} ${level:uppercase=true} ${logger} ${message} ${exception:format=tostring}" />
    </targets>
    <rules>
      <logger name="*" minlevel="Info" writeTo="console" />
      <logger name="*" minlevel="Debug" writeTo="file" />
    </rules>
  </nlog>
</configuration>
```

### Web.config (Web API)
```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <configSections>
    <section name="entityFramework" type="System.Data.Entity.Internal.ConfigFile.EntityFrameworkSection, EntityFramework" />
  </configSections>

  <connectionStrings>
    <add name="DefaultConnection" 
         connectionString="Data Source=server;Initial Catalog=database;Integrated Security=true" 
         providerName="System.Data.SqlClient" />
  </connectionStrings>

  <appSettings>
    <add key="webpages:Version" value="3.0.0.0" />
    <add key="webpages:Enabled" value="false" />
    <add key="ApiTitle" value="My API" />
    <add key="ApiVersion" value="1.0" />
  </appSettings>

  <system.web>
    <compilation debug="false" targetFramework="4.7.2" />
    <httpRuntime targetFramework="4.7.2" />
    <customErrors mode="RemoteOnly" />
  </system.web>

  <system.webServer>
    <handlers>
      <remove name="ExtensionlessUrlHandler-Integrated-4.0" />
      <add name="ExtensionlessUrlHandler-Integrated-4.0" path="*." verb="*" type="System.Web.Handlers.TransferRequestHandler" preCondition="integratedMode,runtimeVersionv4.0" />
    </handlers>
  </system.webServer>

  <entityFramework>
    <defaultConnectionFactory type="System.Data.Entity.Infrastructure.LocalDbConnectionFactory, EntityFramework">
      <parameters>
        <parameter value="mssqllocaldb" />
      </parameters>
    </defaultConnectionFactory>
    <providers>
      <provider invariantName="System.Data.SqlClient" type="System.Data.Entity.SqlServer.SqlProviderServices, EntityFramework.SqlServer" />
    </providers>
  </entityFramework>
</configuration>
```

---

*Last updated: [Date]*  
*Framework version: .NET Framework 4.7.2*  
*Target OS: Windows*