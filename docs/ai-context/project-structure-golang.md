# Go Project Structure & Technology Stack

This file provides comprehensive project structure and technology stack information for AI agents working with this Go application.

## Technology Stack

### Core Technologies
- **Go**: 1.21+ (or latest stable version)
- **Go Modules**: Dependency management
- **Standard Library**: Extensive use of Go's built-in packages
- **Build System**: Go toolchain (go build, go test, go mod)

### Web Framework
- **Gin**: Fast HTTP web framework (if applicable)
- **Echo**: High performance, minimalist web framework (if applicable)
- **Fiber**: Express-inspired web framework (if applicable)
- **Chi**: Lightweight, idiomatic router (if applicable)
- **Net/HTTP**: Standard library HTTP package

### Database & Storage
- **PostgreSQL**: Primary database (if applicable)
- **MySQL**: Alternative database (if applicable)
- **SQLite**: Embedded database for testing/development
- **Redis**: Caching and session storage
- **MongoDB**: Document database (if applicable)

### Database Libraries
- **database/sql**: Standard library database interface
- **pgx**: PostgreSQL driver and toolkit
- **GORM**: ORM library for Go
- **sqlx**: Extensions to database/sql
- **Ent**: Entity framework for Go

### Authentication & Security
- **JWT**: JSON Web Tokens for authentication
- **bcrypt**: Password hashing
- **OAuth2**: Third-party authentication
- **TLS**: Transport layer security
- **CORS**: Cross-origin resource sharing

### Configuration & Environment
- **Viper**: Configuration management
- **godotenv**: Environment variable loading
- **env**: Environment variable parsing
- **flag**: Command-line flag parsing

### Logging & Monitoring
- **slog**: Structured logging (Go 1.21+)
- **Zap**: Fast, structured logging
- **Logrus**: Structured logger
- **Prometheus**: Metrics collection
- **OpenTelemetry**: Distributed tracing

### Testing Framework
- **testing**: Standard library testing
- **Testify**: Testing toolkit with assertions
- **GoMock**: Mock generation
- **Ginkgo**: BDD testing framework
- **Gomega**: Matcher library

### Development Tools
- **Go Toolchain**: go build, go test, go mod, go fmt, go vet
- **golangci-lint**: Comprehensive linter
- **govulncheck**: Security vulnerability scanner
- **go-migrate**: Database migration tool
- **Air**: Live reload for Go apps

### Build & Deployment
- **Docker**: Containerization
- **Kubernetes**: Container orchestration
- **GitHub Actions**: CI/CD pipeline
- **Makefile**: Build automation
- **Goreleaser**: Release automation

## Project Structure

```
myproject/
├── cmd/                                     # Main applications
│   ├── server/                              # HTTP server application
│   │   └── main.go                          # Server entry point
│   ├── worker/                              # Background worker application
│   │   └── main.go                          # Worker entry point
│   └── cli/                                 # CLI application
│       └── main.go                          # CLI entry point
├── internal/                                # Private application code
│   ├── config/                              # Configuration management
│   │   ├── config.go                        # Configuration struct and loading
│   │   └── CONTEXT.md                       # Configuration documentation
│   ├── handler/                             # HTTP handlers
│   │   ├── user.go                          # User-related handlers
│   │   ├── auth.go                          # Authentication handlers
│   │   ├── health.go                        # Health check handlers
│   │   └── CONTEXT.md                       # Handler documentation
│   ├── service/                             # Business logic
│   │   ├── user.go                          # User service
│   │   ├── auth.go                          # Authentication service
│   │   ├── notification.go                  # Notification service
│   │   └── CONTEXT.md                       # Service documentation
│   ├── repository/                          # Data access layer
│   │   ├── user.go                          # User repository
│   │   ├── session.go                       # Session repository
│   │   ├── interfaces.go                    # Repository interfaces
│   │   └── CONTEXT.md                       # Repository documentation
│   ├── model/                               # Data models
│   │   ├── user.go                          # User model
│   │   ├── session.go                       # Session model
│   │   └── CONTEXT.md                       # Model documentation
│   ├── middleware/                          # HTTP middleware
│   │   ├── auth.go                          # Authentication middleware
│   │   ├── logging.go                       # Logging middleware
│   │   ├── cors.go                          # CORS middleware
│   │   └── CONTEXT.md                       # Middleware documentation
│   ├── database/                            # Database related code
│   │   ├── postgres.go                      # PostgreSQL connection
│   │   ├── migrations/                      # Database migrations
│   │   │   ├── 001_create_users.up.sql
│   │   │   ├── 001_create_users.down.sql
│   │   │   └── 002_create_sessions.up.sql
│   │   └── CONTEXT.md                       # Database documentation
│   ├── cache/                               # Caching layer
│   │   ├── redis.go                         # Redis client
│   │   ├── memory.go                        # In-memory cache
│   │   └── CONTEXT.md                       # Cache documentation
│   ├── queue/                               # Message queue
│   │   ├── publisher.go                     # Message publisher
│   │   ├── consumer.go                      # Message consumer
│   │   └── CONTEXT.md                       # Queue documentation
│   ├── auth/                                # Authentication logic
│   │   ├── jwt.go                           # JWT handling
│   │   ├── password.go                      # Password utilities
│   │   └── CONTEXT.md                       # Auth documentation
│   ├── validation/                          # Input validation
│   │   ├── user.go                          # User validation
│   │   ├── common.go                        # Common validators
│   │   └── CONTEXT.md                       # Validation documentation
│   └── worker/                              # Background workers
│       ├── email.go                         # Email worker
│       ├── cleanup.go                       # Cleanup worker
│       └── CONTEXT.md                       # Worker documentation
├── pkg/                                     # Public library code
│   ├── httputil/                            # HTTP utilities
│   │   ├── response.go                      # HTTP response helpers
│   │   ├── request.go                       # HTTP request helpers
│   │   └── CONTEXT.md                       # HTTP util documentation
│   ├── logger/                              # Logging utilities
│   │   ├── logger.go                        # Logger setup
│   │   ├── middleware.go                    # Logging middleware
│   │   └── CONTEXT.md                       # Logger documentation
│   ├── database/                            # Database utilities
│   │   ├── connection.go                    # Database connection helpers
│   │   ├── transaction.go                   # Transaction helpers
│   │   └── CONTEXT.md                       # Database util documentation
│   ├── config/                              # Configuration utilities
│   │   ├── env.go                           # Environment variable helpers
│   │   ├── validation.go                    # Config validation
│   │   └── CONTEXT.md                       # Config util documentation
│   └── errors/                              # Error handling utilities
│       ├── errors.go                        # Custom error types
│       ├── handler.go                       # Error handlers
│       └── CONTEXT.md                       # Error util documentation
├── api/                                     # API definitions
│   ├── openapi/                             # OpenAPI specifications
│   │   └── swagger.yaml                     # API specification
│   ├── proto/                               # Protocol buffer definitions
│   │   └── user.proto                       # User service proto
│   └── CONTEXT.md                           # API documentation
├── web/                                     # Web assets
│   ├── static/                              # Static files
│   │   ├── css/
│   │   ├── js/
│   │   └── images/
│   ├── templates/                           # HTML templates
│   │   ├── index.html
│   │   └── login.html
│   └── CONTEXT.md                           # Web documentation
├── configs/                                 # Configuration files
│   ├── config.yaml                          # Main configuration
│   ├── config.dev.yaml                      # Development config
│   ├── config.prod.yaml                     # Production config
│   └── CONTEXT.md                           # Config documentation
├── scripts/                                 # Build and deployment scripts
│   ├── build.sh                             # Build script
│   ├── test.sh                              # Test script
│   ├── deploy.sh                            # Deployment script
│   ├── migrate.sh                           # Migration script
│   └── CONTEXT.md                           # Scripts documentation
├── deployments/                             # Deployment configurations
│   ├── docker/                              # Docker configurations
│   │   ├── Dockerfile                       # Main Dockerfile
│   │   ├── Dockerfile.dev                   # Development Dockerfile
│   │   └── docker-compose.yml               # Docker Compose
│   ├── kubernetes/                          # Kubernetes manifests
│   │   ├── deployment.yaml                  # Deployment manifest
│   │   ├── service.yaml                     # Service manifest
│   │   ├── ingress.yaml                     # Ingress manifest
│   │   └── configmap.yaml                   # ConfigMap manifest
│   └── CONTEXT.md                           # Deployment documentation
├── test/                                    # Test files
│   ├── integration/                         # Integration tests
│   │   ├── user_test.go                     # User integration tests
│   │   ├── auth_test.go                     # Auth integration tests
│   │   └── CONTEXT.md                       # Integration test docs
│   ├── fixtures/                            # Test fixtures
│   │   ├── users.json                       # User test data
│   │   └── sessions.json                    # Session test data
│   ├── mocks/                               # Mock implementations
│   │   ├── user_repository.go               # Mock user repository
│   │   └── notification_service.go          # Mock notification service
│   └── CONTEXT.md                           # Test documentation
├── docs/                                    # Documentation
│   ├── ai-context/                          # AI context documentation
│   │   ├── project-structure.md             # This file
│   │   ├── docs-overview.md                 # Documentation overview
│   │   ├── system-integration.md            # System integration
│   │   ├── deployment-infrastructure.md     # Deployment infrastructure
│   │   └── handoff.md                       # Handoff documentation
│   ├── architecture/                        # Architecture documentation
│   │   ├── overview.md                      # Architecture overview
│   │   ├── database-design.md               # Database design
│   │   ├── api-design.md                    # API design
│   │   └── security.md                      # Security documentation
│   ├── development/                         # Development guides
│   │   ├── setup.md                         # Development setup
│   │   ├── testing.md                       # Testing guide
│   │   ├── debugging.md                     # Debugging guide
│   │   └── contributing.md                  # Contributing guide
│   └── CONTEXT.md                           # Docs documentation
├── tools/                                   # Development tools
│   ├── generate.go                          # Code generation
│   ├── migrate/                             # Migration tools
│   │   └── main.go                          # Migration utility
│   └── CONTEXT.md                           # Tools documentation
├── .github/                                 # GitHub configuration
│   ├── workflows/                           # GitHub Actions
│   │   ├── ci.yml                           # Continuous integration
│   │   ├── cd.yml                           # Continuous deployment
│   │   └── security.yml                     # Security scanning
│   └── ISSUE_TEMPLATE/                      # Issue templates
│       ├── bug_report.md                    # Bug report template
│       └── feature_request.md               # Feature request template
├── go.mod                                   # Go module file
├── go.sum                                   # Go module checksums
├── Makefile                                 # Build automation
├── .env.example                             # Environment variables example
├── .gitignore                               # Git ignore file
├── .golangci.yml                            # Linter configuration
├── README.md                                # Project documentation
├── CHANGELOG.md                             # Change log
├── LICENSE                                  # License file
└── CLAUDE.md                                # AI context file
```

## Key Directory Purposes

### Application Entry Points
- **cmd/**: Contains main applications with different entry points
- **internal/**: Private application code that cannot be imported by other projects
- **pkg/**: Public library code that can be imported by other projects

### Business Logic Organization
- **service/**: Business logic and use cases
- **repository/**: Data access layer and database operations
- **model/**: Data structures and domain models
- **handler/**: HTTP request handlers and API endpoints

### Infrastructure Components
- **middleware/**: HTTP middleware for cross-cutting concerns
- **database/**: Database connection and migration management
- **cache/**: Caching layer implementations
- **queue/**: Message queue and background processing

### Configuration and Deployment
- **configs/**: Configuration files for different environments
- **deployments/**: Docker and Kubernetes deployment configurations
- **scripts/**: Build, test, and deployment scripts

## Go Module Structure

### Module Dependencies
```go
module myproject

go 1.21

require (
    github.com/gin-gonic/gin v1.9.1
    github.com/lib/pq v1.10.9
    github.com/golang-jwt/jwt/v5 v5.0.0
    github.com/redis/go-redis/v9 v9.0.5
    github.com/spf13/viper v1.16.0
    go.uber.org/zap v1.24.0
)

require (
    // Indirect dependencies...
)
```

### Module Organization
- **Main Module**: Contains the application code
- **Sub-modules**: For large projects, consider using Go workspaces
- **Private Modules**: Use internal/ for private packages
- **Public Modules**: Use pkg/ for reusable packages

## Development Workflow

### Common Commands
```bash
# Module management
go mod init myproject
go mod tidy
go mod download
go mod verify

# Building
go build ./cmd/server
go build -o bin/server ./cmd/server

# Testing
go test ./...
go test -race ./...
go test -cover ./...
go test -bench ./...

# Code quality
go fmt ./...
go vet ./...
golangci-lint run
govulncheck ./...

# Running
go run ./cmd/server
go run ./cmd/worker
```

### Build Tags and Constraints
```go
//go:build integration
// +build integration

package integration

// Integration tests
```

### Code Generation
```go
//go:generate go run github.com/golang/mock/mockgen -source=interfaces.go -destination=mocks/mock_interfaces.go
//go:generate go run github.com/99designs/gqlgen generate
```

## Environment Configuration

### Development Setup
```bash
# Set up development environment
export GO111MODULE=on
export GOPROXY=https://proxy.golang.org
export GOPRIVATE=github.com/yourorg/*
export CGO_ENABLED=0
```

### Build Configuration
```bash
# Build flags
go build -ldflags="-w -s" -o bin/server ./cmd/server

# Cross compilation
GOOS=linux GOARCH=amd64 go build -o bin/server-linux ./cmd/server
GOOS=darwin GOARCH=amd64 go build -o bin/server-darwin ./cmd/server
GOOS=windows GOARCH=amd64 go build -o bin/server.exe ./cmd/server
```

## Testing Structure

### Test Organization
- **Unit Tests**: Located alongside source code (*_test.go)
- **Integration Tests**: Located in test/integration/
- **Benchmark Tests**: Use testing.B for performance tests
- **Fuzz Tests**: Use testing.F for fuzz testing

### Test Naming Conventions
```go
func TestUserService_GetUser(t *testing.T)     // Unit test
func TestUserService_GetUser_Integration(t *testing.T)  // Integration test
func BenchmarkUserService_GetUser(b *testing.B)        // Benchmark test
func FuzzUserService_ValidateEmail(f *testing.F)       // Fuzz test
```

## Dependency Management

### Go Modules Best Practices
- Pin major versions for stability
- Use semantic versioning
- Regular dependency updates
- Vulnerability scanning
- Vendor directory only when necessary

### Version Management
```bash
# Update dependencies
go get -u ./...

# Update specific dependency
go get -u github.com/gin-gonic/gin

# Add dependency with specific version
go get github.com/redis/go-redis/v9@v9.0.5
```

## Performance Considerations

### Profiling
```go
import _ "net/http/pprof"

// Enable profiling endpoint
go func() {
    log.Println(http.ListenAndServe("localhost:6060", nil))
}()
```

### Optimization Techniques
- Use goroutines for concurrent operations
- Implement connection pooling
- Use buffered channels appropriately
- Minimize memory allocations
- Use sync.Pool for object reuse

This structure follows Go best practices and provides a solid foundation for scalable Go applications.