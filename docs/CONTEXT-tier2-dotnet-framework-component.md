# [Component Name] - .NET Framework 4.7.2 Component Context

## Purpose
[Brief description of what this component does and why it exists]

## Current Status: [Active Development/Stable/Deprecated]
[Current development phase and any important status notes]

## Component-Specific .NET Framework Development Guidelines

### Project Type & Architecture
- **Project Type**: [Web API/Console Application/Windows Service/Class Library]
- **Target Framework**: .NET Framework 4.7.2
- **Architecture Pattern**: [Layered/N-Tier/Service-Oriented/Domain-Driven Design]
- **Deployment Model**: [IIS/Windows Service/Standalone Executable]

### Dependency Injection & IoC Container
- **Container**: [Autofac/Unity/Ninject/Castle Windsor]
- **Registration Pattern**: [Convention-based/Explicit registration]
- **Lifetime Management**: [Singleton/Transient/Scoped/PerRequest]
- **Service Location**: [Constructor injection preferred over service locator]

```csharp
// Autofac container configuration example
public class ComponentModule : Module
{
    protected override void Load(ContainerBuilder builder)
    {
        builder.RegisterType<CustomerService>()
            .As<ICustomerService>()
            .InstancePerLifetimeScope();

        builder.RegisterType<CustomerRepository>()
            .As<ICustomerRepository>()
            .InstancePerLifetimeScope();

        builder.RegisterType<ApplicationDbContext>()
            .AsSelf()
            .InstancePerLifetimeScope();
    }
}
```

### Configuration Management
- **Configuration Files**: [app.config/web.config]
- **Settings Storage**: [appSettings/connectionStrings/custom sections]
- **Environment Management**: [config transformations/multiple config files]
- **Secret Management**: [encrypted config sections/external key management]

```csharp
// Configuration access pattern
public class ComponentConfig
{
    public static string DatabaseConnection => 
        ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
    
    public static int MaxRetryAttempts => 
        int.Parse(ConfigurationManager.AppSettings["MaxRetryAttempts"] ?? "3");
    
    public static TimeSpan ProcessingInterval => 
        TimeSpan.Parse(ConfigurationManager.AppSettings["ProcessingInterval"] ?? "00:05:00");
}
```

### Data Access Patterns
- **ORM**: [Entity Framework 6.x/Dapper/ADO.NET]
- **Connection Management**: [Connection pooling/per-operation/shared context]
- **Transaction Handling**: [Automatic/explicit/distributed transactions]
- **Migration Strategy**: [Code First/Database First/Model First]

```csharp
// Entity Framework 6.x repository pattern
public class CustomerRepository : ICustomerRepository
{
    private readonly ApplicationDbContext _context;

    public CustomerRepository(ApplicationDbContext context)
    {
        _context = context ?? throw new ArgumentNullException(nameof(context));
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

    public async Task UpdateAsync(Customer customer)
    {
        _context.Entry(customer).State = EntityState.Modified;
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(int id)
    {
        var customer = await GetByIdAsync(id);
        if (customer != null)
        {
            _context.Customers.Remove(customer);
            await _context.SaveChangesAsync();
        }
    }
}
```

### Web API Specific Patterns (if applicable)
- **Routing**: [Attribute routing/Convention-based routing]
- **Model Binding**: [FromBody/FromUri/Custom model binders]
- **Validation**: [Data annotations/Fluent validation/Custom validation]
- **Error Handling**: [Global exception filters/HTTP error responses]

```csharp
// Web API controller pattern
[RoutePrefix("api/customers")]
public class CustomersController : ApiController
{
    private readonly ICustomerService _customerService;
    private readonly ILogger _logger;

    public CustomersController(ICustomerService customerService, ILogger logger)
    {
        _customerService = customerService ?? throw new ArgumentNullException(nameof(customerService));
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
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
        catch (ValidationException ex)
        {
            return BadRequest(ex.Message);
        }
        catch (Exception ex)
        {
            _logger.Error(ex, "Error creating customer");
            return InternalServerError();
        }
    }
}
```

### Windows Service Patterns (if applicable)
- **Service Framework**: [TopShelf/Native Windows Service/Hosted Service]
- **Service Lifecycle**: [Start/Stop/Pause/Continue operations]
- **Background Processing**: [Timer-based/Queue-based/Event-driven]
- **Service Communication**: [Named pipes/WCF/HTTP endpoints]

```csharp
// TopShelf Windows service pattern
public class OrderProcessingService
{
    private readonly IOrderProcessor _orderProcessor;
    private readonly ILogger _logger;
    private Timer _timer;

    public OrderProcessingService(IOrderProcessor orderProcessor, ILogger logger)
    {
        _orderProcessor = orderProcessor;
        _logger = logger;
    }

    public bool Start(HostControl hostControl)
    {
        _logger.Info("Order Processing Service starting...");
        
        var interval = TimeSpan.FromMinutes(ComponentConfig.ProcessingIntervalMinutes);
        _timer = new Timer(ProcessOrders, null, TimeSpan.Zero, interval);
        
        _logger.Info("Order Processing Service started successfully");
        return true;
    }

    public bool Stop(HostControl hostControl)
    {
        _logger.Info("Order Processing Service stopping...");
        
        _timer?.Dispose();
        _orderProcessor?.Dispose();
        
        _logger.Info("Order Processing Service stopped successfully");
        return true;
    }

    private async void ProcessOrders(object state)
    {
        try
        {
            await _orderProcessor.ProcessPendingOrdersAsync();
        }
        catch (Exception ex)
        {
            _logger.Error(ex, "Error processing orders");
        }
    }
}
```

### Error Handling & Logging
- **Logging Framework**: [NLog/Serilog/log4net]
- **Log Levels**: [Debug/Info/Warn/Error/Fatal]
- **Log Targets**: [File/Database/EventLog/Console]
- **Exception Handling**: [Global filters/Try-catch blocks/Custom exceptions]

```csharp
// Structured logging with NLog
public class CustomerService : ICustomerService
{
    private static readonly Logger Logger = LogManager.GetCurrentClassLogger();
    private readonly ICustomerRepository _repository;

    public CustomerService(ICustomerRepository repository)
    {
        _repository = repository;
    }

    public async Task<Customer> GetCustomerAsync(int id)
    {
        Logger.Debug("Retrieving customer {CustomerId}", id);
        
        try
        {
            var customer = await _repository.GetByIdAsync(id);
            if (customer == null)
            {
                Logger.Warn("Customer {CustomerId} not found", id);
                return null;
            }

            Logger.Info("Successfully retrieved customer {CustomerId}", id);
            return customer;
        }
        catch (Exception ex)
        {
            Logger.Error(ex, "Failed to retrieve customer {CustomerId}", id);
            throw;
        }
    }
}
```

## Major Subsystem Organization

### Core Business Logic
- **[Service Layer]**: [Description of business services and their responsibilities]
- **[Domain Models]**: [Entity classes and value objects]
- **[Business Rules]**: [Validation and business logic implementation]
- **[Workflow Management]**: [Process orchestration and state management]

### Data Access Layer
- **[Repository Pattern]**: [Data access abstraction and implementation]
- **[Entity Framework Context]**: [Database context and entity configurations]
- **[Migration Management]**: [Database schema versioning and updates]
- **[Connection Management]**: [Database connection pooling and lifecycle]

### Presentation Layer (Web API)
- **[Controllers]**: [API endpoint implementations]
- **[Model Binding]**: [Request/response model transformation]
- **[Authentication]**: [User authentication and authorization]
- **[Documentation]**: [API documentation and testing tools]

### Cross-Cutting Concerns
- **[Logging]**: [Application logging and monitoring]
- **[Caching]**: [Data caching and performance optimization]
- **[Security]**: [Authentication, authorization, and data protection]
- **[Configuration]**: [Application settings and environment management]

## Integration Points

### Internal Dependencies
- **[Core Services]**: [Dependencies on other internal services]
- **[Shared Libraries]**: [Common utilities and shared components]
- **[Data Layer]**: [Database and data access dependencies]

### External Dependencies
- **[Third-party APIs]**: [External service integrations]
- **[NuGet Packages]**: [External library dependencies]
- **[System Resources]**: [File system, network, hardware dependencies]

### Database Integration
- **Database Provider**: [SQL Server/Oracle/MySQL]
- **Connection String**: [Configuration location and format]
- **Schema Management**: [Migration strategy and versioning]
- **Performance**: [Indexing, query optimization, connection pooling]

### Message Queue Integration (if applicable)
- **Queue Technology**: [MSMQ/RabbitMQ/Azure Service Bus]
- **Message Patterns**: [Request-response/Publish-subscribe/Fire-and-forget]
- **Error Handling**: [Dead letter queues/Retry policies/Circuit breakers]

## Performance Characteristics

### Expected Performance Metrics
- **Throughput**: [Expected requests/operations per second]
- **Response Time**: [Average and 95th percentile response times]
- **Memory Usage**: [Expected memory footprint and growth patterns]
- **CPU Utilization**: [Expected CPU usage under normal and peak loads]

### Performance Monitoring
- **Performance Counters**: [Windows performance counters to monitor]
- **Application Metrics**: [Custom metrics and KPIs]
- **Health Checks**: [Health monitoring and availability checks]
- **Alerting**: [Performance threshold monitoring and notifications]

```csharp
// Performance counter example
public class PerformanceMetrics
{
    private readonly PerformanceCounter _requestsPerSecond;
    private readonly PerformanceCounter _averageRequestTime;

    public PerformanceMetrics()
    {
        _requestsPerSecond = new PerformanceCounter(
            "YourApplication", "Requests Per Second", false);
        _averageRequestTime = new PerformanceCounter(
            "YourApplication", "Average Request Time", false);
    }

    public void RecordRequest(TimeSpan duration)
    {
        _requestsPerSecond.Increment();
        _averageRequestTime.RawValue = (long)duration.TotalMilliseconds;
    }
}
```

### Caching Strategy
- **Cache Technology**: [MemoryCache/Redis/SQL Server]
- **Cache Patterns**: [Cache-aside/Write-through/Write-behind]
- **Expiration Policies**: [Time-based/Dependency-based/Manual invalidation]
- **Cache Keys**: [Naming conventions and key management]

```csharp
// MemoryCache implementation
public class CachedCustomerService : ICustomerService
{
    private readonly ICustomerService _innerService;
    private readonly MemoryCache _cache;
    private readonly TimeSpan _cacheExpiration = TimeSpan.FromMinutes(15);

    public CachedCustomerService(ICustomerService innerService)
    {
        _innerService = innerService;
        _cache = MemoryCache.Default;
    }

    public async Task<Customer> GetCustomerAsync(int id)
    {
        var cacheKey = $"customer:{id}";
        
        if (_cache.Get(cacheKey) is Customer cachedCustomer)
        {
            return cachedCustomer;
        }

        var customer = await _innerService.GetCustomerAsync(id);
        if (customer != null)
        {
            _cache.Set(cacheKey, customer, DateTimeOffset.UtcNow.Add(_cacheExpiration));
        }

        return customer;
    }
}
```

## Security Implementation

### Authentication & Authorization
- **Authentication Method**: [Windows Authentication/Forms Authentication/JWT/OAuth]
- **Authorization Strategy**: [Role-based/Claims-based/Resource-based]
- **Session Management**: [Session state/Token management/Single sign-on]

```csharp
// JWT authentication in Web API
[Authorize]
public class SecureController : ApiController
{
    protected string CurrentUserId => User.Identity.GetUserId();
    protected bool IsInRole(string role) => User.IsInRole(role);

    [HttpGet]
    [Authorize(Roles = "Admin,Manager")]
    public IHttpActionResult GetSecureData()
    {
        var userId = CurrentUserId;
        // Implementation
        return Ok();
    }
}
```

### Input Validation & Sanitization
- **Validation Framework**: [Data Annotations/FluentValidation]
- **Input Sanitization**: [HTML encoding/SQL parameter binding]
- **Business Rule Validation**: [Custom validation attributes/Service layer validation]

```csharp
// Model validation with data annotations
public class CreateCustomerRequest
{
    [Required(ErrorMessage = "First name is required")]
    [StringLength(50, ErrorMessage = "First name cannot exceed 50 characters")]
    public string FirstName { get; set; }

    [Required(ErrorMessage = "Email is required")]
    [EmailAddress(ErrorMessage = "Invalid email format")]
    public string Email { get; set; }

    [Phone(ErrorMessage = "Invalid phone number format")]
    public string PhoneNumber { get; set; }
}

// Custom validation attribute
public class ValidCustomerTypeAttribute : ValidationAttribute
{
    public override bool IsValid(object value)
    {
        if (value is string customerType)
        {
            return Enum.IsDefined(typeof(CustomerType), customerType);
        }
        return false;
    }
}
```

### Data Protection
- **Encryption**: [Data encryption at rest and in transit]
- **Connection Security**: [SSL/TLS for database connections]
- **Configuration Encryption**: [Encrypted configuration sections]
- **PII Handling**: [Personal data protection and compliance]

```xml
<!-- Encrypted connection strings in web.config -->
<connectionStrings configProtectionProvider="RsaProtectedConfigurationProvider">
  <EncryptedData Type="http://www.w3.org/2001/04/xmlenc#Element"
                 xmlns="http://www.w3.org/2001/04/xmlenc#">
    <CipherData>
      <CipherValue>...</CipherValue>
    </CipherData>
  </EncryptedData>
</connectionStrings>
```

## Testing Strategy

### Unit Testing Framework
- **Test Framework**: [NUnit/MSTest/xUnit]
- **Mocking Framework**: [Moq/NSubstitute/Rhino Mocks]
- **Test Organization**: [AAA pattern/BDD style/Test categories]
- **Code Coverage**: [Coverage targets and measurement tools]

```csharp
// Unit test example with NUnit and Moq
[TestFixture]
public class CustomerServiceTests
{
    private Mock<ICustomerRepository> _mockRepository;
    private Mock<ILogger> _mockLogger;
    private CustomerService _service;

    [SetUp]
    public void SetUp()
    {
        _mockRepository = new Mock<ICustomerRepository>();
        _mockLogger = new Mock<ILogger>();
        _service = new CustomerService(_mockRepository.Object, _mockLogger.Object);
    }

    [Test]
    public async Task GetCustomerAsync_ValidId_ReturnsCustomer()
    {
        // Arrange
        var customerId = 1;
        var expectedCustomer = new Customer { Id = customerId, FirstName = "John" };
        _mockRepository.Setup(r => r.GetByIdAsync(customerId))
                      .ReturnsAsync(expectedCustomer);

        // Act
        var result = await _service.GetCustomerAsync(customerId);

        // Assert
        Assert.That(result, Is.Not.Null);
        Assert.That(result.Id, Is.EqualTo(customerId));
        Assert.That(result.FirstName, Is.EqualTo("John"));
    }

    [Test]
    public async Task GetCustomerAsync_InvalidId_ReturnsNull()
    {
        // Arrange
        var customerId = 999;
        _mockRepository.Setup(r => r.GetByIdAsync(customerId))
                      .ReturnsAsync((Customer)null);

        // Act
        var result = await _service.GetCustomerAsync(customerId);

        // Assert
        Assert.That(result, Is.Null);
    }
}
```

### Integration Testing
- **Test Scope**: [Component integration/Database integration/API integration]
- **Test Data Management**: [Test database/Data seeding/Test fixtures]
- **Environment Setup**: [Test containers/Local database/Mock services]

```csharp
// Integration test example
[TestFixture]
[Category("Integration")]
public class CustomerRepositoryIntegrationTests
{
    private ApplicationDbContext _context;
    private CustomerRepository _repository;

    [OneTimeSetUp]
    public void OneTimeSetUp()
    {
        var connectionString = ConfigurationManager.ConnectionStrings["TestConnection"].ConnectionString;
        _context = new ApplicationDbContext(connectionString);
        _context.Database.CreateIfNotExists();
        _repository = new CustomerRepository(_context);
    }

    [SetUp]
    public void SetUp()
    {
        // Clean test data
        _context.Database.ExecuteSqlCommand("DELETE FROM Customers");
    }

    [Test]
    public async Task CreateAsync_ValidCustomer_SavesAndReturnsCustomer()
    {
        // Arrange
        var customer = new Customer 
        { 
            FirstName = "John", 
            LastName = "Doe", 
            Email = "john.doe@example.com" 
        };

        // Act
        var result = await _repository.CreateAsync(customer);

        // Assert
        Assert.That(result.Id, Is.GreaterThan(0));
        
        var savedCustomer = await _repository.GetByIdAsync(result.Id);
        Assert.That(savedCustomer, Is.Not.Null);
        Assert.That(savedCustomer.FirstName, Is.EqualTo("John"));
    }
}
```

## Deployment Configuration

### Build Configuration
- **Build Profiles**: [Debug/Release/Production configurations]
- **Compilation Settings**: [Target platform/Optimization/Debug symbols]
- **Output Settings**: [Output directory/Assembly naming/Version info]

```xml
<!-- Project file build configuration -->
<PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
  <DebugType>pdbonly</DebugType>
  <Optimize>true</Optimize>
  <OutputPath>bin\Release\</OutputPath>
  <DefineConstants>TRACE</DefineConstants>
  <ErrorReport>prompt</ErrorReport>
  <WarningLevel>4</WarningLevel>
  <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
</PropertyGroup>
```

### Deployment Strategy
- **Deployment Type**: [XCopy/MSI/ClickOnce/Web Deploy]
- **Environment Configuration**: [Config transformations/Environment variables]
- **Service Dependencies**: [Database/External services/Windows services]

### Configuration Management
- **Environment Settings**: [Development/Staging/Production configurations]
- **Connection Strings**: [Database connections per environment]
- **Feature Flags**: [Environment-specific feature toggles]

```xml
<!-- Web.Release.config transformation -->
<?xml version="1.0" encoding="utf-8"?>
<configuration xmlns:xdt="http://schemas.microsoft.com/XML-Document-Transform">
  <connectionStrings>
    <add name="DefaultConnection"
         connectionString="Production connection string"
         xdt:Transform="SetAttributes" xdt:Locator="Match(name)"/>
  </connectionStrings>
  
  <appSettings>
    <add key="Environment" value="Production" xdt:Transform="SetAttributes" xdt:Locator="Match(key)"/>
    <add key="LogLevel" value="Error" xdt:Transform="SetAttributes" xdt:Locator="Match(key)"/>
  </appSettings>
  
  <system.web>
    <compilation xdt:Transform="RemoveAttributes(debug)" />
    <customErrors mode="On" xdt:Transform="Replace"/>
  </system.web>
</configuration>
```

## Monitoring & Diagnostics

### Application Monitoring
- **Health Checks**: [Component health monitoring endpoints]
- **Performance Metrics**: [Response times/Throughput/Error rates]
- **Business Metrics**: [Feature usage/Business KPIs]

### Logging Configuration
- **Log Levels**: [Development vs Production logging levels]
- **Log Targets**: [Files/Database/Event logs/Remote logging]
- **Log Formatting**: [Structured vs Plain text logging]
- **Log Retention**: [Archival policies/Storage management]

```xml
<!-- NLog.config example -->
<?xml version="1.0" encoding="utf-8" ?>
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  
  <targets>
    <target xsi:type="File" name="fileTarget"
            fileName="logs/${shortdate}.log"
            layout="${longdate} ${uppercase:${level}} ${logger} ${message} ${exception:format=tostring}" />
    
    <target xsi:type="EventLog" name="eventLogTarget"
            source="YourApplication"
            layout="${message} ${exception:format=tostring}" />
  </targets>

  <rules>
    <logger name="*" minlevel="Info" writeTo="fileTarget" />
    <logger name="*" minlevel="Error" writeTo="eventLogTarget" />
  </rules>
</nlog>
```

## Troubleshooting Guide

### Common Issues
- **Performance Issues**: [Slow database queries/Memory leaks/High CPU usage]
- **Configuration Problems**: [Connection string issues/Missing settings/Environment mismatches]
- **Deployment Issues**: [Permission problems/Missing dependencies/Service startup failures]

### Diagnostic Tools
- **Event Viewer**: [Application and system event logs]
- **Performance Counters**: [.NET and custom performance counters]
- **SQL Profiler**: [Database query analysis and optimization]
- **Memory Dumps**: [Application crash analysis and debugging]

### Debug Information
- **Logging Levels**: [How to enable detailed logging for troubleshooting]
- **Configuration Validation**: [Verifying configuration settings and dependencies]
- **Network Connectivity**: [Testing external service connections and timeouts]

---

*Last updated: [Date]*
*Component version: [Version]*
*Framework version: .NET Framework 4.7.2*