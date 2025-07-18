# [PROJECT NAME] - .NET Core 8 AI Context

This file provides guidance to Claude Code (claude.ai/code) when working with this .NET Core 8 C# project.

## 1. Project Overview
- **Vision:** [Describe your project's vision and goals]
- **Current Phase:** [Current development phase and status]
- **Key Architecture:** Modern .NET Core 8 application with [specify architecture pattern]
- **Development Strategy:** [Development approach and strategy notes]

## 2. Project Structure

**⚠️ CRITICAL: AI agents MUST read the [Project Structure documentation](/docs/ai-context/project-structure.md) before attempting any task to understand the complete technology stack, file tree and project organization.**

This .NET Core 8 project follows modern .NET conventions and clean architecture principles. For the complete tech stack and file tree structure, see [docs/ai-context/project-structure.md](/docs/ai-context/project-structure.md).

## 3. .NET Core 8 Coding Standards & AI Instructions

### General Instructions
- Follow Microsoft's .NET 8 coding conventions and C# 12 language features
- Use modern C# features: primary constructors, collection expressions, required members
- Leverage .NET 8 performance improvements and new APIs
- Apply defensive security practices throughout the codebase
- Use minimal APIs for lightweight services
- Implement proper async/await patterns with ConfigureAwait(false)
- Never commit secrets to git - use User Secrets, Key Vault, or environment variables

### File Organization & Solution Structure
- Use .NET 8 project templates and modern project structure
- Organize code into logical projects with clear separation of concerns
- Follow clean architecture principles: Domain, Application, Infrastructure, Presentation
- Use meaningful folder structures aligned with .NET conventions
- Implement proper dependency injection with built-in DI container
- Use global using statements to reduce code repetition

### .NET Core 8 Specific Features
- **Native AOT**: Design for AOT compatibility when applicable
- **Minimal APIs**: Use for lightweight HTTP APIs
- **Source Generators**: Leverage for compile-time code generation
- **Performance**: Utilize .NET 8 performance improvements
- **Observability**: Use built-in OpenTelemetry support
- **Container Support**: Optimize for containerized deployments

### Naming Conventions (Microsoft Standards)
- **Namespaces**: PascalCase following folder structure (e.g., `MyApp.Domain.Entities`)
- **Classes/Interfaces**: PascalCase (e.g., `CustomerService`, `IRepository<T>`)
- **Methods/Properties**: PascalCase (e.g., `GetCustomerByIdAsync`, `FirstName`)
- **Fields**: camelCase with underscore prefix for private (e.g., `_logger`, `_connectionString`)
- **Constants**: PascalCase (e.g., `MaxRetryAttempts`, `DefaultTimeout`)
- **Parameters/Variables**: camelCase (e.g., `customerId`, `cancellationToken`)
- **Generic Type Parameters**: Single uppercase letter with T prefix (e.g., `T`, `TEntity`, `TResponse`)

### Type System & Modern C# Features
- **Nullable Reference Types**: Enabled by default, use proper null handling
- **Primary Constructors**: Use for simple classes and records
- **Collection Expressions**: Use `[]` syntax for collections
- **Required Members**: Use `required` keyword for mandatory properties
- **Records**: Use for immutable data structures
- **Pattern Matching**: Leverage switch expressions and pattern matching
- **Spans and Memory**: Use for high-performance scenarios

### Documentation Requirements
- Use XML documentation comments for all public APIs
- Include `<summary>`, `<param>`, `<returns>`, `<exception>` tags
- Document complex business logic and architectural decisions
- Use `<remarks>` for additional context and examples
- Follow .NET XML documentation standards

### Error Handling & Logging
- Use structured logging with `ILogger<T>` and proper log levels
- Implement proper exception handling with specific exception types
- Use `ProblemDetails` for API error responses
- Implement global exception handling middleware
- Use `Result<T>` pattern for business logic error handling
- Log with structured data for observability

### Security Best Practices
- Use ASP.NET Core Identity for authentication
- Implement proper authorization with policies
- Validate all user inputs with Data Annotations or FluentValidation
- Use HTTPS everywhere with proper certificate management
- Implement proper CORS policies
- Use parameterized queries or Entity Framework Core
- Implement rate limiting and request throttling
- Use secure configuration management (Key Vault, User Secrets)

### Performance & Scalability
- Use async/await throughout with proper ConfigureAwait usage
- Implement proper caching strategies (Memory, Distributed, Response)
- Use connection pooling and proper resource disposal
- Leverage .NET 8 performance improvements
- Implement proper pagination for large datasets
- Use minimal APIs for lightweight services
- Consider Native AOT for cold start optimization

### Testing Standards
- Use xUnit as the primary testing framework
- Implement unit tests with proper isolation
- Use integration tests for API endpoints
- Implement proper test data management
- Use TestContainers for integration testing with real dependencies
- Follow AAA pattern (Arrange, Act, Assert)
- Use meaningful test names that describe behavior

### Dependency Injection & Configuration
- Use built-in .NET DI container
- Register services with appropriate lifetimes
- Use configuration binding with strongly-typed options
- Implement proper configuration validation
- Use environment-specific configuration
- Leverage .NET 8 Keyed Services for multiple implementations

### API Design Principles
- Follow RESTful conventions with proper HTTP methods
- Use consistent response formats with `ProblemDetails`
- Implement proper versioning strategy
- Use OpenAPI/Swagger for documentation
- Implement proper content negotiation
- Use minimal APIs for simple endpoints
- Implement proper HTTP status codes

### Data Access Patterns
- Use Entity Framework Core 8 as primary ORM
- Implement proper DbContext configuration
- Use migrations for database schema management
- Implement proper connection string management
- Use repository pattern when needed
- Implement proper query optimization
- Use projection for read-only queries

### Observability & Monitoring
- Use built-in OpenTelemetry support
- Implement structured logging with proper correlation IDs
- Use health checks for service monitoring
- Implement proper metrics collection
- Use distributed tracing for microservices
- Monitor performance with Application Insights

## 4. Multi-Agent Workflows & Context Injection

### Automatic Context Injection for Sub-Agents
When using the Task tool to spawn sub-agents, the core project context (CLAUDE.md, project-structure.md, docs-overview.md) is automatically injected into their prompts via the subagent-context-injector hook. This ensures all sub-agents have immediate access to essential .NET Core 8 project documentation.

## 5. MCP Server Integrations

### Context7 Integration for .NET
**When to use:**
- Working with .NET Core 8 APIs and new features
- Implementing ASP.NET Core patterns
- Entity Framework Core 8 integration
- Azure services integration
- Third-party NuGet packages

**Usage patterns:**
```csharp
// Get current .NET 8 documentation
mcp__context7__resolve_library_id(libraryName=".NET")
mcp__context7__get_library_docs(
    context7CompatibleLibraryID="/dotnet/core",
    topic="minimal-apis",
    tokens=8000
)
```

### Gemini Consultation for .NET Architecture
**When to use:**
- Complex .NET architecture decisions
- Performance optimization strategies
- Security implementation patterns
- Microservices design with .NET
- Cloud-native .NET applications

## 6. Post-Task Completion Protocol

### .NET Specific Quality Checks
After completing any coding task:

1. **Build and Type Safety**
   ```bash
   dotnet build
   dotnet build --configuration Release
   ```

2. **Code Analysis**
   ```bash
   dotnet format --verify-no-changes
   dotnet analyze
   ```

3. **Testing**
   ```bash
   dotnet test
   dotnet test --collect:"XPlat Code Coverage"
   ```

4. **Security Scanning**
   ```bash
   dotnet list package --vulnerable
   dotnet audit
   ```

### Verification Checklist
- [ ] All compiler warnings resolved
- [ ] Code analysis rules passing
- [ ] Unit tests passing with good coverage
- [ ] No security vulnerabilities in dependencies
- [ ] Proper async/await usage
- [ ] Nullable reference types handled correctly
- [ ] Performance considerations addressed