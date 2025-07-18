# [PROJECT NAME] - Go AI Context

This file provides guidance to Claude Code (claude.ai/code) when working with this Go project.

## 1. Project Overview
- **Vision:** [Describe your project's vision and goals]
- **Current Phase:** [Current development phase and status]
- **Key Architecture:** Modern Go application with [specify architecture pattern]
- **Development Strategy:** [Development approach and strategy notes]

## 2. Project Structure

**⚠️ CRITICAL: AI agents MUST read the [Project Structure documentation](/docs/ai-context/project-structure.md) before attempting any task to understand the complete technology stack, file tree and project organization.**

This Go project follows standard Go conventions and best practices. For the complete tech stack and file tree structure, see [docs/ai-context/project-structure.md](/docs/ai-context/project-structure.md).

## 3. Go Coding Standards & AI Instructions

### General Instructions
- Follow Go conventions and idiomatic Go patterns
- Use effective Go practices from the Go team
- Leverage Go's built-in concurrency primitives (goroutines, channels)
- Apply defensive programming with proper error handling
- Use Go modules for dependency management
- Never commit secrets to git - use environment variables or configuration files
- Follow the principle of "Don't communicate by sharing memory; share memory by communicating"

### File Organization & Project Structure
- Use standard Go project layout (cmd/, pkg/, internal/, etc.)
- Organize code into logical packages with clear responsibilities
- Keep packages focused and cohesive
- Use internal/ for private packages
- Place main packages in cmd/ directory
- Use descriptive package names that reflect their purpose

### Go Language Best Practices
- **Error Handling**: Always check and handle errors explicitly
- **Goroutines**: Use goroutines for concurrent operations, avoid goroutine leaks
- **Channels**: Use channels for communication between goroutines
- **Interfaces**: Define small, focused interfaces
- **Composition**: Prefer composition over inheritance
- **Zero Values**: Design types to have useful zero values
- **Context**: Use context.Context for cancellation and timeouts

### Naming Conventions (Go Standards)
- **Packages**: Short, concise, lowercase names (e.g., `http`, `user`, `auth`)
- **Types**: PascalCase for exported, camelCase for unexported (e.g., `UserService`, `httpClient`)
- **Functions/Methods**: PascalCase for exported, camelCase for unexported (e.g., `GetUser`, `validateInput`)
- **Variables**: camelCase, meaningful names (e.g., `userCount`, `httpClient`)
- **Constants**: PascalCase for exported, camelCase for unexported (e.g., `MaxRetries`, `defaultTimeout`)
- **Interfaces**: Usually end with -er (e.g., `Reader`, `Writer`, `UserFinder`)

### Modern Go Features
- **Generics**: Use Go 1.18+ generics for type-safe, reusable code
- **Modules**: Use Go modules for dependency management
- **Workspaces**: Use Go workspaces for multi-module projects
- **Embed**: Use go:embed for embedding files
- **Build Constraints**: Use build tags for conditional compilation
- **Fuzzing**: Use Go's built-in fuzzing for testing

### Documentation Requirements
- Use Go doc comments for all exported types, functions, and variables
- Write clear, concise comments that explain "why" not "what"
- Use complete sentences starting with the name being documented
- Include examples in doc comments when helpful
- Follow Go documentation conventions

### Error Handling & Logging
- Return errors as the last return value
- Use fmt.Errorf for simple error wrapping
- Use custom error types for specific error conditions
- Use structured logging with slog (Go 1.21+) or popular libraries
- Log at appropriate levels (Debug, Info, Warn, Error)
- Include context in log messages

### Security Best Practices
- Validate all inputs at boundaries
- Use crypto/rand for cryptographic random numbers
- Implement proper authentication and authorization
- Use HTTPS everywhere with proper TLS configuration
- Sanitize user inputs to prevent injection attacks
- Use environment variables for secrets
- Implement rate limiting and request throttling
- Use Go's built-in security features

### Performance & Concurrency
- Use goroutines for concurrent operations
- Implement proper goroutine lifecycle management
- Use channels for communication between goroutines
- Avoid goroutine leaks with proper cleanup
- Use sync package primitives when appropriate
- Implement proper context cancellation
- Use pprof for performance profiling

### Testing Standards
- Write table-driven tests
- Use testing.T for unit tests
- Use testify for assertions (if preferred)
- Implement benchmarks with testing.B
- Use fuzzing with testing.F
- Follow arrange-act-assert pattern
- Use meaningful test names that describe behavior

### Dependency Management
- Use Go modules (go.mod, go.sum)
- Pin dependency versions for reproducible builds
- Use go mod tidy to clean dependencies
- Avoid vendor directory unless necessary
- Use semantic versioning for your modules
- Keep dependencies minimal and up-to-date

### Build & Deployment
- Use go build for compilation
- Use build tags for conditional compilation
- Implement proper cross-compilation
- Use Docker multi-stage builds
- Implement proper CI/CD pipelines
- Use go:embed for static assets

### Code Quality
- Use go fmt for code formatting
- Use go vet for static analysis
- Use golangci-lint for comprehensive linting
- Use go mod verify for dependency verification
- Run tests with race detection
- Use go tool cover for test coverage

## 4. Multi-Agent Workflows & Context Injection

### Automatic Context Injection for Sub-Agents
When using the Task tool to spawn sub-agents, the core project context (CLAUDE.md, project-structure.md, docs-overview.md) is automatically injected into their prompts via the subagent-context-injector hook. This ensures all sub-agents have immediate access to essential Go project documentation.

## 5. MCP Server Integrations

### Context7 Integration for Go
**When to use:**
- Working with Go standard library and third-party packages
- Implementing Go-specific patterns and idioms
- Working with Go frameworks (Gin, Echo, Fiber, etc.)
- Database integration with Go ORMs
- Cloud-native Go applications

**Usage patterns:**
```go
// Get current Go documentation
mcp__context7__resolve_library_id(libraryName="go")
mcp__context7__get_library_docs(
    context7CompatibleLibraryID="/golang/go",
    topic="concurrency",
    tokens=8000
)
```

### Gemini Consultation for Go Architecture
**When to use:**
- Complex Go architecture decisions
- Concurrency patterns and goroutine management
- Performance optimization strategies
- Microservices design with Go
- Cloud-native Go applications

## 6. Post-Task Completion Protocol

### Go Specific Quality Checks
After completing any coding task:

1. **Build and Format**
   ```bash
   go fmt ./...
   go build ./...
   ```

2. **Static Analysis**
   ```bash
   go vet ./...
   golangci-lint run
   ```

3. **Testing**
   ```bash
   go test ./...
   go test -race ./...
   go test -cover ./...
   ```

4. **Security and Dependencies**
   ```bash
   go mod verify
   go mod tidy
   govulncheck ./...
   ```

### Verification Checklist
- [ ] Code follows Go conventions and formatting
- [ ] All tests pass including race condition tests
- [ ] No security vulnerabilities in dependencies
- [ ] Proper error handling implemented
- [ ] Goroutines properly managed (no leaks)
- [ ] Documentation updated for exported functions
- [ ] Performance considerations addressed

## 7. Go-Specific Development Patterns

### Error Handling Pattern
```go
func ProcessUser(id int) (*User, error) {
    user, err := getUserFromDB(id)
    if err != nil {
        return nil, fmt.Errorf("failed to get user %d: %w", id, err)
    }
    
    if err := validateUser(user); err != nil {
        return nil, fmt.Errorf("user validation failed: %w", err)
    }
    
    return user, nil
}
```

### Concurrency Pattern
```go
func ProcessUsers(ctx context.Context, users []User) error {
    const maxWorkers = 10
    jobs := make(chan User, len(users))
    results := make(chan error, len(users))
    
    // Start workers
    for i := 0; i < maxWorkers; i++ {
        go worker(ctx, jobs, results)
    }
    
    // Send jobs
    for _, user := range users {
        jobs <- user
    }
    close(jobs)
    
    // Collect results
    for i := 0; i < len(users); i++ {
        if err := <-results; err != nil {
            return err
        }
    }
    
    return nil
}
```

### Interface Pattern
```go
type UserRepository interface {
    GetUser(ctx context.Context, id int) (*User, error)
    SaveUser(ctx context.Context, user *User) error
}

type UserService struct {
    repo UserRepository
}

func (s *UserService) ProcessUser(ctx context.Context, id int) error {
    user, err := s.repo.GetUser(ctx, id)
    if err != nil {
        return fmt.Errorf("failed to get user: %w", err)
    }
    
    // Process user...
    
    return s.repo.SaveUser(ctx, user)
}
```

### HTTP Handler Pattern
```go
func (h *Handler) GetUser(w http.ResponseWriter, r *http.Request) {
    ctx := r.Context()
    
    id, err := strconv.Atoi(r.URL.Query().Get("id"))
    if err != nil {
        http.Error(w, "invalid user ID", http.StatusBadRequest)
        return
    }
    
    user, err := h.userService.GetUser(ctx, id)
    if err != nil {
        h.logger.Error("failed to get user", "error", err, "id", id)
        http.Error(w, "internal server error", http.StatusInternalServerError)
        return
    }
    
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(user)
}
```

### Testing Pattern
```go
func TestUserService_GetUser(t *testing.T) {
    tests := []struct {
        name    string
        userID  int
        want    *User
        wantErr bool
    }{
        {
            name:   "valid user",
            userID: 1,
            want:   &User{ID: 1, Name: "John"},
            wantErr: false,
        },
        {
            name:    "user not found",
            userID:  999,
            want:    nil,
            wantErr: true,
        },
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            // Setup
            mockRepo := &MockUserRepository{}
            service := &UserService{repo: mockRepo}
            
            // Execute
            got, err := service.GetUser(context.Background(), tt.userID)
            
            // Assert
            if (err != nil) != tt.wantErr {
                t.Errorf("GetUser() error = %v, wantErr %v", err, tt.wantErr)
                return
            }
            if !reflect.DeepEqual(got, tt.want) {
                t.Errorf("GetUser() got = %v, want %v", got, tt.want)
            }
        })
    }
}
```

## 8. Common Go Frameworks and Libraries

### Web Frameworks
- **Gin**: Fast HTTP web framework
- **Echo**: High performance, minimalist web framework
- **Fiber**: Express-inspired web framework
- **Chi**: Lightweight, idiomatic router

### Database
- **GORM**: ORM library for Go
- **sqlx**: Extensions to database/sql
- **Ent**: Entity framework for Go
- **pgx**: PostgreSQL driver

### Testing
- **Testify**: Testing toolkit
- **GoMock**: Mock generation
- **Ginkgo**: BDD testing framework
- **Gomega**: Matcher library

### Configuration
- **Viper**: Configuration management
- **Cobra**: CLI application framework
- **Env**: Environment variable parsing

### Logging
- **slog**: Structured logging (Go 1.21+)
- **Zap**: Fast, structured logging
- **Logrus**: Structured logger
- **Zerolog**: JSON logger

## 9. Go Project Patterns

### Standard Project Layout
```
myproject/
├── cmd/
│   └── myapp/
│       └── main.go
├── internal/
│   ├── handler/
│   ├── service/
│   └── repository/
├── pkg/
│   └── utils/
├── api/
├── web/
├── configs/
├── scripts/
├── test/
├── docs/
├── go.mod
├── go.sum
└── README.md
```

### Dependency Injection
```go
type Dependencies struct {
    UserService UserService
    Logger      *slog.Logger
    DB          *sql.DB
}

func NewDependencies() (*Dependencies, error) {
    db, err := sql.Open("postgres", connectionString)
    if err != nil {
        return nil, err
    }
    
    logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
    
    userRepo := repository.NewUserRepository(db)
    userService := service.NewUserService(userRepo, logger)
    
    return &Dependencies{
        UserService: userService,
        Logger:      logger,
        DB:          db,
    }, nil
}
```

### Configuration Management
```go
type Config struct {
    Server struct {
        Port int    `env:"SERVER_PORT" envDefault:"8080"`
        Host string `env:"SERVER_HOST" envDefault:"localhost"`
    }
    Database struct {
        URL string `env:"DATABASE_URL"`
    }
}

func LoadConfig() (*Config, error) {
    cfg := &Config{}
    if err := env.Parse(cfg); err != nil {
        return nil, err
    }
    return cfg, nil
}
```