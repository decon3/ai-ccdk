# [Feature Name] - Go Feature Context

## Feature Overview
[Detailed description of what this feature does, its purpose, and business value]

## Current Status: [Planning/In Development/Testing/Complete]
[Current development phase, completion percentage, and any blockers]

## Go Implementation Architecture

### Core Design Patterns
- **Architectural Pattern**: [Clean Architecture, Hexagonal, MVC, etc.]
- **Concurrency Model**: [Worker pools, Pipeline, Fan-out/Fan-in, etc.]
- **Data Flow**: [Request/Response, Event-driven, Streaming, etc.]
- **Error Handling**: [Error wrapping, Custom errors, Sentinel errors]

### Package Structure
```
feature/
├── cmd/                    # Application entry points
│   └── server/
│       └── main.go
├── internal/               # Private feature code
│   ├── handler/           # HTTP handlers
│   ├── service/           # Business logic
│   ├── repository/        # Data access
│   ├── model/            # Data structures
│   └── worker/           # Background processing
├── pkg/                   # Public API
│   ├── client/           # Client libraries
│   └── types/            # Public types
└── api/                   # API definitions
    └── openapi.yaml
```

### Key Components

#### Core Services
```go
// Primary service interface
type FeatureService interface {
    ProcessRequest(ctx context.Context, req *Request) (*Response, error)
    GetStatus(ctx context.Context, id string) (*Status, error)
    Cancel(ctx context.Context, id string) error
}

// Configuration structure
type FeatureConfig struct {
    MaxWorkers     int           `env:"MAX_WORKERS" envDefault:"10"`
    ProcessTimeout time.Duration `env:"PROCESS_TIMEOUT" envDefault:"30s"`
    RetryAttempts  int           `env:"RETRY_ATTEMPTS" envDefault:"3"`
    QueueSize      int           `env:"QUEUE_SIZE" envDefault:"1000"`
}
```

#### Data Models
```go
// Request model
type Request struct {
    ID        string            `json:"id" validate:"required,uuid"`
    Type      RequestType       `json:"type" validate:"required"`
    Data      json.RawMessage   `json:"data" validate:"required"`
    Metadata  map[string]string `json:"metadata,omitempty"`
    CreatedAt time.Time         `json:"created_at"`
}

// Response model
type Response struct {
    ID          string          `json:"id"`
    Status      StatusType      `json:"status"`
    Result      json.RawMessage `json:"result,omitempty"`
    Error       string          `json:"error,omitempty"`
    ProcessedAt time.Time       `json:"processed_at"`
}
```

## Implementation Details

### Concurrency Implementation
```go
// Worker pool pattern
type WorkerPool struct {
    workers    int
    jobs       chan Job
    results    chan Result
    ctx        context.Context
    cancel     context.CancelFunc
    wg         sync.WaitGroup
}

func (wp *WorkerPool) Start() {
    wp.ctx, wp.cancel = context.WithCancel(context.Background())
    
    for i := 0; i < wp.workers; i++ {
        wp.wg.Add(1)
        go wp.worker()
    }
}

func (wp *WorkerPool) worker() {
    defer wp.wg.Done()
    
    for {
        select {
        case job := <-wp.jobs:
            result := wp.processJob(job)
            wp.results <- result
        case <-wp.ctx.Done():
            return
        }
    }
}
```

### Error Handling Strategy
```go
// Custom error types
type FeatureError struct {
    Code    string `json:"code"`
    Message string `json:"message"`
    Cause   error  `json:"-"`
}

func (e *FeatureError) Error() string {
    return fmt.Sprintf("%s: %s", e.Code, e.Message)
}

func (e *FeatureError) Unwrap() error {
    return e.Cause
}

// Error constructors
func NewValidationError(msg string) *FeatureError {
    return &FeatureError{
        Code:    "VALIDATION_ERROR",
        Message: msg,
    }
}

func NewProcessingError(msg string, cause error) *FeatureError {
    return &FeatureError{
        Code:    "PROCESSING_ERROR",
        Message: msg,
        Cause:   cause,
    }
}
```

### Database Integration
```go
// Repository interface
type FeatureRepository interface {
    Create(ctx context.Context, item *Item) error
    GetByID(ctx context.Context, id string) (*Item, error)
    Update(ctx context.Context, item *Item) error
    Delete(ctx context.Context, id string) error
    List(ctx context.Context, filter *Filter) ([]*Item, error)
}

// Implementation with transaction support
type PostgresRepository struct {
    db *sql.DB
}

func (r *PostgresRepository) Create(ctx context.Context, item *Item) error {
    query := `
        INSERT INTO items (id, name, data, created_at)
        VALUES ($1, $2, $3, $4)
    `
    
    _, err := r.db.ExecContext(ctx, query, item.ID, item.Name, item.Data, item.CreatedAt)
    if err != nil {
        return fmt.Errorf("failed to create item: %w", err)
    }
    
    return nil
}
```

## API Design

### HTTP Endpoints
```go
// REST API handlers
func (h *Handler) CreateFeature(w http.ResponseWriter, r *http.Request) {
    ctx := r.Context()
    
    var req CreateRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, "Invalid request body", http.StatusBadRequest)
        return
    }
    
    if err := h.validator.Validate(req); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }
    
    result, err := h.service.Create(ctx, &req)
    if err != nil {
        h.handleError(w, err)
        return
    }
    
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusCreated)
    json.NewEncoder(w).Encode(result)
}

// WebSocket handler for real-time updates
func (h *Handler) HandleWebSocket(w http.ResponseWriter, r *http.Request) {
    conn, err := h.upgrader.Upgrade(w, r, nil)
    if err != nil {
        h.logger.Error("WebSocket upgrade failed", "error", err)
        return
    }
    defer conn.Close()
    
    ctx := r.Context()
    updates := h.service.Subscribe(ctx)
    
    for {
        select {
        case update := <-updates:
            if err := conn.WriteJSON(update); err != nil {
                h.logger.Error("WebSocket write failed", "error", err)
                return
            }
        case <-ctx.Done():
            return
        }
    }
}
```

### gRPC Services (if applicable)
```go
// gRPC service implementation
type FeatureServer struct {
    service FeatureService
    logger  *slog.Logger
}

func (s *FeatureServer) ProcessRequest(ctx context.Context, req *pb.ProcessRequest) (*pb.ProcessResponse, error) {
    input := &Request{
        ID:   req.Id,
        Type: RequestType(req.Type),
        Data: req.Data,
    }
    
    result, err := s.service.ProcessRequest(ctx, input)
    if err != nil {
        return nil, status.Errorf(codes.Internal, "processing failed: %v", err)
    }
    
    return &pb.ProcessResponse{
        Id:     result.ID,
        Status: string(result.Status),
        Result: result.Result,
    }, nil
}
```

## Testing Strategy

### Unit Tests
```go
func TestFeatureService_ProcessRequest(t *testing.T) {
    tests := []struct {
        name    string
        request *Request
        want    *Response
        wantErr bool
    }{
        {
            name: "valid request",
            request: &Request{
                ID:   "test-id",
                Type: TypeA,
                Data: json.RawMessage(`{"key": "value"}`),
            },
            want: &Response{
                ID:     "test-id",
                Status: StatusComplete,
                Result: json.RawMessage(`{"processed": true}`),
            },
            wantErr: false,
        },
        {
            name: "invalid request type",
            request: &Request{
                ID:   "test-id",
                Type: TypeInvalid,
            },
            want:    nil,
            wantErr: true,
        },
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            service := NewFeatureService(mockRepo, mockLogger)
            got, err := service.ProcessRequest(context.Background(), tt.request)
            
            if (err != nil) != tt.wantErr {
                t.Errorf("ProcessRequest() error = %v, wantErr %v", err, tt.wantErr)
                return
            }
            
            if !reflect.DeepEqual(got, tt.want) {
                t.Errorf("ProcessRequest() = %v, want %v", got, tt.want)
            }
        })
    }
}
```

### Integration Tests
```go
//go:build integration
// +build integration

func TestFeatureIntegration(t *testing.T) {
    // Set up test database
    db := setupTestDB(t)
    defer cleanupTestDB(t, db)
    
    // Initialize service with real dependencies
    repo := NewPostgresRepository(db)
    service := NewFeatureService(repo, logger)
    
    // Test full workflow
    request := &Request{
        ID:   uuid.New().String(),
        Type: TypeA,
        Data: json.RawMessage(`{"test": "data"}`),
    }
    
    response, err := service.ProcessRequest(context.Background(), request)
    assert.NoError(t, err)
    assert.NotNil(t, response)
    assert.Equal(t, StatusComplete, response.Status)
    
    // Verify database state
    stored, err := repo.GetByID(context.Background(), request.ID)
    assert.NoError(t, err)
    assert.Equal(t, request.ID, stored.ID)
}
```

### Benchmark Tests
```go
func BenchmarkFeatureService_ProcessRequest(b *testing.B) {
    service := NewFeatureService(mockRepo, mockLogger)
    request := &Request{
        ID:   "bench-id",
        Type: TypeA,
        Data: json.RawMessage(`{"key": "value"}`),
    }
    
    b.ResetTimer()
    
    for i := 0; i < b.N; i++ {
        _, err := service.ProcessRequest(context.Background(), request)
        if err != nil {
            b.Fatal(err)
        }
    }
}

func BenchmarkConcurrentProcessing(b *testing.B) {
    service := NewFeatureService(mockRepo, mockLogger)
    
    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() {
            request := &Request{
                ID:   uuid.New().String(),
                Type: TypeA,
                Data: json.RawMessage(`{"key": "value"}`),
            }
            
            _, err := service.ProcessRequest(context.Background(), request)
            if err != nil {
                b.Fatal(err)
            }
        }
    })
}
```

## Configuration Management

### Environment Variables
```go
type Config struct {
    Server struct {
        Host         string        `env:"SERVER_HOST" envDefault:"localhost"`
        Port         int           `env:"SERVER_PORT" envDefault:"8080"`
        ReadTimeout  time.Duration `env:"READ_TIMEOUT" envDefault:"30s"`
        WriteTimeout time.Duration `env:"WRITE_TIMEOUT" envDefault:"30s"`
    }
    
    Database struct {
        URL             string `env:"DATABASE_URL" envDefault:"postgres://localhost/mydb"`
        MaxOpenConns    int    `env:"DB_MAX_OPEN_CONNS" envDefault:"25"`
        MaxIdleConns    int    `env:"DB_MAX_IDLE_CONNS" envDefault:"25"`
        ConnMaxLifetime time.Duration `env:"DB_CONN_MAX_LIFETIME" envDefault:"5m"`
    }
    
    Feature struct {
        MaxWorkers     int           `env:"FEATURE_MAX_WORKERS" envDefault:"10"`
        ProcessTimeout time.Duration `env:"FEATURE_PROCESS_TIMEOUT" envDefault:"30s"`
        QueueSize      int           `env:"FEATURE_QUEUE_SIZE" envDefault:"1000"`
    }
}

func LoadConfig() (*Config, error) {
    cfg := &Config{}
    if err := env.Parse(cfg); err != nil {
        return nil, fmt.Errorf("failed to parse config: %w", err)
    }
    return cfg, nil
}
```

## Performance Characteristics

### Throughput Targets
- **Requests per second**: [Target RPS under normal load]
- **Concurrent users**: [Maximum supported concurrent users]
- **Processing time**: [Average processing time per request]

### Resource Usage
- **Memory**: [Expected memory usage patterns]
- **CPU**: [CPU utilization targets]
- **Network**: [Network bandwidth requirements]
- **Database**: [Database connection and query patterns]

### Scalability Considerations
- **Horizontal scaling**: [How the feature scales across multiple instances]
- **Vertical scaling**: [Resource requirements for scaling up]
- **Bottlenecks**: [Known performance bottlenecks and mitigation strategies]

## Monitoring and Observability

### Metrics
```go
// Prometheus metrics
var (
    requestsTotal = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "feature_requests_total",
            Help: "Total number of requests processed",
        },
        []string{"type", "status"},
    )
    
    requestDuration = prometheus.NewHistogramVec(
        prometheus.HistogramOpts{
            Name: "feature_request_duration_seconds",
            Help: "Request processing duration",
        },
        []string{"type"},
    )
    
    activeWorkers = prometheus.NewGauge(
        prometheus.GaugeOpts{
            Name: "feature_active_workers",
            Help: "Number of active workers",
        },
    )
)

// Middleware for metrics collection
func (h *Handler) metricsMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        start := time.Now()
        
        rw := &responseWriter{ResponseWriter: w}
        next.ServeHTTP(rw, r)
        
        duration := time.Since(start)
        requestDuration.WithLabelValues(r.Method).Observe(duration.Seconds())
        requestsTotal.WithLabelValues(r.Method, fmt.Sprintf("%d", rw.statusCode)).Inc()
    })
}
```

### Logging
```go
// Structured logging with context
func (s *FeatureService) ProcessRequest(ctx context.Context, req *Request) (*Response, error) {
    logger := s.logger.With(
        "request_id", req.ID,
        "request_type", req.Type,
        "timestamp", time.Now(),
    )
    
    logger.Info("Processing request started")
    
    result, err := s.processInternal(ctx, req)
    if err != nil {
        logger.Error("Processing request failed", "error", err)
        return nil, err
    }
    
    logger.Info("Processing request completed", "result_status", result.Status)
    return result, nil
}
```

### Health Checks
```go
// Health check endpoint
func (h *Handler) HealthCheck(w http.ResponseWriter, r *http.Request) {
    ctx := r.Context()
    
    health := &HealthStatus{
        Status:    "healthy",
        Timestamp: time.Now(),
        Checks:    make(map[string]string),
    }
    
    // Check database connectivity
    if err := h.db.PingContext(ctx); err != nil {
        health.Status = "unhealthy"
        health.Checks["database"] = "failed"
    } else {
        health.Checks["database"] = "healthy"
    }
    
    // Check worker pool
    if h.workerPool.IsHealthy() {
        health.Checks["workers"] = "healthy"
    } else {
        health.Status = "unhealthy"
        health.Checks["workers"] = "unhealthy"
    }
    
    status := http.StatusOK
    if health.Status == "unhealthy" {
        status = http.StatusServiceUnavailable
    }
    
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(status)
    json.NewEncoder(w).Encode(health)
}
```

## Security Implementation

### Input Validation
```go
// Request validation
func (v *Validator) ValidateRequest(req *Request) error {
    if req.ID == "" {
        return NewValidationError("ID is required")
    }
    
    if _, err := uuid.Parse(req.ID); err != nil {
        return NewValidationError("ID must be a valid UUID")
    }
    
    if req.Type == "" {
        return NewValidationError("Type is required")
    }
    
    if !req.Type.IsValid() {
        return NewValidationError("Invalid request type")
    }
    
    if len(req.Data) == 0 {
        return NewValidationError("Data is required")
    }
    
    return nil
}

// Data sanitization
func (s *FeatureService) sanitizeInput(data string) string {
    // Remove dangerous characters
    sanitized := strings.ReplaceAll(data, "<script>", "")
    sanitized = strings.ReplaceAll(sanitized, "</script>", "")
    
    // Validate length
    if len(sanitized) > maxInputLength {
        sanitized = sanitized[:maxInputLength]
    }
    
    return sanitized
}
```

### Authentication & Authorization
```go
// JWT middleware
func (h *Handler) authMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        token := r.Header.Get("Authorization")
        if token == "" {
            http.Error(w, "Missing authorization header", http.StatusUnauthorized)
            return
        }
        
        claims, err := h.jwtService.ValidateToken(token)
        if err != nil {
            http.Error(w, "Invalid token", http.StatusUnauthorized)
            return
        }
        
        ctx := context.WithValue(r.Context(), "user_id", claims.UserID)
        next.ServeHTTP(w, r.WithContext(ctx))
    })
}

// Permission checking
func (h *Handler) requirePermission(permission string) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            userID := r.Context().Value("user_id").(string)
            
            if !h.authService.HasPermission(userID, permission) {
                http.Error(w, "Insufficient permissions", http.StatusForbidden)
                return
            }
            
            next.ServeHTTP(w, r)
        })
    }
}
```

## Deployment Configuration

### Docker Setup
```dockerfile
# Dockerfile
FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o bin/feature ./cmd/server

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/

COPY --from=builder /app/bin/feature .
COPY --from=builder /app/configs ./configs

EXPOSE 8080
CMD ["./feature"]
```

### Kubernetes Deployment
```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: feature-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: feature-service
  template:
    metadata:
      labels:
        app: feature-service
    spec:
      containers:
      - name: feature-service
        image: feature-service:latest
        ports:
        - containerPort: 8080
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: feature-secrets
              key: database-url
        - name: FEATURE_MAX_WORKERS
          value: "20"
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```

## Future Enhancements

### Planned Features
- **Feature A**: [Description and expected completion date]
- **Feature B**: [Description and dependencies]
- **Performance optimization**: [Specific optimizations planned]

### Technical Improvements
- **Caching layer**: [Redis integration for performance]
- **Event sourcing**: [Event-driven architecture improvements]
- **Microservices split**: [Breaking down into smaller services]

### Scalability Roadmap
- **Database sharding**: [Horizontal database scaling]
- **Message queue integration**: [Async processing improvements]
- **CDN integration**: [Static asset optimization]

---

*Last updated: [Date]*
*Feature version: [Version]*
*Go version: [Minimum Go version required]*
*Dependencies: [Key dependency versions]*