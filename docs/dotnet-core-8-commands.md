# .NET Core 8 Development Commands

This document provides comprehensive .NET Core 8 development commands for integration into CLAUDE.md files.

## Build and Compilation Commands

### Basic Build Operations
```bash
# Build entire solution
dotnet build

# Build specific project
dotnet build src/YourProject.Web

# Build in Release mode
dotnet build --configuration Release

# Build with specific framework
dotnet build --framework net8.0

# Clean build output
dotnet clean

# Restore NuGet packages
dotnet restore

# Build and restore in one command
dotnet build --restore
```

### Advanced Build Options
```bash
# Build with specific runtime
dotnet build --runtime win-x64

# Build for multiple frameworks
dotnet build --framework net8.0 --framework net6.0

# Build with version information
dotnet build --version-suffix "beta1"

# Build with specific MSBuild properties
dotnet build -p:Configuration=Release -p:Platform=x64
```

## Test Commands

### Unit and Integration Testing
```bash
# Run all tests
dotnet test

# Run tests with coverage
dotnet test --collect:"XPlat Code Coverage"

# Run tests in specific project
dotnet test tests/YourProject.UnitTests

# Run tests with detailed output
dotnet test --verbosity detailed

# Run tests with filter
dotnet test --filter "Category=Unit"
dotnet test --filter "FullyQualifiedName~Customer"

# Run tests in parallel
dotnet test --parallel

# Run tests with timeout
dotnet test --timeout 30000
```

### Test Reporting
```bash
# Generate test results in TRX format
dotnet test --logger trx

# Generate test results in JUnit format
dotnet test --logger "junit;LogFileName=test-results.xml"

# Multiple loggers
dotnet test --logger console --logger trx --logger html
```

## Run and Debug Commands

### Application Execution
```bash
# Run web application
dotnet run --project src/YourProject.Web

# Run API application
dotnet run --project src/YourProject.Api

# Run with specific environment
dotnet run --project src/YourProject.Web --environment Development

# Run with launch profile
dotnet run --project src/YourProject.Web --launch-profile "Development"

# Run with specific URLs
dotnet run --project src/YourProject.Web --urls "https://localhost:5001"
```

### Watch Mode (Hot Reload)
```bash
# Run with hot reload
dotnet watch run --project src/YourProject.Web

# Run tests with watch
dotnet watch test

# Build with watch
dotnet watch build
```

## Entity Framework Core Commands

### Database Operations
```bash
# Add migration
dotnet ef migrations add InitialCreate --project src/YourProject.Infrastructure

# Update database
dotnet ef database update --project src/YourProject.Infrastructure

# Remove last migration
dotnet ef migrations remove --project src/YourProject.Infrastructure

# List migrations
dotnet ef migrations list --project src/YourProject.Infrastructure

# Generate SQL script
dotnet ef migrations script --project src/YourProject.Infrastructure

# Drop database
dotnet ef database drop --project src/YourProject.Infrastructure
```

### Database Context Operations
```bash
# Scaffold DbContext from database
dotnet ef dbcontext scaffold "Server=localhost;Database=YourDb;Trusted_Connection=true;" Microsoft.EntityFrameworkCore.SqlServer --project src/YourProject.Infrastructure

# Generate DbContext info
dotnet ef dbcontext info --project src/YourProject.Infrastructure

# List DbContext types
dotnet ef dbcontext list --project src/YourProject.Infrastructure
```

## Package Management Commands

### NuGet Package Operations
```bash
# Add package to project
dotnet add src/YourProject.Web package Microsoft.EntityFrameworkCore.SqlServer

# Add package with specific version
dotnet add src/YourProject.Web package AutoMapper --version 12.0.1

# Remove package
dotnet remove src/YourProject.Web package AutoMapper

# List packages
dotnet list package

# List outdated packages
dotnet list package --outdated

# List vulnerable packages
dotnet list package --vulnerable

# Update packages
dotnet add src/YourProject.Web package Microsoft.EntityFrameworkCore.SqlServer --version 8.0.0
```

### Package Sources
```bash
# List package sources
dotnet nuget list source

# Add package source
dotnet nuget add source https://api.nuget.org/v3/index.json --name "NuGet"

# Remove package source
dotnet nuget remove source "NuGet"
```

## Publishing and Deployment Commands

### Application Publishing
```bash
# Publish application
dotnet publish src/YourProject.Web

# Publish in Release mode
dotnet publish src/YourProject.Web --configuration Release

# Publish for specific runtime
dotnet publish src/YourProject.Web --runtime win-x64

# Publish as single file
dotnet publish src/YourProject.Web --runtime win-x64 --self-contained true -p:PublishSingleFile=true

# Publish with ReadyToRun
dotnet publish src/YourProject.Web --runtime win-x64 -p:PublishReadyToRun=true

# Publish with trimming
dotnet publish src/YourProject.Web --runtime win-x64 --self-contained true -p:PublishTrimmed=true
```

### Container Publishing
```bash
# Publish as container
dotnet publish src/YourProject.Web --os linux --arch x64 -p:PublishProfile=DefaultContainer

# Publish with specific container tag
dotnet publish src/YourProject.Web -p:PublishProfile=DefaultContainer -p:ContainerImageTag=v1.0.0
```

## Code Quality and Analysis Commands

### Code Formatting
```bash
# Format code
dotnet format

# Verify formatting without changes
dotnet format --verify-no-changes

# Format specific files
dotnet format --include src/YourProject.Web/Controllers/

# Format with specific severity
dotnet format --severity error
```

### Code Analysis
```bash
# Run code analysis
dotnet build --verbosity normal

# Run specific analyzers
dotnet build -p:RunAnalyzersDuringBuild=true

# Treat warnings as errors
dotnet build -p:TreatWarningsAsErrors=true

# Run security analysis
dotnet list package --vulnerable
```

## Development Tools Commands

### Project and Solution Management
```bash
# Create new solution
dotnet new sln --name YourProject

# Add project to solution
dotnet sln add src/YourProject.Web/YourProject.Web.csproj

# Remove project from solution
dotnet sln remove src/YourProject.Web/YourProject.Web.csproj

# List solution projects
dotnet sln list

# Create new project
dotnet new webapi --name YourProject.Api --output src/YourProject.Api

# Add project reference
dotnet add src/YourProject.Web reference src/YourProject.Application
```

### User Secrets Management
```bash
# Initialize user secrets
dotnet user-secrets init --project src/YourProject.Web

# Set secret
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Server=localhost;Database=YourDb;Trusted_Connection=true;" --project src/YourProject.Web

# List secrets
dotnet user-secrets list --project src/YourProject.Web

# Remove secret
dotnet user-secrets remove "ConnectionStrings:DefaultConnection" --project src/YourProject.Web

# Clear all secrets
dotnet user-secrets clear --project src/YourProject.Web
```

## Performance and Diagnostics Commands

### Performance Profiling
```bash
# Install diagnostic tools
dotnet tool install --global dotnet-counters
dotnet tool install --global dotnet-trace
dotnet tool install --global dotnet-dump

# Monitor performance counters
dotnet-counters monitor --process-id <PID>

# Collect performance trace
dotnet-trace collect --process-id <PID>

# Create memory dump
dotnet-dump collect --process-id <PID>
```

### Application Insights
```bash
# Install Application Insights
dotnet add src/YourProject.Web package Microsoft.ApplicationInsights.AspNetCore

# Install Application Insights for Worker Services
dotnet add src/YourProject.Worker package Microsoft.ApplicationInsights.WorkerService
```

## Docker and Container Commands

### Docker Operations
```bash
# Build Docker image
docker build -t yourproject-web .

# Run Docker container
docker run -p 5000:8080 yourproject-web

# Docker compose up
docker-compose up -d

# Docker compose down
docker-compose down

# View logs
docker logs <container-id>
```

### .NET Container Tools
```bash
# Install container tools
dotnet tool install --global Microsoft.dotnet-docker

# Build container image
dotnet publish --os linux --arch x64 -p:PublishProfile=DefaultContainer
```

## Security Commands

### Security Scanning
```bash
# Audit packages for vulnerabilities
dotnet list package --vulnerable

# Check for deprecated packages
dotnet list package --deprecated

# Update to secure versions
dotnet add package <PackageName> --version <SecureVersion>
```

### Certificate Management
```bash
# Trust development certificates
dotnet dev-certs https --trust

# Clean development certificates
dotnet dev-certs https --clean

# Generate new certificates
dotnet dev-certs https --trust --force
```

## Debugging and Troubleshooting Commands

### Diagnostic Information
```bash
# Show .NET information
dotnet --info

# List installed SDKs
dotnet --list-sdks

# List installed runtimes
dotnet --list-runtimes

# Show project information
dotnet --info --project src/YourProject.Web
```

### Environment Information
```bash
# Show environment variables
dotnet run --project src/YourProject.Web --environment Development -- --environment-info

# Validate configuration
dotnet run --project src/YourProject.Web -- --validate-config
```

## CI/CD Integration Commands

### GitHub Actions
```bash
# Build command for CI
dotnet build --configuration Release --no-restore

# Test command for CI
dotnet test --configuration Release --no-build --verbosity normal --collect:"XPlat Code Coverage"

# Publish command for CI
dotnet publish src/YourProject.Web --configuration Release --no-build --output ./publish
```

### Azure DevOps
```bash
# Restore with locked mode
dotnet restore --locked-mode

# Build with specific logger
dotnet build --logger "AzurePipelines"

# Test with Azure DevOps logger
dotnet test --logger "AzurePipelines"
```

## Example Development Workflow

```bash
# 1. Start development session
dotnet restore
dotnet build

# 2. Run tests
dotnet test

# 3. Start application with hot reload
dotnet watch run --project src/YourProject.Web

# 4. Add new migration (in separate terminal)
dotnet ef migrations add AddNewFeature --project src/YourProject.Infrastructure

# 5. Update database
dotnet ef database update --project src/YourProject.Infrastructure

# 6. Format code before commit
dotnet format

# 7. Run final tests
dotnet test --configuration Release

# 8. Publish for deployment
dotnet publish src/YourProject.Web --configuration Release --runtime linux-x64
```

These commands provide comprehensive coverage of .NET Core 8 development workflows and can be integrated into your CLAUDE.md file for AI-assisted development.