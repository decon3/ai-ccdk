# [Component Name] - .NET Core 8 Component Context

*This file documents the [Component Name] component within the .NET Core 8 application architecture.*

## Purpose
[Brief description of the component's purpose and primary responsibilities within the application]

## Current Status: [Active Development/Stable/Deprecated]
[Current state of the component with context about recent changes or planned evolution]

## Component-Specific Development Guidelines

### .NET Core 8 Patterns
- **Dependency Injection**: Uses built-in .NET DI container with proper service lifetimes
- **Configuration**: Leverages IOptions pattern with strongly-typed configuration
- **Logging**: Implements structured logging with ILogger<T> and proper log levels
- **Async/Await**: Follows async best practices with ConfigureAwait(false)
- **Nullable Reference Types**: Enabled with proper null handling throughout

### Architecture Patterns
- **Clean Architecture**: Follows separation of concerns with clear layer boundaries
- **CQRS**: Implements Command Query Responsibility Segregation (if applicable)
- **Repository Pattern**: Abstracts data access with proper interface segregation
- **Unit of Work**: Manages database transactions and consistency (if applicable)

### Technology-Specific Conventions
- **Entity Framework Core**: [Specific EF Core patterns used in this component]
- **ASP.NET Core**: [Specific ASP.NET Core patterns like middleware, filters, etc.]
- **Authentication/Authorization**: [Security patterns implemented]
- **API Design**: [REST/GraphQL/gRPC patterns followed]

## Major Subsystem Organization

### Core Directories
```
[ComponentName]/
├── Controllers/          # API controllers or MVC controllers
├── Services/            # Business logic services
├── Models/              # Data models and DTOs
├── Interfaces/          # Service contracts and abstractions
├── Validators/          # Input validation logic
├── Mappings/            # AutoMapper profiles or manual mappings
├── Middleware/          # Custom middleware components
├── Filters/             # Action filters and result filters
├── Extensions/          # Extension methods
├── Configuration/       # Component-specific configuration
└── CONTEXT.md          # This documentation file
```

### Key Classes and Responsibilities
- **[MainService]**: [Primary service responsibility]
- **[Repository]**: [Data access responsibility]
- **[Controller]**: [API/Web interface responsibility]
- **[Validator]**: [Input validation responsibility]

## Architectural Patterns

### Dependency Injection
```csharp
// Service registration patterns used
services.AddScoped<ICustomerService, CustomerService>();
services.AddSingleton<IConfiguration>(configuration);
services.AddTransient<IValidator<CreateCustomerRequest>, CreateCustomerValidator>();
```

### Configuration Management
```csharp
// Configuration binding patterns
services.Configure<ComponentOptions>(configuration.GetSection("ComponentName"));
services.AddOptions<ComponentOptions>()
    .Bind(configuration.GetSection("ComponentName"))
    .ValidateDataAnnotations();
```

### Error Handling
- **Exception Handling**: [Describe exception handling strategy]
- **Logging**: [Describe logging patterns and structured logging]
- **Validation**: [Describe validation approaches - FluentValidation, DataAnnotations]

### Performance Considerations
- **Caching**: [Describe caching strategies used]
- **Database Optimization**: [Describe query optimization approaches]
- **Memory Management**: [Describe memory usage patterns]

## Integration Points

### Internal Dependencies
- **[Component A]**: [Description of dependency and interaction]
- **[Component B]**: [Description of dependency and interaction]

### External Dependencies
- **Database**: [Database provider and connection patterns]
- **External APIs**: [Third-party API integrations]
- **Message Queues**: [Message broker integrations if applicable]
- **Cache**: [Redis, MemoryCache, or other caching solutions]

### Data Flow
```
[Input] → [Validation] → [Business Logic] → [Data Access] → [Output]
```

## Data Models and Schemas

### Primary Entities
- **[Entity1]**: [Description and key properties]
- **[Entity2]**: [Description and key properties]

### DTOs and ViewModels
- **[RequestDto]**: [API request models]
- **[ResponseDto]**: [API response models]
- **[ViewModel]**: [UI binding models]

### Database Schema
- **Tables**: [Primary tables managed by this component]
- **Relationships**: [Key foreign key relationships]
- **Indexes**: [Important indexes for performance]

## Security Implementation

### Authentication
- **Identity Provider**: [ASP.NET Core Identity, JWT, OAuth, etc.]
- **Token Management**: [JWT token handling patterns]

### Authorization
- **Role-based**: [Role-based access control implementation]
- **Policy-based**: [Policy-based authorization patterns]
- **Resource-based**: [Resource-based authorization if applicable]

### Input Validation
- **Model Validation**: [DataAnnotations, FluentValidation patterns]
- **Sanitization**: [Input sanitization approaches]
- **SQL Injection Prevention**: [EF Core, parameterized queries]

## Testing Strategy

### Unit Testing
- **Framework**: xUnit, NUnit, or MSTest
- **Mocking**: Moq, NSubstitute patterns
- **Test Data**: Builder patterns, fixtures
- **Coverage**: Target coverage levels and excluded areas

### Integration Testing
- **Test Database**: [TestContainers, in-memory database approaches]
- **API Testing**: [WebApplicationFactory patterns]
- **End-to-End**: [Selenium, Playwright if applicable]

### Performance Testing
- **Load Testing**: [NBomber, k6, or other tools]
- **Benchmarking**: [BenchmarkDotNet usage]

## Deployment Considerations

### Environment Configuration
- **Development**: [Local development setup]
- **Staging**: [Staging environment specifics]
- **Production**: [Production deployment patterns]

### Containerization
- **Docker**: [Dockerfile patterns and optimizations]
- **Kubernetes**: [Deployment manifests and scaling]

### Monitoring and Observability
- **Application Insights**: [Telemetry and monitoring setup]
- **Health Checks**: [Health check endpoints and patterns]
- **Logging**: [Structured logging and log aggregation]

## Development Workflow

### Common Tasks
```bash
# Build component
dotnet build src/[ComponentName]

# Run component tests
dotnet test tests/[ComponentName].Tests

# Run component with watch
dotnet watch run --project src/[ComponentName]
```

### Database Operations
```bash
# Add migration for component
dotnet ef migrations add [MigrationName] --project src/[ComponentName]

# Update component database
dotnet ef database update --project src/[ComponentName]
```

## Known Issues and Limitations

### Current Limitations
- **[Limitation 1]**: [Description and workaround]
- **[Limitation 2]**: [Description and planned resolution]

### Technical Debt
- **[Debt Item 1]**: [Description and priority]
- **[Debt Item 2]**: [Description and timeline]

## Future Enhancements

### Planned Features
- **[Feature 1]**: [Description and timeline]
- **[Feature 2]**: [Description and dependencies]

### Architecture Evolution
- **[Evolution 1]**: [Planned architectural changes]
- **[Evolution 2]**: [Technology upgrades or migrations]

---

*This documentation follows the 3-tier documentation system for AI-assisted development. For foundational project information, see [/CLAUDE.md] and [/docs/ai-context/project-structure.md]. For feature-specific details, see the relevant CONTEXT.md files in subdirectories.*