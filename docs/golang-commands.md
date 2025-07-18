# Go Development Commands

This document provides comprehensive Go development commands for integration into CLAUDE.md files.

## Module Management Commands

### Module Initialization and Setup
```bash
# Initialize a new Go module
go mod init github.com/username/project

# Initialize with specific Go version
go mod init -go=1.21 github.com/username/project

# Download dependencies
go mod download

# Clean up module dependencies
go mod tidy

# Verify module dependencies
go mod verify

# Update all dependencies
go get -u ./...

# Update specific dependency
go get -u github.com/gin-gonic/gin

# Add dependency with specific version
go get github.com/redis/go-redis/v9@v9.0.5

# Remove unused dependencies
go mod tidy
```

### Module Information
```bash
# Show module information
go list -m all

# Show module graph
go mod graph

# Show why a dependency is needed
go mod why github.com/gin-gonic/gin

# Show module edit history
go mod edit -json
```

## Build Commands

### Basic Build Operations
```bash
# Build current package
go build

# Build specific package
go build ./cmd/server

# Build with output name
go build -o bin/server ./cmd/server

# Build all packages
go build ./...

# Build with verbose output
go build -v ./cmd/server

# Build with race detection
go build -race ./cmd/server
```

### Cross-Platform Building
```bash
# Build for Linux
GOOS=linux GOARCH=amd64 go build -o bin/server-linux ./cmd/server

# Build for macOS
GOOS=darwin GOARCH=amd64 go build -o bin/server-darwin ./cmd/server

# Build for Windows
GOOS=windows GOARCH=amd64 go build -o bin/server.exe ./cmd/server

# Build for ARM
GOOS=linux GOARCH=arm64 go build -o bin/server-arm ./cmd/server

# Show available platforms
go tool dist list
```

### Advanced Build Options
```bash
# Build with ldflags (reduce binary size)
go build -ldflags="-w -s" -o bin/server ./cmd/server

# Build with version information
go build -ldflags="-X main.version=v1.0.0 -X main.buildTime=$(date -u +%Y%m%d.%H%M%S)" ./cmd/server

# Build with build tags
go build -tags="production" ./cmd/server

# Build with CGO disabled
CGO_ENABLED=0 go build ./cmd/server

# Build with specific Go version
go build -mod=readonly ./cmd/server
```

## Testing Commands

### Basic Testing
```bash
# Run all tests
go test ./...

# Run tests in current directory
go test

# Run tests with verbose output
go test -v ./...

# Run specific test
go test -run TestUserService_GetUser

# Run tests matching pattern
go test -run "TestUser.*"

# Run tests in specific package
go test ./internal/service
```

### Advanced Testing
```bash
# Run tests with race detection
go test -race ./...

# Run tests with coverage
go test -cover ./...

# Generate detailed coverage report
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out -o coverage.html

# Run tests with coverage and open in browser
go test -coverprofile=coverage.out ./... && go tool cover -html=coverage.out

# Run tests with short mode
go test -short ./...

# Run tests with timeout
go test -timeout 30s ./...

# Run tests in parallel
go test -parallel 4 ./...
```

### Benchmark Testing
```bash
# Run benchmarks
go test -bench=.

# Run specific benchmark
go test -bench=BenchmarkUserService_GetUser

# Run benchmarks with memory stats
go test -bench=. -benchmem

# Run benchmarks multiple times
go test -bench=. -count=5

# Run benchmarks with CPU profiling
go test -bench=. -cpuprofile=cpu.prof

# Run benchmarks with memory profiling
go test -bench=. -memprofile=mem.prof
```

### Fuzz Testing
```bash
# Run fuzz tests
go test -fuzz=FuzzUserValidation

# Run fuzz tests with time limit
go test -fuzz=FuzzUserValidation -fuzztime=30s

# Run fuzz tests with minimum duration
go test -fuzz=FuzzUserValidation -fuzzminimizetime=10s
```

## Code Quality Commands

### Formatting and Linting
```bash
# Format code
go fmt ./...

# Format with gofmt
gofmt -w .

# Format with goimports (adds missing imports)
goimports -w .

# Run go vet
go vet ./...

# Run golangci-lint
golangci-lint run

# Run golangci-lint with specific linters
golangci-lint run --enable-all

# Run golangci-lint with fix
golangci-lint run --fix
```

### Static Analysis
```bash
# Run staticcheck
staticcheck ./...

# Run gosec (security scanner)
gosec ./...

# Run ineffassign
ineffassign ./...

# Run misspell
misspell ./...

# Run gocyclo (cyclomatic complexity)
gocyclo -over 15 .
```

### Security Scanning
```bash
# Run govulncheck
govulncheck ./...

# Run Nancy (dependency vulnerability scanner)
nancy sleuth

# Run gosec with specific rules
gosec -include=G401,G501 ./...
```

## Execution Commands

### Running Applications
```bash
# Run main package
go run main.go

# Run specific package
go run ./cmd/server

# Run with arguments
go run ./cmd/server -port=8080

# Run with environment variables
PORT=8080 go run ./cmd/server

# Run with race detection
go run -race ./cmd/server

# Run with build tags
go run -tags="development" ./cmd/server
```

### Development Tools
```bash
# Install Air for live reloading
go install github.com/cosmtrek/air@latest

# Run with Air
air

# Install and run with Gin (live reloading)
go install github.com/codegangsta/gin@latest
gin --port 3000 --appPort 8080 --bin tmp/app

# Install delve debugger
go install github.com/go-delve/delve/cmd/dlv@latest

# Debug with delve
dlv debug ./cmd/server
```

## Code Generation

### Standard Code Generation
```bash
# Generate code (run //go:generate comments)
go generate ./...

# Generate mocks with mockgen
go generate ./...

# Generate protobuf code
protoc --go_out=. --go_opt=paths=source_relative api/proto/*.proto

# Generate GraphQL code
go run github.com/99designs/gqlgen generate
```

### Custom Code Generation
```bash
# Install code generation tools
go install github.com/golang/mock/mockgen@latest
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install github.com/99designs/gqlgen@latest

# Generate mocks
mockgen -source=internal/repository/interfaces.go -destination=test/mocks/repository.go

# Generate swagger docs
go install github.com/swaggo/swag/cmd/swag@latest
swag init
```

## Profiling and Performance

### CPU Profiling
```bash
# Run with CPU profiling
go test -cpuprofile cpu.prof -bench .

# Analyze CPU profile
go tool pprof cpu.prof

# Generate CPU profile visualization
go tool pprof -http=:8080 cpu.prof
```

### Memory Profiling
```bash
# Run with memory profiling
go test -memprofile mem.prof -bench .

# Analyze memory profile
go tool pprof mem.prof

# Generate memory profile visualization
go tool pprof -http=:8080 mem.prof
```

### Runtime Profiling
```bash
# Enable pprof in application
import _ "net/http/pprof"

# Start profiling server
go func() {
    log.Println(http.ListenAndServe("localhost:6060", nil))
}()

# Collect CPU profile
go tool pprof http://localhost:6060/debug/pprof/profile?seconds=30

# Collect memory profile
go tool pprof http://localhost:6060/debug/pprof/heap

# Collect goroutine profile
go tool pprof http://localhost:6060/debug/pprof/goroutine
```

### Trace Analysis
```bash
# Generate trace
go test -trace=trace.out

# Analyze trace
go tool trace trace.out

# Generate execution trace
go run -trace=trace.out ./cmd/server
```

## Deployment Commands

### Building for Production
```bash
# Build optimized binary
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o bin/server ./cmd/server

# Build with specific Go version
GO111MODULE=on go build -mod=readonly ./cmd/server

# Build with vendor dependencies
go build -mod=vendor ./cmd/server

# Build with trimpath
go build -trimpath ./cmd/server
```

### Docker Integration
```bash
# Build Docker image
docker build -t myapp:latest .

# Multi-stage Docker build
docker build --target production -t myapp:production .

# Build with specific Go version
docker build --build-arg GO_VERSION=1.21 -t myapp:latest .
```

### Cloud Deployment
```bash
# Build for Google Cloud Run
gcloud builds submit --tag gcr.io/PROJECT_ID/myapp

# Build for AWS Lambda
GOOS=linux GOARCH=amd64 go build -o main ./cmd/lambda
zip deployment.zip main

# Build for Azure Functions
GOOS=linux GOARCH=amd64 go build -o main ./cmd/azure
```

## Database Operations

### Migration Commands
```bash
# Install migrate tool
go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

# Create migration
migrate create -ext sql -dir db/migrations -seq create_users_table

# Run migrations up
migrate -path db/migrations -database "postgres://user:pass@host:port/dbname?sslmode=disable" up

# Run migrations down
migrate -path db/migrations -database "postgres://user:pass@host:port/dbname?sslmode=disable" down

# Check migration status
migrate -path db/migrations -database "postgres://user:pass@host:port/dbname?sslmode=disable" version
```

### Database Tools
```bash
# Install SQL migration tools
go install github.com/pressly/goose/v3/cmd/goose@latest

# Create migration with goose
goose -dir db/migrations create create_users_table sql

# Run migrations with goose
goose -dir db/migrations postgres "user=postgres dbname=mydb sslmode=disable" up

# Generate models from database
go install github.com/volatiletech/sqlboiler/v4@latest
sqlboiler psql
```

## Environment and Configuration

### Environment Setup
```bash
# Set Go environment variables
export GO111MODULE=on
export GOPROXY=https://proxy.golang.org,direct
export GOPRIVATE=github.com/yourorg/*
export GOSUMDB=sum.golang.org
export CGO_ENABLED=0

# Show Go environment
go env

# Show specific environment variable
go env GOPATH

# Set environment variable
go env -w GOPROXY=https://proxy.golang.org,direct
```

### Configuration Management
```bash
# Load environment variables from file
export $(cat .env | xargs)

# Run with environment file
env $(cat .env | xargs) go run ./cmd/server

# Use godotenv in code
go get github.com/joho/godotenv
```

## Debugging Commands

### Debugging with Delve
```bash
# Install delve
go install github.com/go-delve/delve/cmd/dlv@latest

# Debug current package
dlv debug

# Debug specific package
dlv debug ./cmd/server

# Debug with arguments
dlv debug ./cmd/server -- -port=8080

# Debug test
dlv test ./internal/service

# Attach to running process
dlv attach <pid>

# Connect to remote debugger
dlv connect localhost:2345
```

### Debugging Commands in Delve
```bash
# Set breakpoint
(dlv) b main.main

# Continue execution
(dlv) c

# Step over
(dlv) n

# Step into
(dlv) s

# Print variable
(dlv) p variableName

# List goroutines
(dlv) goroutines

# Switch to goroutine
(dlv) goroutine 1
```

## Dependency Management

### Version Management
```bash
# Show current dependencies
go list -m all

# Show dependency tree
go mod graph

# Show outdated dependencies
go list -u -m all

# Update to latest minor version
go get -u=patch ./...

# Update to latest major version
go get -u ./...

# Add specific version
go get github.com/gin-gonic/gin@v1.9.1

# Remove dependency
go mod edit -droprequire github.com/unused/package
```

### Vendor Management
```bash
# Create vendor directory
go mod vendor

# Verify vendor directory
go mod verify

# Build with vendor
go build -mod=vendor ./cmd/server

# Show vendor status
go list -mod=vendor all
```

## Performance Optimization

### Build Optimization
```bash
# Build with optimizations
go build -ldflags="-w -s" ./cmd/server

# Build with upx compression
upx --best ./bin/server

# Build with specific garbage collector
GOGC=off go build ./cmd/server

# Build with memory limit
GOMEMLIMIT=1GiB go build ./cmd/server
```

### Runtime Optimization
```bash
# Run with garbage collector tuning
GOGC=100 go run ./cmd/server

# Run with memory limit
GOMEMLIMIT=512MiB go run ./cmd/server

# Run with CPU limit
GOMAXPROCS=4 go run ./cmd/server
```

## Example Development Workflow

```bash
# 1. Start new Go project
go mod init github.com/username/myproject

# 2. Add dependencies
go get github.com/gin-gonic/gin
go get github.com/lib/pq

# 3. Write code and tests
go generate ./...

# 4. Format and lint
go fmt ./...
go vet ./...
golangci-lint run

# 5. Run tests
go test -race -cover ./...

# 6. Run application
go run ./cmd/server

# 7. Build for production
CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o bin/server ./cmd/server

# 8. Security scan
govulncheck ./...

# 9. Performance profile
go test -bench=. -cpuprofile=cpu.prof

# 10. Deploy
docker build -t myapp:latest .
```

## Makefile Integration

```makefile
# Common Go commands in Makefile
.PHONY: build test clean run fmt vet lint

build:
	go build -o bin/server ./cmd/server

test:
	go test -race -cover ./...

clean:
	go clean
	rm -rf bin/

run:
	go run ./cmd/server

fmt:
	go fmt ./...

vet:
	go vet ./...

lint:
	golangci-lint run

deps:
	go mod tidy
	go mod download

generate:
	go generate ./...

profile:
	go test -bench=. -cpuprofile=cpu.prof

docker:
	docker build -t myapp:latest .
```

These commands provide comprehensive coverage of Go development workflows and can be integrated into your CLAUDE.md file for AI-assisted Go development.