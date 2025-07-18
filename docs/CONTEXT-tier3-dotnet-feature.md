# [Feature Area] - .NET Core 8 Feature Documentation

*This file documents the [Feature Area] implementation patterns and technical details within the .NET Core 8 application.*

## Feature Architecture

### Core Implementation
- **Feature Type**: [Web API, Background Service, Web UI, Integration Service]
- **Primary Framework**: [ASP.NET Core Web API, MVC, Razor Pages, Worker Service]
- **Data Access**: [Entity Framework Core, Dapper, Raw SQL]
- **Authentication**: [JWT Bearer, Cookie, Identity, External OAuth]

### Technology Integration
- **Dependency Injection**: [Service registration patterns and lifetimes]
- **Configuration**: [IOptions, IConfiguration binding patterns]
- **Logging**: [ILogger implementation and structured logging]
- **Validation**: [FluentValidation, DataAnnotations, custom validators]

### Performance Characteristics
- **Caching Strategy**: [Memory caching, distributed caching, response caching]
- **Database Strategy**: [Read/write patterns, query optimization]
- **Async Patterns**: [Task-based async, cancellation token usage]

## Implementation Patterns

### Service Layer Pattern
```csharp
// Example service implementation
public class CustomerService : ICustomerService
{
    private readonly ICustomerRepository _repository;
    private readonly ILogger<CustomerService> _logger;
    private readonly IMapper _mapper;
    
    public CustomerService(
        ICustomerRepository repository,
        ILogger<CustomerService> logger,
        IMapper mapper)
    {
        _repository = repository;
        _logger = logger;
        _mapper = mapper;
    }
    
    public async Task<CustomerDto> GetCustomerAsync(int id, CancellationToken cancellationToken)
    {
        // Implementation with proper error handling and logging
    }
}
```

### Controller Pattern
```csharp
// Example controller implementation
[ApiController]
[Route("api/[controller]")]
public class CustomersController : ControllerBase
{
    private readonly ICustomerService _customerService;
    
    public CustomersController(ICustomerService customerService)
    {
        _customerService = customerService;
    }
    
    [HttpGet("{id}")]
    public async Task<ActionResult<CustomerDto>> GetCustomer(int id, CancellationToken cancellationToken)
    {
        // Implementation with proper HTTP status codes and error handling
    }
}
```

### Repository Pattern
```csharp
// Example repository implementation
public class CustomerRepository : ICustomerRepository
{
    private readonly ApplicationDbContext _context;
    
    public CustomerRepository(ApplicationDbContext context)
    {
        _context = context;
    }
    
    public async Task<Customer?> GetByIdAsync(int id, CancellationToken cancellationToken)
    {
        return await _context.Customers
            .AsNoTracking()
            .FirstOrDefaultAsync(c => c.Id == id, cancellationToken);
    }
}
```

## Key Files and Structure

### Primary Implementation Files
```
[FeatureArea]/
├── Controllers/
│   ├── [Feature]Controller.cs          # API endpoints
│   └── [Feature]AdminController.cs     # Admin endpoints
├── Services/
│   ├── I[Feature]Service.cs            # Service interface
│   ├── [Feature]Service.cs             # Service implementation
│   └── [Feature]BackgroundService.cs  # Background processing
├── Models/
│   ├── [Feature]Entity.cs              # Domain entity
│   ├── [Feature]Dto.cs                 # Data transfer object
│   ├── Create[Feature]Request.cs       # API request models
│   └── [Feature]Response.cs            # API response models
├── Repositories/
│   ├── I[Feature]Repository.cs         # Repository interface
│   └── [Feature]Repository.cs          # Repository implementation
├── Validators/
│   ├── Create[Feature]Validator.cs     # Request validators
│   └── Update[Feature]Validator.cs     # Update validators
├── Extensions/
│   ├── [Feature]ServiceCollectionExtensions.cs  # DI registration
│   └── [Feature]Extensions.cs         # Helper extensions
├── Configuration/
│   ├── [Feature]EntityConfiguration.cs # EF Core configuration
│   └── [Feature]Options.cs            # Configuration options
└── CONTEXT.md                          # This documentation file
```

### Database Schema Files
- **Migrations**: [Migration files for feature-specific schema changes]
- **Configurations**: [EF Core entity configurations]
- **Seed Data**: [Initial data setup for the feature]

## Integration Points

### Database Integration
```csharp
// Entity Framework configuration
public class CustomerEntityConfiguration : IEntityTypeConfiguration<Customer>
{
    public void Configure(EntityTypeBuilder<Customer> builder)
    {
        builder.HasKey(c => c.Id);
        builder.Property(c => c.Name).IsRequired().HasMaxLength(100);
        builder.Property(c => c.Email).IsRequired().HasMaxLength(255);
        builder.HasIndex(c => c.Email).IsUnique();
    }
}
```

### External API Integration
```csharp
// HTTP client integration
public class ExternalApiService : IExternalApiService
{
    private readonly HttpClient _httpClient;
    private readonly IOptions<ExternalApiOptions> _options;
    
    public ExternalApiService(HttpClient httpClient, IOptions<ExternalApiOptions> options)
    {
        _httpClient = httpClient;
        _options = options;
    }
    
    public async Task<ExternalApiResponse> GetDataAsync(string id, CancellationToken cancellationToken)
    {
        // Implementation with proper error handling and retry logic
    }
}
```

### Message Queue Integration
```csharp
// Service Bus or other message queue integration
public class MessageProcessor : IMessageProcessor
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<MessageProcessor> _logger;
    
    public async Task ProcessMessageAsync(Message message, CancellationToken cancellationToken)
    {
        using var scope = _serviceProvider.CreateScope();
        var service = scope.ServiceProvider.GetRequiredService<IProcessingService>();
        
        // Process message with proper error handling
    }
}
```

## Error Handling Strategy

### Exception Handling
```csharp
// Custom exception types
public class CustomerNotFoundException : Exception
{
    public CustomerNotFoundException(int customerId) 
        : base($"Customer with ID {customerId} was not found")
    {
        CustomerId = customerId;
    }
    
    public int CustomerId { get; }
}

// Global exception handler
public class GlobalExceptionHandler : IExceptionHandler
{
    private readonly ILogger<GlobalExceptionHandler> _logger;
    
    public async ValueTask<bool> TryHandleAsync(
        HttpContext httpContext, 
        Exception exception, 
        CancellationToken cancellationToken)
    {
        // Handle different exception types and return appropriate responses
    }
}
```

### Validation Patterns
```csharp
// FluentValidation example
public class CreateCustomerValidator : AbstractValidator<CreateCustomerRequest>
{
    public CreateCustomerValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty()
            .MaximumLength(100);
            
        RuleFor(x => x.Email)
            .NotEmpty()
            .EmailAddress()
            .MaximumLength(255);
    }
}
```

## Development Patterns

### Dependency Injection Registration
```csharp
// Service registration in Program.cs or extension method
public static IServiceCollection Add[Feature]Services(this IServiceCollection services, IConfiguration configuration)
{
    services.Configure<[Feature]Options>(configuration.GetSection("[Feature]"));
    
    services.AddScoped<I[Feature]Service, [Feature]Service>();
    services.AddScoped<I[Feature]Repository, [Feature]Repository>();
    services.AddScoped<IValidator<Create[Feature]Request>, Create[Feature]Validator>();
    
    services.AddHttpClient<IExternalApiService, ExternalApiService>(client =>
    {
        client.BaseAddress = new Uri(configuration["ExternalApi:BaseUrl"]);
    });
    
    return services;
}
```

### Configuration Management
```csharp
// Configuration options
public class CustomerOptions
{
    public const string SectionName = "Customer";
    
    public int MaxSearchResults { get; set; } = 100;
    public TimeSpan CacheExpiration { get; set; } = TimeSpan.FromMinutes(5);
    public bool EnableBackgroundProcessing { get; set; } = true;
}
```

### Background Processing
```csharp
// Background service implementation
public class CustomerBackgroundService : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<CustomerBackgroundService> _logger;
    
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            using var scope = _serviceProvider.CreateScope();
            var service = scope.ServiceProvider.GetRequiredService<ICustomerService>();
            
            // Background processing logic
            
            await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);
        }
    }
}
```

## Testing Patterns

### Unit Testing
```csharp
// Example unit test
public class CustomerServiceTests
{
    private readonly Mock<ICustomerRepository> _mockRepository;
    private readonly Mock<ILogger<CustomerService>> _mockLogger;
    private readonly Mock<IMapper> _mockMapper;
    private readonly CustomerService _service;
    
    public CustomerServiceTests()
    {
        _mockRepository = new Mock<ICustomerRepository>();
        _mockLogger = new Mock<ILogger<CustomerService>>();
        _mockMapper = new Mock<IMapper>();
        _service = new CustomerService(_mockRepository.Object, _mockLogger.Object, _mockMapper.Object);
    }
    
    [Fact]
    public async Task GetCustomerAsync_ExistingCustomer_ReturnsCustomerDto()
    {
        // Arrange
        var customerId = 1;
        var customer = new Customer { Id = customerId, Name = "John Doe" };
        var customerDto = new CustomerDto { Id = customerId, Name = "John Doe" };
        
        _mockRepository.Setup(r => r.GetByIdAsync(customerId, It.IsAny<CancellationToken>()))
            .ReturnsAsync(customer);
        _mockMapper.Setup(m => m.Map<CustomerDto>(customer))
            .Returns(customerDto);
        
        // Act
        var result = await _service.GetCustomerAsync(customerId, CancellationToken.None);
        
        // Assert
        Assert.NotNull(result);
        Assert.Equal(customerId, result.Id);
        Assert.Equal("John Doe", result.Name);
    }
}
```

### Integration Testing
```csharp
// Example integration test
public class CustomerControllerTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;
    
    public CustomerControllerTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
    }
    
    [Fact]
    public async Task GetCustomer_ExistingCustomer_ReturnsOk()
    {
        // Arrange
        var customerId = 1;
        
        // Act
        var response = await _client.GetAsync($"/api/customers/{customerId}");
        
        // Assert
        response.EnsureSuccessStatusCode();
        var content = await response.Content.ReadAsStringAsync();
        var customer = JsonSerializer.Deserialize<CustomerDto>(content);
        
        Assert.NotNull(customer);
        Assert.Equal(customerId, customer.Id);
    }
}
```

## Performance Considerations

### Caching Implementation
```csharp
// Memory caching example
public class CachedCustomerService : ICustomerService
{
    private readonly ICustomerService _customerService;
    private readonly IMemoryCache _cache;
    private readonly TimeSpan _cacheExpiration = TimeSpan.FromMinutes(5);
    
    public async Task<CustomerDto> GetCustomerAsync(int id, CancellationToken cancellationToken)
    {
        var cacheKey = $"customer_{id}";
        
        if (_cache.TryGetValue(cacheKey, out CustomerDto cachedCustomer))
        {
            return cachedCustomer;
        }
        
        var customer = await _customerService.GetCustomerAsync(id, cancellationToken);
        
        _cache.Set(cacheKey, customer, _cacheExpiration);
        
        return customer;
    }
}
```

### Database Optimization
```csharp
// Query optimization patterns
public async Task<List<CustomerDto>> GetActiveCustomersAsync(int pageSize, int pageNumber, CancellationToken cancellationToken)
{
    return await _context.Customers
        .Where(c => c.IsActive)
        .OrderBy(c => c.Name)
        .Skip(pageNumber * pageSize)
        .Take(pageSize)
        .Select(c => new CustomerDto
        {
            Id = c.Id,
            Name = c.Name,
            Email = c.Email
        })
        .ToListAsync(cancellationToken);
}
```

## Security Implementation

### Input Validation
```csharp
// Request validation with custom attributes
public class CreateCustomerRequest
{
    [Required]
    [StringLength(100, MinimumLength = 2)]
    public string Name { get; set; }
    
    [Required]
    [EmailAddress]
    [StringLength(255)]
    public string Email { get; set; }
    
    [Phone]
    public string? PhoneNumber { get; set; }
}
```

### Authorization Patterns
```csharp
// Controller with authorization
[ApiController]
[Route("api/[controller]")]
[Authorize]
public class CustomersController : ControllerBase
{
    [HttpGet]
    [Authorize(Roles = "User,Admin")]
    public async Task<ActionResult<List<CustomerDto>>> GetCustomers()
    {
        // Implementation
    }
    
    [HttpPost]
    [Authorize(Policy = "CanCreateCustomer")]
    public async Task<ActionResult<CustomerDto>> CreateCustomer(CreateCustomerRequest request)
    {
        // Implementation
    }
}
```

## Deployment and Operations

### Health Check Implementation
```csharp
// Health check for the feature
public class CustomerHealthCheck : IHealthCheck
{
    private readonly ICustomerRepository _repository;
    
    public CustomerHealthCheck(ICustomerRepository repository)
    {
        _repository = repository;
    }
    
    public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken)
    {
        try
        {
            var count = await _repository.GetCountAsync(cancellationToken);
            return HealthCheckResult.Healthy($"Customer service is healthy. Total customers: {count}");
        }
        catch (Exception ex)
        {
            return HealthCheckResult.Unhealthy("Customer service is unhealthy", ex);
        }
    }
}
```

### Monitoring and Logging
```csharp
// Structured logging example
public class CustomerService : ICustomerService
{
    private readonly ILogger<CustomerService> _logger;
    
    public async Task<CustomerDto> GetCustomerAsync(int id, CancellationToken cancellationToken)
    {
        using var scope = _logger.BeginScope("Getting customer {CustomerId}", id);
        
        _logger.LogInformation("Starting customer retrieval for ID: {CustomerId}", id);
        
        try
        {
            var customer = await _repository.GetByIdAsync(id, cancellationToken);
            
            if (customer == null)
            {
                _logger.LogWarning("Customer not found with ID: {CustomerId}", id);
                throw new CustomerNotFoundException(id);
            }
            
            _logger.LogInformation("Successfully retrieved customer {CustomerId}", id);
            return _mapper.Map<CustomerDto>(customer);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving customer {CustomerId}", id);
            throw;
        }
    }
}
```

---

*This feature documentation follows the 3-tier documentation system. For component-level architecture, see the parent CONTEXT.md file. For foundational project information, see [/CLAUDE.md] and [/docs/ai-context/project-structure.md].*