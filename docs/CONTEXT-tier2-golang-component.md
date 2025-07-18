# [Component Name] - Go Component Context

## Purpose
[Brief description of what this component does and why it exists]

## Current Status: [Active Development/Stable/Deprecated]
[Current development phase and any important status notes]

## Component-Specific Go Development Guidelines

### Go Package Design
- Follow Go package naming conventions (lowercase, concise, descriptive)
- Keep package interface minimal and focused
- Use meaningful package names that reflect functionality
- Avoid deep package hierarchies - prefer flat structure

### Interface and API Design
- Define small, focused interfaces following Go's "interface segregation" principle
- Use io.Reader, io.Writer, and other standard interfaces where appropriate
- Return errors as the last return value
- Use context.Context for cancellation and timeouts

### Concurrency Patterns
- Use goroutines for concurrent operations
- Implement proper goroutine lifecycle management
- Use channels for communication between goroutines
- Avoid goroutine leaks with proper cleanup
- Use sync package primitives when appropriate

### Error Handling
- Return detailed error information using fmt.Errorf with %w verb
- Use custom error types for specific error conditions
- Handle errors at the appropriate level
- Use errors.Is() and errors.As() for error checking

### Performance Considerations
- Use sync.Pool for object reuse when appropriate
- Implement proper resource management with defer statements
- Use buffered channels appropriately
- Consider memory allocation patterns

## Major Subsystem Organization

### Core Packages
- **[package1]**: [Description of primary functionality]
- **[package2]**: [Description of secondary functionality]
- **[package3]**: [Description of utility functions]

### Key Types and Interfaces
```go
// Example interface definition
type ComponentInterface interface {
    Process(ctx context.Context, input []byte) ([]byte, error)
    Close() error
}

// Example struct
type ComponentConfig struct {
    MaxWorkers int           `json:"max_workers"`
    Timeout    time.Duration `json:"timeout"`
    BufferSize int           `json:"buffer_size"`
}
```

### Testing Structure
- Unit tests: `*_test.go` files alongside source code
- Integration tests: `integration_test.go` with build tags
- Benchmark tests: `BenchmarkFunctionName` functions
- Test fixtures: `testdata/` directory for test data

## Integration Points

### Internal Dependencies
- **[internal package 1]**: [How this component uses it]
- **[internal package 2]**: [Integration details]

### External Dependencies
- **[external library 1]**: [Purpose and usage]
- **[external library 2]**: [Integration details]

### Database/Storage
- **Connection Pool**: [Database connection management]
- **Repositories**: [Data access patterns]
- **Transactions**: [Transaction handling approach]

### Configuration
- **Environment Variables**: [List key env vars]
- **Config Files**: [Configuration file locations and format]
- **Feature Flags**: [Any feature toggles or flags]

## Development Workflows

### Local Development
```bash
# Start development environment
go run ./cmd/[component-name]

# Run tests
go test ./...

# Run with race detection
go test -race ./...

# Run benchmarks
go test -bench=.

# Generate code (if applicable)
go generate ./...
```

### Build and Deployment
```bash
# Build for production
CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o bin/[component-name] ./cmd/[component-name]

# Cross-platform builds
GOOS=darwin GOARCH=amd64 go build -o bin/[component-name]-darwin ./cmd/[component-name]
GOOS=windows GOARCH=amd64 go build -o bin/[component-name].exe ./cmd/[component-name]
```

### Code Quality
```bash
# Format code
go fmt ./...

# Lint code
golangci-lint run

# Static analysis
go vet ./...

# Security scan
govulncheck ./...

# Generate coverage report
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
```

## Performance Characteristics

### Expected Performance
- **Throughput**: [Expected requests/operations per second]
- **Latency**: [Expected response times]
- **Memory Usage**: [Expected memory footprint]
- **CPU Usage**: [Expected CPU utilization]

### Monitoring and Profiling
- **Metrics**: [Key metrics to monitor]
- **Logging**: [Important log messages and levels]
- **Profiling**: [pprof endpoints and usage]
- **Health Checks**: [Health check endpoints]

## Security Considerations

### Input Validation
- Validate all external inputs at package boundaries
- Use appropriate data types and constraints
- Sanitize inputs to prevent injection attacks

### Error Handling
- Don't expose internal details in error messages
- Log security-relevant events appropriately
- Use structured logging for audit trails

### Resource Management
- Implement proper cleanup of resources
- Use context for request timeouts and cancellation
- Protect against resource exhaustion attacks

## Recent Changes & Evolution

### Version History
- **v1.0.0**: [Initial release with core functionality]
- **v1.1.0**: [Added feature X, improved performance]
- **v1.2.0**: [Breaking change Y, migration guide]

### Migration Notes
- [Important changes that affect other components]
- [Breaking changes and how to handle them]
- [Deprecated features and alternatives]

## Troubleshooting

### Common Issues
- **High Memory Usage**: [Diagnosis and solutions]
- **Goroutine Leaks**: [How to detect and fix]
- **Performance Degradation**: [Common causes and fixes]

### Debug Information
- **Logging**: [How to enable debug logging]
- **Profiling**: [How to collect profiles]
- **Metrics**: [Key metrics to check]

### Error Messages
- **Error Type A**: [Meaning and solution]
- **Error Type B**: [Meaning and solution]

## Future Roadmap

### Planned Features
- [Feature 1]: [Description and timeline]
- [Feature 2]: [Description and timeline]

### Known Limitations
- [Limitation 1]: [Description and potential solutions]
- [Limitation 2]: [Description and workarounds]

### Technical Debt
- [Item 1]: [Description and priority]
- [Item 2]: [Description and impact]

---

*Last updated: [Date]*
*Component version: [Version]*
*Go version: [Minimum Go version required]*