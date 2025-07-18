# .NET Core 8 Project Structure & Technology Stack

This file provides comprehensive project structure and technology stack information for AI agents working with this .NET Core 8 C# application.

## Technology Stack

### Core Technologies
- **.NET Core**: 8.0 (LTS)
- **C# Language**: 12.0
- **Runtime**: .NET 8 Runtime
- **Target Framework**: net8.0
- **Nullable Reference Types**: Enabled
- **Implicit Usings**: Enabled

### Web Framework
- **ASP.NET Core**: 8.0
- **Minimal APIs**: For lightweight HTTP APIs
- **MVC**: For complex web applications
- **Razor Pages**: For page-based scenarios
- **SignalR**: For real-time communication (if applicable)

### Data Access
- **Entity Framework Core**: 8.0
- **Database Provider**: [SQL Server/PostgreSQL/SQLite - specify your choice]
- **Migrations**: Code-first migrations
- **Connection Pooling**: Enabled
- **Database Context**: Per-request scoped

### Authentication & Authorization
- **ASP.NET Core Identity**: 8.0
- **JWT Bearer**: For API authentication
- **Cookie Authentication**: For web applications
- **OAuth 2.0/OpenID Connect**: For external providers
- **Authorization Policies**: Role and claim-based

### Configuration & Secrets
- **appsettings.json**: Application configuration
- **User Secrets**: Development secrets
- **Azure Key Vault**: Production secrets (if applicable)
- **Environment Variables**: Environment-specific config

### Logging & Monitoring
- **Microsoft.Extensions.Logging**: Built-in logging
- **Serilog**: Structured logging (if applicable)
- **Application Insights**: Telemetry and monitoring (if applicable)
- **OpenTelemetry**: Distributed tracing
- **Health Checks**: Service health monitoring

### Testing Framework
- **xUnit**: Primary testing framework
- **NUnit**: Alternative testing framework (if applicable)
- **FluentAssertions**: Assertion library
- **Moq**: Mocking framework
- **TestContainers**: Integration testing with real dependencies
- **WebApplicationFactory**: Integration testing for web APIs

### Development Tools
- **Visual Studio**: 2022 (17.8+)
- **Visual Studio Code**: With C# Dev Kit
- **JetBrains Rider**: Alternative IDE
- **dotnet CLI**: Command-line interface
- **NuGet**: Package management
- **Git**: Version control

### Build & Deployment
- **MSBuild**: Build system
- **GitHub Actions**: CI/CD pipeline (if applicable)
- **Azure DevOps**: CI/CD pipeline (if applicable)
- **Docker**: Containerization
- **Kubernetes**: Container orchestration (if applicable)

### Code Quality & Analysis
- **Roslyn Analyzers**: Code analysis
- **EditorConfig**: Code formatting
- **SonarQube**: Code quality analysis (if applicable)
- **Security Code Scan**: Security analysis

## Project Structure

```
YourProject/
├── YourProject.sln                           # Solution file
├── .editorconfig                            # Editor configuration
├── .gitignore                               # Git ignore rules
├── global.json                              # .NET SDK version
├── Directory.Build.props                    # MSBuild properties
├── README.md                                # Project documentation
├── docker-compose.yml                       # Docker composition (if applicable)
├── src/                                     # Source code
│   ├── YourProject.Domain/                  # Domain layer
│   │   ├── YourProject.Domain.csproj
│   │   ├── CONTEXT.md                       # Domain documentation
│   │   ├── Entities/                        # Domain entities
│   │   │   ├── Customer.cs
│   │   │   ├── Order.cs
│   │   │   └── Product.cs
│   │   ├── ValueObjects/                    # Value objects
│   │   │   ├── Email.cs
│   │   │   └── Money.cs
│   │   ├── Interfaces/                      # Domain interfaces
│   │   │   ├── ICustomerRepository.cs
│   │   │   └── IOrderRepository.cs
│   │   ├── Services/                        # Domain services
│   │   │   └── OrderCalculationService.cs
│   │   └── Events/                          # Domain events
│   │       ├── CustomerCreatedEvent.cs
│   │       └── OrderPlacedEvent.cs
│   │
│   ├── YourProject.Application/             # Application layer
│   │   ├── YourProject.Application.csproj
│   │   ├── CONTEXT.md                       # Application documentation
│   │   ├── GlobalUsings.cs                  # Global using statements
│   │   ├── DependencyInjection.cs           # DI registration
│   │   ├── Commands/                        # CQRS commands
│   │   │   ├── Customers/
│   │   │   │   ├── CreateCustomerCommand.cs
│   │   │   │   └── CreateCustomerHandler.cs
│   │   │   └── Orders/
│   │   │       ├── PlaceOrderCommand.cs
│   │   │       └── PlaceOrderHandler.cs
│   │   ├── Queries/                         # CQRS queries
│   │   │   ├── Customers/
│   │   │   │   ├── GetCustomerQuery.cs
│   │   │   │   └── GetCustomerHandler.cs
│   │   │   └── Orders/
│   │   │       ├── GetOrdersQuery.cs
│   │   │       └── GetOrdersHandler.cs
│   │   ├── DTOs/                            # Data transfer objects
│   │   │   ├── CustomerDto.cs
│   │   │   └── OrderDto.cs
│   │   ├── Interfaces/                      # Application interfaces
│   │   │   ├── ICustomerService.cs
│   │   │   └── IOrderService.cs
│   │   ├── Services/                        # Application services
│   │   │   ├── CustomerService.cs
│   │   │   └── OrderService.cs
│   │   ├── Validators/                      # Request validators
│   │   │   ├── CreateCustomerValidator.cs
│   │   │   └── PlaceOrderValidator.cs
│   │   └── Mappings/                        # AutoMapper profiles
│   │       ├── CustomerProfile.cs
│   │       └── OrderProfile.cs
│   │
│   ├── YourProject.Infrastructure/          # Infrastructure layer
│   │   ├── YourProject.Infrastructure.csproj
│   │   ├── CONTEXT.md                       # Infrastructure documentation
│   │   ├── DependencyInjection.cs           # DI registration
│   │   ├── Data/                            # Data access
│   │   │   ├── ApplicationDbContext.cs      # EF Core context
│   │   │   ├── CONTEXT.md                   # Data layer documentation
│   │   │   ├── Configurations/              # Entity configurations
│   │   │   │   ├── CustomerConfiguration.cs
│   │   │   │   └── OrderConfiguration.cs
│   │   │   ├── Migrations/                  # EF Core migrations
│   │   │   │   ├── 20240101000000_Initial.cs
│   │   │   │   └── 20240115000000_AddOrders.cs
│   │   │   └── Repositories/                # Repository implementations
│   │   │       ├── CustomerRepository.cs
│   │   │       └── OrderRepository.cs
│   │   ├── Services/                        # Infrastructure services
│   │   │   ├── EmailService.cs
│   │   │   └── FileStorageService.cs
│   │   ├── Identity/                        # Identity configuration
│   │   │   ├── ApplicationUser.cs
│   │   │   └── IdentityConfiguration.cs
│   │   └── External/                        # External service integrations
│   │       ├── PaymentService.cs
│   │       └── NotificationService.cs
│   │
│   ├── YourProject.Web/                     # Web layer (MVC/Razor Pages)
│   │   ├── YourProject.Web.csproj
│   │   ├── CONTEXT.md                       # Web layer documentation
│   │   ├── Program.cs                       # Application entry point
│   │   ├── appsettings.json                 # Configuration
│   │   ├── appsettings.Development.json     # Development config
│   │   ├── appsettings.Production.json      # Production config
│   │   ├── GlobalUsings.cs                  # Global using statements
│   │   ├── Controllers/                     # MVC controllers
│   │   │   ├── HomeController.cs
│   │   │   ├── CustomerController.cs
│   │   │   └── OrderController.cs
│   │   ├── Views/                           # Razor views
│   │   │   ├── Shared/
│   │   │   │   ├── _Layout.cshtml
│   │   │   │   └── _ViewImports.cshtml
│   │   │   ├── Home/
│   │   │   │   └── Index.cshtml
│   │   │   └── Customer/
│   │   │       ├── Index.cshtml
│   │   │       └── Create.cshtml
│   │   ├── Areas/                           # MVC areas
│   │   │   └── Admin/
│   │   │       ├── Controllers/
│   │   │       └── Views/
│   │   ├── wwwroot/                         # Static files
│   │   │   ├── css/
│   │   │   ├── js/
│   │   │   └── images/
│   │   ├── Models/                          # View models
│   │   │   ├── CustomerViewModel.cs
│   │   │   └── OrderViewModel.cs
│   │   ├── Services/                        # Web-specific services
│   │   │   └── ViewModelService.cs
│   │   └── Middleware/                      # Custom middleware
│   │       ├── ExceptionMiddleware.cs
│   │       └── RequestLoggingMiddleware.cs
│   │
│   ├── YourProject.Api/                     # Web API layer
│   │   ├── YourProject.Api.csproj
│   │   ├── CONTEXT.md                       # API documentation
│   │   ├── Program.cs                       # API entry point
│   │   ├── appsettings.json                 # Configuration
│   │   ├── appsettings.Development.json     # Development config
│   │   ├── GlobalUsings.cs                  # Global using statements
│   │   ├── Controllers/                     # API controllers
│   │   │   ├── CustomersController.cs
│   │   │   └── OrdersController.cs
│   │   ├── Endpoints/                       # Minimal API endpoints
│   │   │   ├── CustomerEndpoints.cs
│   │   │   └── OrderEndpoints.cs
│   │   ├── Models/                          # API models
│   │   │   ├── CreateCustomerRequest.cs
│   │   │   └── PlaceOrderRequest.cs
│   │   ├── Filters/                         # Action filters
│   │   │   ├── ValidationFilter.cs
│   │   │   └── AuthorizationFilter.cs
│   │   └── Middleware/                      # API middleware
│   │       ├── ApiExceptionMiddleware.cs
│   │       └── RateLimitingMiddleware.cs
│   │
│   └── YourProject.Shared/                  # Shared components
│       ├── YourProject.Shared.csproj
│       ├── Constants/                       # Application constants
│       │   ├── ApiRoutes.cs
│       │   └── ErrorMessages.cs
│       ├── Extensions/                      # Extension methods
│       │   ├── StringExtensions.cs
│       │   └── DateTimeExtensions.cs
│       ├── Helpers/                         # Utility helpers
│       │   ├── CryptographyHelper.cs
│       │   └── JsonHelper.cs
│       └── Models/                          # Shared models
│           ├── Result.cs
│           └── PagedResult.cs
│
├── tests/                                   # Test projects
│   ├── YourProject.UnitTests/               # Unit tests
│   │   ├── YourProject.UnitTests.csproj
│   │   ├── GlobalUsings.cs                  # Global test usings
│   │   ├── Domain/                          # Domain tests
│   │   │   ├── Entities/
│   │   │   │   ├── CustomerTests.cs
│   │   │   │   └── OrderTests.cs
│   │   │   └── Services/
│   │   │       └── OrderCalculationServiceTests.cs
│   │   ├── Application/                     # Application tests
│   │   │   ├── Commands/
│   │   │   │   └── CreateCustomerHandlerTests.cs
│   │   │   ├── Queries/
│   │   │   │   └── GetCustomerHandlerTests.cs
│   │   │   └── Services/
│   │   │       └── CustomerServiceTests.cs
│   │   └── Infrastructure/                  # Infrastructure tests
│   │       └── Repositories/
│   │           └── CustomerRepositoryTests.cs
│   │
│   ├── YourProject.IntegrationTests/        # Integration tests
│   │   ├── YourProject.IntegrationTests.csproj
│   │   ├── GlobalUsings.cs                  # Global test usings
│   │   ├── TestFixtures/                    # Test fixtures
│   │   │   ├── WebApplicationFactory.cs
│   │   │   └── DatabaseFixture.cs
│   │   ├── Controllers/                     # Controller tests
│   │   │   ├── CustomersControllerTests.cs
│   │   │   └── OrdersControllerTests.cs
│   │   └── Endpoints/                       # Minimal API tests
│   │       ├── CustomerEndpointsTests.cs
│   │       └── OrderEndpointsTests.cs
│   │
│   └── YourProject.PerformanceTests/        # Performance tests
│       ├── YourProject.PerformanceTests.csproj
│       ├── LoadTests/                       # Load testing
│       │   ├── CustomerLoadTests.cs
│       │   └── OrderLoadTests.cs
│       └── BenchmarkTests/                  # Benchmark tests
│           ├── CustomerBenchmarks.cs
│           └── OrderBenchmarks.cs
│
├── tools/                                   # Development tools
│   ├── scripts/                             # Build/deployment scripts
│   │   ├── build.sh
│   │   ├── deploy.sh
│   │   └── test.sh
│   └── analyzers/                           # Custom analyzers
│       └── CustomAnalyzer.cs
│
├── docs/                                    # Project documentation
│   ├── ai-context/                          # AI context documentation
│   │   ├── project-structure.md
│   │   ├── docs-overview.md
│   │   ├── system-integration.md
│   │   ├── deployment-infrastructure.md
│   │   └── handoff.md
│   ├── architecture/                        # Architecture documentation
│   │   ├── overview.md
│   │   ├── domain-model.md
│   │   └── api-design.md
│   ├── deployment/                          # Deployment documentation
│   │   ├── docker.md
│   │   └── kubernetes.md
│   └── development/                         # Development guides
│       ├── getting-started.md
│       ├── testing.md
│       └── debugging.md
│
├── .github/                                 # GitHub configuration
│   ├── workflows/                           # GitHub Actions
│   │   ├── ci.yml
│   │   ├── cd.yml
│   │   └── security.yml
│   └── ISSUE_TEMPLATE/                      # Issue templates
│       ├── bug_report.md
│       └── feature_request.md
│
└── deployment/                              # Deployment configurations
    ├── docker/                              # Docker files
    │   ├── Dockerfile
    │   └── docker-compose.yml
    ├── kubernetes/                          # Kubernetes manifests
    │   ├── deployment.yaml
    │   ├── service.yaml
    │   └── ingress.yaml
    └── helm/                                # Helm charts
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
```

## Key Directory Purposes

### Source Code Organization
- **Domain**: Core business logic, entities, and domain rules
- **Application**: Use cases, commands, queries, and application services
- **Infrastructure**: Data access, external services, and infrastructure concerns
- **Web**: MVC controllers, views, and web-specific logic
- **Api**: REST API controllers and minimal API endpoints
- **Shared**: Common utilities and shared components

### Test Organization
- **UnitTests**: Fast, isolated tests for individual components
- **IntegrationTests**: Tests that verify component interactions
- **PerformanceTests**: Load testing and benchmarking

### Configuration Files
- **appsettings.json**: Application configuration
- **global.json**: .NET SDK version pinning
- **Directory.Build.props**: MSBuild properties shared across projects
- **.editorconfig**: Code formatting and style rules

## Development Workflow

### Common Commands
```bash
# Build solution
dotnet build

# Run tests
dotnet test

# Run application
dotnet run --project src/YourProject.Web
dotnet run --project src/YourProject.Api

# Entity Framework migrations
dotnet ef migrations add InitialCreate --project src/YourProject.Infrastructure
dotnet ef database update --project src/YourProject.Infrastructure

# Package management
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet list package --outdated
```

### Project Dependencies
- Domain: No dependencies on other projects
- Application: References Domain only
- Infrastructure: References Domain and Application
- Web/Api: References Application and Infrastructure
- Shared: Can be referenced by any project

This structure follows clean architecture principles and .NET 8 best practices for maintainable, testable, and scalable applications.