# .NET Framework 4.7.2 to .NET Core Migration Context Template

Based on my analysis of the existing .NET Framework 4.7.2 and .NET Core 8 specialization files, a context for migrating from .NET Framework 4.7.2 to .NET Core should specify:

## Migration Context Requirements

### 1. **Framework Compatibility Assessment**
- Target framework upgrade: .NET Framework 4.7.2 → .NET Core 8
- C# language version: C# 7.3 → C# 12
- Runtime environment: Windows-only → Cross-platform
- Nullable reference types: Not available → Enabled by default

### 2. **Project Structure Transformation**
- Solution file: Traditional .csproj → Modern SDK-style projects
- Package management: packages.config → PackageReference
- Global using statements: Manual imports → Implicit usings enabled
- Build system: MSBuild + .NET Framework → .NET CLI + MSBuild

### 3. **API and Library Migrations**
- **Web Framework**: ASP.NET Web API 2 → ASP.NET Core 8 (Minimal APIs or Controllers)
- **ORM**: Entity Framework 6.x → Entity Framework Core 8
- **DI Container**: Autofac/Unity → Built-in .NET DI container
- **Configuration**: app.config/web.config → appsettings.json + User Secrets
- **Authentication**: ASP.NET Identity → ASP.NET Core Identity 8

### 4. **Code Pattern Updates**
- **Exception Handling**: Generic Exception → Specific exceptions + ProblemDetails
- **Async Patterns**: Basic async/await → ConfigureAwait(false) + modern patterns
- **Error Responses**: Custom error handling → ProblemDetails standard
- **Logging**: NLog/log4net → ILogger<T> with structured logging
- **Performance**: Traditional patterns → Spans, Memory<T>, and .NET 8 optimizations

### 5. **Configuration Management**
- **Files**: app.config/web.config → appsettings.json hierarchy
- **Secrets**: Encrypted configuration sections → User Secrets/Azure Key Vault
- **Environment**: Configuration transformations → Environment-specific files
- **Access**: ConfigurationManager → IConfiguration dependency injection

### 6. **Deployment and Infrastructure**
- **Hosting**: IIS → Kestrel with reverse proxy
- **Services**: Windows Services with TopShelf → BackgroundService
- **Containers**: Windows-only deployment → Docker containerization
- **Cloud**: On-premises focused → Cloud-native patterns

### 7. **Testing Framework Migration**
- **Framework**: NUnit/MSTest → xUnit (preferred for .NET Core)
- **Integration**: Custom test setup → WebApplicationFactory
- **Dependencies**: Real dependencies → TestContainers for integration tests
- **Mocking**: Moq compatibility maintained

### 8. **Security Updates**
- **Input Validation**: Manual validation → Data Annotations + FluentValidation
- **Authentication**: OWIN middleware → ASP.NET Core middleware pipeline
- **HTTPS**: Manual configuration → HTTPS by default
- **CORS**: Custom implementation → Built-in CORS middleware

### 9. **Performance Considerations**
- **Memory Management**: Manual disposal → Automatic using statements
- **Collections**: Traditional collections → Collection expressions []
- **String Operations**: StringBuilder patterns → Span<T> for performance-critical code
- **Database**: Synchronous patterns → Async-first patterns

### 10. **Breaking Changes to Address**
- **Binary Compatibility**: .NET Framework assemblies → Recompilation required
- **Windows-Specific APIs**: P/Invoke calls → Cross-platform alternatives
- **File Paths**: Windows path separators → Path.Combine() usage
- **Registry Access**: Windows Registry → Configuration files or environment variables

### 11. **Parallel Operation & Data Compatibility**

#### **Encryption Compatibility**
- **Shared Encryption Keys**: Both systems must use identical encryption algorithms and keys
- **Key Management**: Centralized key storage accessible to both .NET Framework and .NET Core systems
- **Algorithm Consistency**: 
  - .NET Framework: `System.Security.Cryptography` classes
  - .NET Core: Same algorithms via `System.Security.Cryptography` (maintained compatibility)
- **Data Format**: Encrypted data format must be identical between systems
- **Base64 Encoding**: Consistent encoding/decoding implementation

#### **Enum and Constants Preservation**
- **Enum Values**: Numeric values must remain unchanged during migration
- **Enum Names**: String representations must be identical
- **Enum Order**: Original declaration order must be preserved
- **Constants**: All constant values (strings, numbers) must remain identical
- **Serialization**: JSON/XML serialization must produce identical enum representations

```csharp
// CRITICAL: These values cannot change during migration
public enum OrderStatus
{
    Pending = 1,      // Cannot change to 0 or any other value
    Processing = 2,   // Cannot reorder
    Shipped = 3,      // Cannot rename
    Delivered = 4     // Cannot modify
}
```

#### **Wire-Level Protocol Compatibility**

##### **HTTP API Compatibility**
- **Endpoint URLs**: Identical route patterns and versioning
- **HTTP Methods**: Same verbs for same operations
- **Request/Response Models**: Binary-compatible JSON serialization
- **Content-Type Headers**: Consistent media type handling
- **Status Codes**: Identical HTTP response codes for same scenarios

##### **Message Queue Compatibility**
- **Message Format**: Identical serialization format (JSON/XML/Binary)
- **Queue Names**: Unchanged queue/topic naming
- **Message Headers**: Consistent metadata structure
- **Correlation IDs**: Same correlation ID generation and handling

##### **Database Wire Protocol**
- **Connection Strings**: Compatible connection parameters
- **SQL Compatibility**: Identical SQL dialect and syntax
- **Parameter Binding**: Same parameterized query behavior
- **Transaction Isolation**: Consistent isolation levels

#### **Serialization Compatibility**

##### **JSON Serialization**
- **.NET Framework**: Newtonsoft.Json settings preservation
- **.NET Core**: System.Text.Json with compatibility configuration
- **Date Formats**: Identical DateTime serialization patterns
- **Null Handling**: Consistent null value representation
- **Property Naming**: Same camelCase/PascalCase conventions

```csharp
// .NET Core configuration for compatibility
services.Configure<JsonOptions>(options =>
{
    options.SerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
    options.SerializerOptions.Converters.Add(new JsonStringEnumConverter());
    // Match .NET Framework DateTime format
    options.SerializerOptions.Converters.Add(new CustomDateTimeConverter());
});
```

#### **External Service Integration**

##### **Upstream Services**
- **Authentication Tokens**: Same token format and validation
- **API Contracts**: Identical request/response schemas
- **Error Handling**: Consistent error response interpretation
- **Retry Policies**: Same backoff and retry behavior

##### **Downstream Services**
- **Event Publishing**: Identical event schema and routing
- **Webhook Callbacks**: Same callback URL patterns and payloads
- **File Uploads**: Consistent multipart form data structure
- **Batch Processing**: Same batch size and processing patterns

#### **Configuration Compatibility**
- **Environment Variables**: Shared environment variable names and formats
- **Connection Strings**: Compatible database connection formats
- **Feature Flags**: Identical feature toggle behavior
- **Logging Levels**: Same log level interpretation

#### **Security Token Compatibility**
- **JWT Tokens**: Identical signing algorithms and claims structure
- **Session Tokens**: Same session management approach
- **API Keys**: Consistent API key validation logic
- **CSRF Tokens**: Compatible anti-forgery token handling

#### **Migration Validation Strategy**
- **Side-by-Side Testing**: Parallel processing with result comparison
- **Contract Testing**: Verify identical API behavior
- **Data Integrity Checks**: Validate encryption/decryption compatibility
- **Load Balancer Configuration**: Gradual traffic shifting between systems
- **Rollback Procedures**: Quick reversion to .NET Framework if compatibility issues arise

#### **Monitoring Compatibility Issues**
- **Response Time Parity**: Monitor performance differences
- **Error Rate Comparison**: Track error patterns between systems
- **Data Consistency Checks**: Validate identical processing results
- **External Service Logs**: Monitor upstream/downstream service interactions

This parallel operation phase is critical for ensuring zero data loss and maintaining business continuity during the migration process.