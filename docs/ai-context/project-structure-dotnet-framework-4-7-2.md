# .NET Framework 4.7.2 Project Structure & Technology Stack

This file provides comprehensive project structure and technology stack information for AI agents working with this .NET Framework 4.7.2 application.

## Technology Stack

### Core Technologies
- **.NET Framework**: 4.7.2 (Windows-specific runtime)
- **C#**: 7.3 (latest language version for .NET Framework 4.7.2)
- **MSBuild**: Build system and project management
- **NuGet**: Package management
- **Visual Studio**: Primary IDE (2017/2019/2022)

### Web Framework
- **ASP.NET Web API 2**: RESTful web services framework
- **OWIN**: Open Web Interface for .NET middleware
- **IIS**: Internet Information Services for hosting
- **System.Web.Http**: Core Web API functionality
- **Microsoft.AspNet.WebApi.Owin**: OWIN integration

### Application Types
- **Web API Applications**: REST API services
- **Console Applications**: Command-line tools and batch processors
- **Windows Services**: Background services and daemon processes
- **Class Libraries**: Shared business logic and utilities
- **Unit Test Projects**: Testing assemblies

### Database & Storage
- **SQL Server**: Primary relational database
- **Entity Framework 6.x**: Object-relational mapping
- **ADO.NET**: Direct database access
- **Dapper**: Lightweight micro-ORM
- **System.Data.SqlClient**: SQL Server connectivity

### Database Libraries
- **EntityFramework**: Full-featured ORM
- **System.Data.Entity**: Entity Framework core
- **Dapper**: High-performance micro-ORM
- **System.Data**: Core ADO.NET classes
- **System.Data.SqlClient**: SQL Server provider

### Authentication & Security
- **ASP.NET Identity**: User authentication and authorization
- **JWT**: JSON Web Tokens for stateless authentication
- **OWIN Security**: Authentication middleware
- **System.Security**: Core security classes
- **Windows Authentication**: Integrated Windows authentication

### Configuration & Environment
- **System.Configuration**: Configuration management
- **app.config/web.config**: XML-based configuration files
- **ConfigurationManager**: Configuration access
- **appSettings**: Application settings
- **connectionStrings**: Database connection configuration

### Logging & Monitoring
- **NLog**: Flexible logging framework
- **Serilog**: Structured logging
- **log4net**: Apache logging framework
- **System.Diagnostics**: Built-in diagnostic tools
- **Performance Counters**: Windows performance monitoring

### Dependency Injection
- **Autofac**: Mature IoC container
- **Unity**: Microsoft's dependency injection container
- **Ninject**: Lightweight dependency injection
- **Castle Windsor**: Feature-rich IoC container

### Testing Framework
- **NUnit**: Popular unit testing framework
- **MSTest**: Microsoft's testing framework
- **xUnit.net**: Modern testing framework
- **Moq**: Mocking framework
- **FluentAssertions**: Fluent assertion library

### Development Tools
- **Visual Studio**: Primary IDE
- **MSBuild**: Build engine
- **NuGet Package Manager**: Dependency management
- **IIS Express**: Development web server
- **SQL Server Management Studio**: Database management

### Deployment & Distribution
- **IIS**: Web application hosting
- **Windows Services**: Background service hosting
- **ClickOnce**: Application deployment
- **MSI Installers**: Windows installer packages
- **XCOPY Deployment**: Simple file copy deployment

## Project Structure

```
YourSolution/
├── YourSolution.sln                           # Solution file
├── packages/                                  # NuGet packages (packages.config)
├── .nuget/                                   # NuGet configuration
├── src/                                      # Source code
│   ├── YourProject.Core/                     # Core business logic
│   │   ├── Models/                           # Domain models and entities
│   │   │   ├── Customer.cs                   # Customer entity
│   │   │   ├── Order.cs                      # Order entity
│   │   │   └── CONTEXT.md                    # Model documentation
│   │   ├── Interfaces/                       # Service and repository interfaces
│   │   │   ├── ICustomerService.cs           # Customer service interface
│   │   │   ├── ICustomerRepository.cs        # Customer repository interface
│   │   │   └── CONTEXT.md                    # Interface documentation
│   │   ├── Services/                         # Business logic services
│   │   │   ├── CustomerService.cs            # Customer business logic
│   │   │   ├── OrderService.cs               # Order business logic
│   │   │   └── CONTEXT.md                    # Service documentation
│   │   ├── Exceptions/                       # Custom exceptions
│   │   │   ├── BusinessException.cs          # Business logic exceptions
│   │   │   ├── ValidationException.cs        # Validation exceptions
│   │   │   └── CONTEXT.md                    # Exception documentation
│   │   ├── Constants/                        # Application constants
│   │   │   ├── AppConstants.cs               # General constants
│   │   │   └── CONTEXT.md                    # Constants documentation
│   │   ├── YourProject.Core.csproj           # Core project file
│   │   ├── packages.config                   # NuGet packages
│   │   └── CONTEXT.md                        # Core layer documentation
│   │
│   ├── YourProject.Data/                     # Data access layer
│   │   ├── Context/                          # Entity Framework context
│   │   │   ├── ApplicationDbContext.cs       # Main database context
│   │   │   ├── DbContextFactory.cs           # Context factory
│   │   │   └── CONTEXT.md                    # Context documentation
│   │   ├── Repositories/                     # Data repositories
│   │   │   ├── CustomerRepository.cs         # Customer data access
│   │   │   ├── OrderRepository.cs            # Order data access
│   │   │   ├── BaseRepository.cs             # Base repository pattern
│   │   │   └── CONTEXT.md                    # Repository documentation
│   │   ├── Configurations/                   # EF configurations
│   │   │   ├── CustomerConfiguration.cs      # Customer entity config
│   │   │   ├── OrderConfiguration.cs         # Order entity config
│   │   │   └── CONTEXT.md                    # Configuration documentation
│   │   ├── Migrations/                       # EF Code First migrations
│   │   │   ├── 202401010001_InitialCreate.cs # Initial migration
│   │   │   ├── 202401020001_AddOrders.cs     # Add orders migration
│   │   │   └── Configuration.cs              # Migration configuration
│   │   ├── Seeds/                            # Data seeding
│   │   │   ├── CustomerSeed.cs               # Customer seed data
│   │   │   └── CONTEXT.md                    # Seed documentation
│   │   ├── YourProject.Data.csproj           # Data project file
│   │   ├── packages.config                   # NuGet packages
│   │   ├── App.config                        # Data layer configuration
│   │   └── CONTEXT.md                        # Data layer documentation
│   │
│   ├── YourProject.Api/                      # Web API application
│   │   ├── Controllers/                      # API controllers
│   │   │   ├── CustomersController.cs        # Customer API endpoints
│   │   │   ├── OrdersController.cs           # Order API endpoints
│   │   │   ├── BaseApiController.cs          # Base controller
│   │   │   └── CONTEXT.md                    # Controller documentation
│   │   ├── Models/                           # API models and DTOs
│   │   │   ├── Requests/                     # Request models
│   │   │   │   ├── CreateCustomerRequest.cs  # Customer creation request
│   │   │   │   ├── UpdateCustomerRequest.cs  # Customer update request
│   │   │   │   └── CONTEXT.md                # Request model documentation
│   │   │   ├── Responses/                    # Response models
│   │   │   │   ├── CustomerResponse.cs       # Customer response
│   │   │   │   ├── ApiResponse.cs            # Generic API response
│   │   │   │   └── CONTEXT.md                # Response model documentation
│   │   │   └── CONTEXT.md                    # API model documentation
│   │   ├── Filters/                          # Action filters and attributes
│   │   │   ├── ExceptionFilter.cs            # Global exception handling
│   │   │   ├── ValidationFilter.cs           # Model validation
│   │   │   ├── AuthenticationFilter.cs       # Authentication filter
│   │   │   └── CONTEXT.md                    # Filter documentation
│   │   ├── App_Start/                        # Application startup
│   │   │   ├── WebApiConfig.cs               # Web API configuration
│   │   │   ├── AutofacConfig.cs              # Dependency injection setup
│   │   │   ├── RouteConfig.cs                # Routing configuration
│   │   │   └── CONTEXT.md                    # Startup documentation
│   │   ├── Properties/                       # Assembly properties
│   │   │   └── AssemblyInfo.cs               # Assembly metadata
│   │   ├── bin/                              # Compiled assemblies
│   │   ├── obj/                              # Build artifacts
│   │   ├── YourProject.Api.csproj            # API project file
│   │   ├── packages.config                   # NuGet packages
│   │   ├── Global.asax                       # Application events
│   │   ├── Global.asax.cs                    # Application startup code
│   │   ├── Web.config                        # Web application configuration
│   │   └── CONTEXT.md                        # API layer documentation
│   │
│   ├── YourProject.Console/                  # Console application
│   │   ├── Commands/                         # Command implementations
│   │   │   ├── ProcessOrdersCommand.cs       # Order processing command
│   │   │   ├── ImportCustomersCommand.cs     # Customer import command
│   │   │   ├── BaseCommand.cs                # Base command pattern
│   │   │   └── CONTEXT.md                    # Command documentation
│   │   ├── Configuration/                    # Console app configuration
│   │   │   ├── ConsoleConfig.cs              # Configuration setup
│   │   │   └── CONTEXT.md                    # Configuration documentation
│   │   ├── Properties/                       # Assembly properties
│   │   │   └── AssemblyInfo.cs               # Assembly metadata
│   │   ├── YourProject.Console.csproj        # Console project file
│   │   ├── packages.config                   # NuGet packages
│   │   ├── Program.cs                        # Application entry point
│   │   ├── App.config                        # Console app configuration
│   │   └── CONTEXT.md                        # Console app documentation
│   │
│   ├── YourProject.WindowsService/           # Windows service application
│   │   ├── Services/                         # Service implementations
│   │   │   ├── OrderProcessingService.cs     # Order processing service
│   │   │   ├── DataSyncService.cs            # Data synchronization service
│   │   │   └── CONTEXT.md                    # Service documentation
│   │   ├── Workers/                          # Background workers
│   │   │   ├── OrderWorker.cs                # Order processing worker
│   │   │   ├── EmailWorker.cs                # Email processing worker
│   │   │   └── CONTEXT.md                    # Worker documentation
│   │   ├── Configuration/                    # Service configuration
│   │   │   ├── ServiceConfig.cs              # Service setup
│   │   │   └── CONTEXT.md                    # Configuration documentation
│   │   ├── Properties/                       # Assembly properties
│   │   │   └── AssemblyInfo.cs               # Assembly metadata
│   │   ├── YourProject.WindowsService.csproj # Service project file
│   │   ├── packages.config                   # NuGet packages
│   │   ├── Program.cs                        # Service entry point
│   │   ├── App.config                        # Service configuration
│   │   └── CONTEXT.md                        # Windows service documentation
│   │
│   └── YourProject.Common/                   # Shared utilities
│       ├── Extensions/                       # Extension methods
│       │   ├── StringExtensions.cs           # String utilities
│       │   ├── DateTimeExtensions.cs         # DateTime utilities
│       │   └── CONTEXT.md                    # Extension documentation
│       ├── Helpers/                          # Helper classes
│       │   ├── ConfigurationHelper.cs        # Configuration utilities
│       │   ├── LoggingHelper.cs              # Logging utilities
│       │   └── CONTEXT.md                    # Helper documentation
│       ├── Utilities/                        # Utility classes
│       │   ├── EmailUtility.cs               # Email functionality
│       │   ├── FileUtility.cs                # File operations
│       │   └── CONTEXT.md                    # Utility documentation
│       ├── YourProject.Common.csproj         # Common project file
│       ├── packages.config                   # NuGet packages
│       └── CONTEXT.md                        # Common layer documentation
│
├── tests/                                    # Test projects
│   ├── YourProject.Core.Tests/               # Core layer tests
│   │   ├── Services/                         # Service tests
│   │   │   ├── CustomerServiceTests.cs       # Customer service tests
│   │   │   ├── OrderServiceTests.cs          # Order service tests
│   │   │   └── CONTEXT.md                    # Service test documentation
│   │   ├── Models/                           # Model tests
│   │   │   ├── CustomerTests.cs              # Customer model tests
│   │   │   └── CONTEXT.md                    # Model test documentation
│   │   ├── TestHelpers/                      # Test utilities
│   │   │   ├── TestDataBuilder.cs            # Test data creation
│   │   │   ├── MockFactory.cs                # Mock object factory
│   │   │   └── CONTEXT.md                    # Test helper documentation
│   │   ├── YourProject.Core.Tests.csproj     # Core test project file
│   │   ├── packages.config                   # NuGet packages
│   │   ├── App.config                        # Test configuration
│   │   └── CONTEXT.md                        # Core test documentation
│   │
│   ├── YourProject.Data.Tests/               # Data layer tests
│   │   ├── Repositories/                     # Repository tests
│   │   │   ├── CustomerRepositoryTests.cs    # Customer repository tests
│   │   │   ├── OrderRepositoryTests.cs       # Order repository tests
│   │   │   └── CONTEXT.md                    # Repository test documentation
│   │   ├── Context/                          # Context tests
│   │   │   ├── ApplicationDbContextTests.cs  # DbContext tests
│   │   │   └── CONTEXT.md                    # Context test documentation
│   │   ├── YourProject.Data.Tests.csproj     # Data test project file
│   │   ├── packages.config                   # NuGet packages
│   │   ├── App.config                        # Test configuration
│   │   └── CONTEXT.md                        # Data test documentation
│   │
│   ├── YourProject.Api.Tests/                # API layer tests
│   │   ├── Controllers/                      # Controller tests
│   │   │   ├── CustomersControllerTests.cs   # Customer controller tests
│   │   │   ├── OrdersControllerTests.cs      # Order controller tests
│   │   │   └── CONTEXT.md                    # Controller test documentation
│   │   ├── Integration/                      # Integration tests
│   │   │   ├── CustomerApiTests.cs           # Customer API integration tests
│   │   │   ├── OrderApiTests.cs              # Order API integration tests
│   │   │   └── CONTEXT.md                    # Integration test documentation
│   │   ├── YourProject.Api.Tests.csproj      # API test project file
│   │   ├── packages.config                   # NuGet packages
│   │   ├── App.config                        # Test configuration
│   │   └── CONTEXT.md                        # API test documentation
│   │
│   └── YourProject.Integration.Tests/        # Full integration tests
│       ├── Scenarios/                        # Test scenarios
│       │   ├── OrderProcessingScenario.cs    # Order processing scenario
│       │   ├── CustomerManagementScenario.cs # Customer scenario
│       │   └── CONTEXT.md                    # Scenario documentation
│       ├── Fixtures/                         # Test fixtures
│       │   ├── DatabaseFixture.cs            # Database test fixture
│       │   ├── ApiFixture.cs                 # API test fixture
│       │   └── CONTEXT.md                    # Fixture documentation
│       ├── YourProject.Integration.Tests.csproj # Integration test project
│       ├── packages.config                   # NuGet packages
│       ├── App.config                        # Test configuration
│       └── CONTEXT.md                        # Integration test documentation
│
├── tools/                                    # Development tools
│   ├── scripts/                              # Build and deployment scripts
│   │   ├── build.bat                         # Build script
│   │   ├── deploy.bat                        # Deployment script
│   │   ├── test.bat                          # Test execution script
│   │   └── CONTEXT.md                        # Script documentation
│   ├── generators/                           # Code generators
│   │   ├── ModelGenerator.tt                 # T4 template for models
│   │   ├── RepositoryGenerator.tt            # T4 template for repositories
│   │   └── CONTEXT.md                        # Generator documentation
│   └── CONTEXT.md                            # Tools documentation
│
├── docs/                                     # Documentation
│   ├── ai-context/                           # AI context documentation
│   │   ├── project-structure.md              # This file
│   │   ├── docs-overview.md                  # Documentation overview
│   │   ├── system-integration.md             # System integration
│   │   ├── deployment-infrastructure.md      # Deployment infrastructure
│   │   └── handoff.md                        # Handoff documentation
│   ├── architecture/                         # Architecture documentation
│   │   ├── overview.md                       # Architecture overview
│   │   ├── database-design.md                # Database design
│   │   ├── api-design.md                     # API design
│   │   └── security.md                       # Security documentation
│   ├── development/                          # Development guides
│   │   ├── setup.md                          # Development setup
│   │   ├── testing.md                        # Testing guide
│   │   ├── debugging.md                      # Debugging guide
│   │   └── contributing.md                   # Contributing guide
│   └── CONTEXT.md                            # Docs documentation
│
├── deployment/                               # Deployment configurations
│   ├── iis/                                 # IIS configuration
│   │   ├── web.config.transform              # IIS-specific config
│   │   ├── applicationHost.config            # IIS application config
│   │   └── CONTEXT.md                        # IIS deployment docs
│   ├── services/                             # Windows service deployment
│   │   ├── install-service.bat               # Service installation script
│   │   ├── uninstall-service.bat             # Service removal script
│   │   └── CONTEXT.md                        # Service deployment docs
│   ├── database/                             # Database deployment
│   │   ├── create-database.sql               # Database creation script
│   │   ├── seed-data.sql                     # Initial data script
│   │   └── CONTEXT.md                        # Database deployment docs
│   └── CONTEXT.md                            # Deployment documentation
│
├── config/                                   # Configuration files
│   ├── environments/                         # Environment-specific configs
│   │   ├── Development.config                # Development configuration
│   │   ├── Staging.config                    # Staging configuration
│   │   ├── Production.config                 # Production configuration
│   │   └── CONTEXT.md                        # Environment config docs
│   ├── logging/                              # Logging configurations
│   │   ├── NLog.config                       # NLog configuration
│   │   ├── log4net.config                    # log4net configuration
│   │   └── CONTEXT.md                        # Logging config docs
│   └── CONTEXT.md                            # Configuration documentation
│
├── .gitignore                                # Git ignore rules
├── .gitattributes                            # Git attributes
├── README.md                                 # Project documentation
├── CHANGELOG.md                              # Change log
├── LICENSE                                   # License file
└── CLAUDE.md                                 # AI context file
```

## Key Directory Purposes

### Application Entry Points
- **src/YourProject.Api/**: Web API application with REST endpoints
- **src/YourProject.Console/**: Console applications and command-line tools
- **src/YourProject.WindowsService/**: Background Windows services
- **src/YourProject.Core/**: Core business logic and domain models

### Business Logic Organization
- **Services/**: Business logic and use case implementations
- **Repositories/**: Data access layer and database operations
- **Models/**: Domain entities and data transfer objects
- **Controllers/**: Web API endpoints and request handling

### Infrastructure Components
- **Data/**: Entity Framework context and data access
- **Common/**: Shared utilities and extension methods
- **Filters/**: Cross-cutting concerns (authentication, validation, logging)
- **Configuration/**: Application setup and dependency injection

### Testing Structure
- **Unit Tests**: Located alongside source projects with .Tests suffix
- **Integration Tests**: End-to-end testing in separate projects
- **Test Helpers**: Shared testing utilities and mock factories

## .NET Framework Solution Structure

### Solution Configuration
```xml
Microsoft Visual Studio Solution File, Format Version 12.00
# Visual Studio Version 16
VisualStudioVersion = 16.0.30114.105
MinimumVisualStudioVersion = 10.0.40219.1

Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "YourProject.Core", "src\YourProject.Core\YourProject.Core.csproj", "{GUID-1}"
EndProject
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "YourProject.Data", "src\YourProject.Data\YourProject.Data.csproj", "{GUID-2}"
EndProject
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "YourProject.Api", "src\YourProject.Api\YourProject.Api.csproj", "{GUID-3}"
EndProject
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "YourProject.Console", "src\YourProject.Console\YourProject.Console.csproj", "{GUID-4}"
EndProject
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "YourProject.WindowsService", "src\YourProject.WindowsService\YourProject.WindowsService.csproj", "{GUID-5}"
EndProject
```

### Project Dependencies
- **YourProject.Api** → YourProject.Core, YourProject.Data, YourProject.Common
- **YourProject.Console** → YourProject.Core, YourProject.Data, YourProject.Common
- **YourProject.WindowsService** → YourProject.Core, YourProject.Data, YourProject.Common
- **YourProject.Data** → YourProject.Core
- **YourProject.Core** → YourProject.Common

## Development Workflow

### Common Commands
```bash
# Solution management
nuget restore YourSolution.sln
msbuild YourSolution.sln /p:Configuration=Release

# Project management
msbuild YourProject.Api.csproj /p:Configuration=Debug
msbuild YourProject.Console.csproj /p:OutputPath=..\bin\

# Package management
nuget install packages.config -OutputDirectory packages
nuget update packages.config

# Testing
nunit3-console.exe YourProject.Tests.dll
mstest.exe /testcontainer:YourProject.Tests.dll

# Entity Framework
Enable-Migrations -ProjectName YourProject.Data
Add-Migration InitialCreate -ProjectName YourProject.Data
Update-Database -ProjectName YourProject.Data

# Windows Service
installutil.exe YourProject.WindowsService.exe
net start YourServiceName
```

### Build Configuration
```xml
<!-- Common project properties -->
<PropertyGroup>
  <TargetFrameworkVersion>v4.7.2</TargetFrameworkVersion>
  <FileAlignment>512</FileAlignment>
  <AutoGenerateBindingRedirects>true</AutoGenerateBindingRedirects>
  <Deterministic>true</Deterministic>
</PropertyGroup>

<PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
  <DebugSymbols>true</DebugSymbols>
  <DebugType>full</DebugType>
  <Optimize>false</Optimize>
  <OutputPath>bin\Debug\</OutputPath>
  <DefineConstants>DEBUG;TRACE</DefineConstants>
  <ErrorReport>prompt</ErrorReport>
  <WarningLevel>4</WarningLevel>
</PropertyGroup>
```

## Configuration Structure

### Web.config Hierarchy
- **Machine.config**: Machine-level configuration
- **Root Web.config**: Framework configuration
- **Application Web.config**: Application-specific settings
- **Folder Web.config**: Directory-specific overrides

### App.config Structure
```xml
<configuration>
  <configSections />
  <startup />
  <appSettings />
  <connectionStrings />
  <system.serviceModel />
  <runtime />
  <entityFramework />
</configuration>
```

## Deployment Structure

### IIS Deployment
- **Application Pool**: Dedicated app pool for isolation
- **Physical Path**: Application files location
- **Virtual Directory**: IIS virtual path mapping
- **Bindings**: HTTP/HTTPS port bindings

### Windows Service Deployment
- **Service Installation**: Using InstallUtil or TopShelf
- **Service Configuration**: Service name, description, startup type
- **Permissions**: Service account and security settings
- **Dependencies**: Service dependencies and startup order

### Database Deployment
- **Schema Scripts**: Database creation and migration scripts
- **Data Scripts**: Initial data and seed scripts
- **Backup Strategy**: Database backup and restore procedures
- **Connection Strings**: Environment-specific database connections

This structure provides a solid foundation for enterprise .NET Framework 4.7.2 applications with clear separation of concerns, testability, and maintainability.