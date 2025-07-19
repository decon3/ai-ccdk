# [Feature Name] - .NET Framework 4.7.2 Feature Context

## Feature Overview
[Detailed description of what this feature does, its purpose, and business value]

## Current Status: [Planning/In Development/Testing/Complete]
[Current development phase, completion percentage, and any blockers]

## .NET Framework 4.7.2 Implementation Architecture

### Core Design Patterns
- **Architectural Pattern**: [Layered Architecture/N-Tier/Service-Oriented/Domain-Driven Design]
- **Application Type**: [Web API/Console Application/Windows Service/Mixed]
- **Data Access Pattern**: [Repository/Active Record/Table Data Gateway/Entity Framework]
- **Business Logic Organization**: [Service Layer/Domain Services/Transaction Scripts]
- **Error Handling Strategy**: [Exception handling/Result patterns/Error codes]

### Technology Stack
```
Application Layer:     ASP.NET Web API 2 / Console App / Windows Service
Business Logic:       Service Layer with Domain Models
Data Access:         Entity Framework 6.x / Dapper / ADO.NET
Database:            SQL Server / Oracle / MySQL
IoC Container:       Autofac / Unity / Ninject
Logging:             NLog / Serilog / log4net
Testing:             NUnit / MSTest / xUnit with Moq
```

### Project Structure
```
YourFeature/
├── YourFeature.Api/              # Web API application
├── YourFeature.Core/             # Business logic and models
├── YourFeature.Data/             # Data access layer
├── YourFeature.Console/          # Console application (if applicable)
├── YourFeature.WindowsService/   # Windows service (if applicable)
├── YourFeature.Common/           # Shared utilities
└── YourFeature.Tests/           # Unit and integration tests
```

## Implementation Details

### Domain Models and Entities
```csharp
// Domain entity with EF6 configuration
public class Order
{
    public int Id { get; set; }
    public string OrderNumber { get; set; }
    public DateTime OrderDate { get; set; }
    public int CustomerId { get; set; }
    public OrderStatus Status { get; set; }
    public decimal TotalAmount { get; set; }
    
    // Navigation properties
    public virtual Customer Customer { get; set; }
    public virtual ICollection<OrderItem> OrderItems { get; set; }
    
    // Domain methods
    public void AddItem(Product product, int quantity, decimal unitPrice)
    {
        if (Status != OrderStatus.Draft)
            throw new InvalidOperationException("Cannot modify confirmed order");
            
        var orderItem = new OrderItem
        {
            ProductId = product.Id,
            Quantity = quantity,
            UnitPrice = unitPrice,
            TotalPrice = quantity * unitPrice
        };
        
        OrderItems.Add(orderItem);
        RecalculateTotal();
    }
    
    public void ConfirmOrder()
    {
        if (Status != OrderStatus.Draft)
            throw new InvalidOperationException("Order is already confirmed");
            
        if (!OrderItems.Any())
            throw new InvalidOperationException("Cannot confirm empty order");
            
        Status = OrderStatus.Confirmed;
        // Additional business logic
    }
    
    private void RecalculateTotal()
    {
        TotalAmount = OrderItems.Sum(item => item.TotalPrice);
    }
}

public enum OrderStatus
{
    Draft = 0,
    Confirmed = 1,
    Shipped = 2,
    Delivered = 3,
    Cancelled = 4
}
```

### Entity Framework 6.x Configuration
```csharp
// DbContext configuration
public class FeatureDbContext : DbContext
{
    public FeatureDbContext() : base("DefaultConnection")
    {
        Configuration.LazyLoadingEnabled = false;
        Configuration.ProxyCreationEnabled = false;
        Configuration.UseDatabaseNullSemantics = true;
    }
    
    public FeatureDbContext(string connectionString) : base(connectionString)
    {
        Configuration.LazyLoadingEnabled = false;
        Configuration.ProxyCreationEnabled = false;
    }

    public DbSet<Order> Orders { get; set; }
    public DbSet<Customer> Customers { get; set; }
    public DbSet<Product> Products { get; set; }
    public DbSet<OrderItem> OrderItems { get; set; }

    protected override void OnModelCreating(DbModelBuilder modelBuilder)
    {
        // Order configuration
        modelBuilder.Entity<Order>()
            .HasKey(o => o.Id)
            .Property(o => o.OrderNumber)
            .IsRequired()
            .HasMaxLength(50);
            
        modelBuilder.Entity<Order>()
            .Property(o => o.TotalAmount)
            .HasPrecision(18, 2);
            
        modelBuilder.Entity<Order>()
            .HasRequired(o => o.Customer)
            .WithMany(c => c.Orders)
            .HasForeignKey(o => o.CustomerId)
            .WillCascadeOnDelete(false);

        // OrderItem configuration
        modelBuilder.Entity<OrderItem>()
            .HasKey(oi => oi.Id)
            .HasRequired(oi => oi.Order)
            .WithMany(o => o.OrderItems)
            .HasForeignKey(oi => oi.OrderId)
            .WillCascadeOnDelete(true);

        base.OnModelCreating(modelBuilder);
    }
}

// Migration configuration
internal sealed class Configuration : DbMigrationsConfiguration<FeatureDbContext>
{
    public Configuration()
    {
        AutomaticMigrationsEnabled = false;
        MigrationsDirectory = @"Migrations";
    }

    protected override void Seed(FeatureDbContext context)
    {
        context.Customers.AddOrUpdate(
            c => c.Email,
            new Customer { FirstName = "John", LastName = "Doe", Email = "john.doe@example.com" },
            new Customer { FirstName = "Jane", LastName = "Smith", Email = "jane.smith@example.com" }
        );
    }
}
```

### Repository Pattern Implementation
```csharp
// Repository interface
public interface IOrderRepository
{
    Task<Order> GetByIdAsync(int id);
    Task<Order> GetByOrderNumberAsync(string orderNumber);
    Task<IEnumerable<Order>> GetByCustomerIdAsync(int customerId);
    Task<IEnumerable<Order>> GetByStatusAsync(OrderStatus status);
    Task<Order> CreateAsync(Order order);
    Task UpdateAsync(Order order);
    Task DeleteAsync(int id);
    Task<bool> ExistsAsync(int id);
}

// Repository implementation
public class OrderRepository : IOrderRepository
{
    private readonly FeatureDbContext _context;
    private readonly ILogger _logger;

    public OrderRepository(FeatureDbContext context, ILogger logger)
    {
        _context = context ?? throw new ArgumentNullException(nameof(context));
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    public async Task<Order> GetByIdAsync(int id)
    {
        _logger.Debug("Retrieving order {OrderId}", id);
        
        return await _context.Orders
            .Include(o => o.Customer)
            .Include(o => o.OrderItems.Select(oi => oi.Product))
            .FirstOrDefaultAsync(o => o.Id == id);
    }

    public async Task<Order> GetByOrderNumberAsync(string orderNumber)
    {
        if (string.IsNullOrWhiteSpace(orderNumber))
            throw new ArgumentException("Order number cannot be null or empty", nameof(orderNumber));
            
        return await _context.Orders
            .Include(o => o.Customer)
            .Include(o => o.OrderItems.Select(oi => oi.Product))
            .FirstOrDefaultAsync(o => o.OrderNumber == orderNumber);
    }

    public async Task<IEnumerable<Order>> GetByCustomerIdAsync(int customerId)
    {
        return await _context.Orders
            .Where(o => o.CustomerId == customerId)
            .Include(o => o.OrderItems.Select(oi => oi.Product))
            .OrderByDescending(o => o.OrderDate)
            .ToListAsync();
    }

    public async Task<Order> CreateAsync(Order order)
    {
        if (order == null)
            throw new ArgumentNullException(nameof(order));

        _logger.Info("Creating new order for customer {CustomerId}", order.CustomerId);
        
        _context.Orders.Add(order);
        await _context.SaveChangesAsync();
        
        _logger.Info("Created order {OrderId} with number {OrderNumber}", order.Id, order.OrderNumber);
        return order;
    }

    public async Task UpdateAsync(Order order)
    {
        if (order == null)
            throw new ArgumentNullException(nameof(order));

        _logger.Debug("Updating order {OrderId}", order.Id);
        
        _context.Entry(order).State = EntityState.Modified;
        await _context.SaveChangesAsync();
        
        _logger.Info("Updated order {OrderId}", order.Id);
    }

    public async Task DeleteAsync(int id)
    {
        var order = await GetByIdAsync(id);
        if (order != null)
        {
            _logger.Info("Deleting order {OrderId}", id);
            _context.Orders.Remove(order);
            await _context.SaveChangesAsync();
        }
    }

    public async Task<bool> ExistsAsync(int id)
    {
        return await _context.Orders.AnyAsync(o => o.Id == id);
    }
}
```

### Business Service Layer
```csharp
// Service interface
public interface IOrderService
{
    Task<OrderDto> GetOrderAsync(int id);
    Task<OrderDto> GetOrderByNumberAsync(string orderNumber);
    Task<IEnumerable<OrderDto>> GetCustomerOrdersAsync(int customerId);
    Task<OrderDto> CreateOrderAsync(CreateOrderRequest request);
    Task<OrderDto> AddOrderItemAsync(int orderId, AddOrderItemRequest request);
    Task<OrderDto> ConfirmOrderAsync(int orderId);
    Task<OrderDto> CancelOrderAsync(int orderId);
    Task DeleteOrderAsync(int orderId);
}

// Service implementation
public class OrderService : IOrderService
{
    private readonly IOrderRepository _orderRepository;
    private readonly ICustomerRepository _customerRepository;
    private readonly IProductRepository _productRepository;
    private readonly IMapper _mapper;
    private readonly ILogger _logger;

    public OrderService(
        IOrderRepository orderRepository,
        ICustomerRepository customerRepository,
        IProductRepository productRepository,
        IMapper mapper,
        ILogger logger)
    {
        _orderRepository = orderRepository ?? throw new ArgumentNullException(nameof(orderRepository));
        _customerRepository = customerRepository ?? throw new ArgumentNullException(nameof(customerRepository));
        _productRepository = productRepository ?? throw new ArgumentNullException(nameof(productRepository));
        _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    public async Task<OrderDto> CreateOrderAsync(CreateOrderRequest request)
    {
        _logger.Info("Creating order for customer {CustomerId}", request.CustomerId);
        
        // Validate customer exists
        var customer = await _customerRepository.GetByIdAsync(request.CustomerId);
        if (customer == null)
        {
            throw new BusinessException($"Customer {request.CustomerId} not found");
        }

        // Create order
        var order = new Order
        {
            CustomerId = request.CustomerId,
            OrderNumber = await GenerateOrderNumberAsync(),
            OrderDate = DateTime.UtcNow,
            Status = OrderStatus.Draft,
            OrderItems = new List<OrderItem>()
        };

        // Add initial items if provided
        if (request.InitialItems != null && request.InitialItems.Any())
        {
            foreach (var item in request.InitialItems)
            {
                var product = await _productRepository.GetByIdAsync(item.ProductId);
                if (product == null)
                {
                    throw new BusinessException($"Product {item.ProductId} not found");
                }

                order.AddItem(product, item.Quantity, product.UnitPrice);
            }
        }

        var createdOrder = await _orderRepository.CreateAsync(order);
        _logger.Info("Created order {OrderId} for customer {CustomerId}", createdOrder.Id, request.CustomerId);
        
        return _mapper.Map<OrderDto>(createdOrder);
    }

    public async Task<OrderDto> ConfirmOrderAsync(int orderId)
    {
        _logger.Info("Confirming order {OrderId}", orderId);
        
        var order = await _orderRepository.GetByIdAsync(orderId);
        if (order == null)
        {
            throw new BusinessException($"Order {orderId} not found");
        }

        // Business validation
        if (order.Status != OrderStatus.Draft)
        {
            throw new BusinessException($"Order {orderId} cannot be confirmed - current status: {order.Status}");
        }

        if (!order.OrderItems.Any())
        {
            throw new BusinessException($"Order {orderId} cannot be confirmed - no items");
        }

        // Confirm order
        order.ConfirmOrder();
        await _orderRepository.UpdateAsync(order);
        
        _logger.Info("Confirmed order {OrderId}", orderId);
        return _mapper.Map<OrderDto>(order);
    }

    private async Task<string> GenerateOrderNumberAsync()
    {
        var timestamp = DateTime.UtcNow.ToString("yyyyMMddHHmmss");
        var random = new Random().Next(1000, 9999);
        return $"ORD-{timestamp}-{random}";
    }
}

// Custom exception for business rule violations
public class BusinessException : Exception
{
    public BusinessException(string message) : base(message) { }
    public BusinessException(string message, Exception innerException) : base(message, innerException) { }
}
```

### Web API Controller Implementation
```csharp
[RoutePrefix("api/orders")]
public class OrdersController : ApiController
{
    private readonly IOrderService _orderService;
    private readonly ILogger _logger;

    public OrdersController(IOrderService orderService, ILogger logger)
    {
        _orderService = orderService ?? throw new ArgumentNullException(nameof(orderService));
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    [HttpGet]
    [Route("{id:int}")]
    public async Task<IHttpActionResult> GetOrder(int id)
    {
        try
        {
            var order = await _orderService.GetOrderAsync(id);
            if (order == null)
            {
                return NotFound();
            }
            return Ok(order);
        }
        catch (Exception ex)
        {
            _logger.Error(ex, "Error retrieving order {OrderId}", id);
            return InternalServerError();
        }
    }

    [HttpPost]
    [Route("")]
    public async Task<IHttpActionResult> CreateOrder([FromBody] CreateOrderRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        try
        {
            var order = await _orderService.CreateOrderAsync(request);
            return CreatedAtRoute("GetOrder", new { id = order.Id }, order);
        }
        catch (BusinessException ex)
        {
            return BadRequest(ex.Message);
        }
        catch (Exception ex)
        {
            _logger.Error(ex, "Error creating order for customer {CustomerId}", request.CustomerId);
            return InternalServerError();
        }
    }

    [HttpPost]
    [Route("{id:int}/confirm")]
    public async Task<IHttpActionResult> ConfirmOrder(int id)
    {
        try
        {
            var order = await _orderService.ConfirmOrderAsync(id);
            return Ok(order);
        }
        catch (BusinessException ex)
        {
            return BadRequest(ex.Message);
        }
        catch (Exception ex)
        {
            _logger.Error(ex, "Error confirming order {OrderId}", id);
            return InternalServerError();
        }
    }

    [HttpPost]
    [Route("{id:int}/items")]
    public async Task<IHttpActionResult> AddOrderItem(int id, [FromBody] AddOrderItemRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        try
        {
            var order = await _orderService.AddOrderItemAsync(id, request);
            return Ok(order);
        }
        catch (BusinessException ex)
        {
            return BadRequest(ex.Message);
        }
        catch (Exception ex)
        {
            _logger.Error(ex, "Error adding item to order {OrderId}", id);
            return InternalServerError();
        }
    }

    [HttpDelete]
    [Route("{id:int}")]
    public async Task<IHttpActionResult> DeleteOrder(int id)
    {
        try
        {
            await _orderService.DeleteOrderAsync(id);
            return Ok();
        }
        catch (BusinessException ex)
        {
            return BadRequest(ex.Message);
        }
        catch (Exception ex)
        {
            _logger.Error(ex, "Error deleting order {OrderId}", id);
            return InternalServerError();
        }
    }
}

// Global exception filter
public class GlobalExceptionFilter : ExceptionFilterAttribute
{
    private static readonly ILogger Logger = LogManager.GetCurrentClassLogger();

    public override void OnException(HttpActionExecutedContext context)
    {
        var exception = context.Exception;
        Logger.Error(exception, "Unhandled exception in API: {Message}", exception.Message);

        var response = new
        {
            error = new
            {
                message = "An internal server error occurred",
                type = exception.GetType().Name
            }
        };

        context.Response = context.Request.CreateResponse(HttpStatusCode.InternalServerError, response);
    }
}
```

### Data Transfer Objects (DTOs)
```csharp
// Response DTOs
public class OrderDto
{
    public int Id { get; set; }
    public string OrderNumber { get; set; }
    public DateTime OrderDate { get; set; }
    public int CustomerId { get; set; }
    public string CustomerName { get; set; }
    public OrderStatus Status { get; set; }
    public decimal TotalAmount { get; set; }
    public List<OrderItemDto> OrderItems { get; set; }
}

public class OrderItemDto
{
    public int Id { get; set; }
    public int ProductId { get; set; }
    public string ProductName { get; set; }
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal TotalPrice { get; set; }
}

// Request DTOs
public class CreateOrderRequest
{
    [Required]
    public int CustomerId { get; set; }
    
    public List<CreateOrderItemRequest> InitialItems { get; set; }
}

public class CreateOrderItemRequest
{
    [Required]
    public int ProductId { get; set; }
    
    [Required]
    [Range(1, int.MaxValue, ErrorMessage = "Quantity must be at least 1")]
    public int Quantity { get; set; }
}

public class AddOrderItemRequest
{
    [Required]
    public int ProductId { get; set; }
    
    [Required]
    [Range(1, int.MaxValue, ErrorMessage = "Quantity must be at least 1")]
    public int Quantity { get; set; }
}
```

### AutoMapper Configuration
```csharp
public class OrderMappingProfile : Profile
{
    public OrderMappingProfile()
    {
        CreateMap<Order, OrderDto>()
            .ForMember(dest => dest.CustomerName, 
                      opt => opt.MapFrom(src => $"{src.Customer.FirstName} {src.Customer.LastName}"));

        CreateMap<OrderItem, OrderItemDto>()
            .ForMember(dest => dest.ProductName, 
                      opt => opt.MapFrom(src => src.Product.Name));

        CreateMap<CreateOrderRequest, Order>()
            .ForMember(dest => dest.Id, opt => opt.Ignore())
            .ForMember(dest => dest.OrderNumber, opt => opt.Ignore())
            .ForMember(dest => dest.OrderDate, opt => opt.Ignore())
            .ForMember(dest => dest.Status, opt => opt.Ignore())
            .ForMember(dest => dest.TotalAmount, opt => opt.Ignore())
            .ForMember(dest => dest.OrderItems, opt => opt.Ignore());
    }
}

// AutoMapper registration in container
public class AutoMapperModule : Module
{
    protected override void Load(ContainerBuilder builder)
    {
        builder.Register(context => new MapperConfiguration(cfg =>
        {
            cfg.AddProfile<OrderMappingProfile>();
            // Add other profiles
        })).AsSelf().SingleInstance();

        builder.Register(c =>
        {
            var context = c.Resolve<IComponentContext>();
            var config = context.Resolve<MapperConfiguration>();
            return config.CreateMapper(context.Resolve);
        }).As<IMapper>().InstancePerLifetimeScope();
    }
}
```

## Windows Service Implementation (if applicable)

### TopShelf Service Configuration
```csharp
// Service host using TopShelf
class Program
{
    static void Main(string[] args)
    {
        var container = ConfigureContainer();
        
        HostFactory.Run(x =>
        {
            x.Service<OrderProcessingService>(s =>
            {
                s.ConstructUsing(name => container.Resolve<OrderProcessingService>());
                s.WhenStarted((service, hostControl) => service.Start(hostControl));
                s.WhenStopped((service, hostControl) => service.Stop(hostControl));
                s.WhenPaused((service, hostControl) => service.Pause(hostControl));
                s.WhenContinued((service, hostControl) => service.Continue(hostControl));
            });
            
            x.RunAsLocalSystem();
            x.SetDescription("Order Processing Service - Processes pending orders and notifications");
            x.SetDisplayName("Order Processing Service");
            x.SetServiceName("OrderProcessingService");
            
            x.EnableServiceRecovery(r =>
            {
                r.RestartService(1); // Restart after 1 minute
                r.RestartService(5); // Restart after 5 minutes
                r.RestartComputer(10, "Order Processing Service failed to start"); // Restart computer after 10 minutes
                r.SetResetPeriod(1); // Reset failure count after 1 day
            });
        });
    }

    private static IContainer ConfigureContainer()
    {
        var builder = new ContainerBuilder();
        
        // Register services
        builder.RegisterModule<OrderServiceModule>();
        builder.RegisterModule<AutoMapperModule>();
        
        // Register Windows service
        builder.RegisterType<OrderProcessingService>()
            .AsSelf()
            .SingleInstance();
            
        return builder.Build();
    }
}

// Windows service implementation
public class OrderProcessingService
{
    private readonly IOrderService _orderService;
    private readonly INotificationService _notificationService;
    private readonly ILogger _logger;
    private Timer _processingTimer;
    private Timer _healthCheckTimer;
    private readonly object _lockObject = new object();
    private bool _isProcessing = false;

    public OrderProcessingService(
        IOrderService orderService,
        INotificationService notificationService,
        ILogger logger)
    {
        _orderService = orderService;
        _notificationService = notificationService;
        _logger = logger;
    }

    public bool Start(HostControl hostControl)
    {
        _logger.Info("Order Processing Service starting...");
        
        var processingInterval = TimeSpan.FromMinutes(
            int.Parse(ConfigurationManager.AppSettings["ProcessingIntervalMinutes"] ?? "5"));
        var healthCheckInterval = TimeSpan.FromMinutes(
            int.Parse(ConfigurationManager.AppSettings["HealthCheckIntervalMinutes"] ?? "1"));
            
        _processingTimer = new Timer(ProcessOrders, null, TimeSpan.Zero, processingInterval);
        _healthCheckTimer = new Timer(HealthCheck, null, healthCheckInterval, healthCheckInterval);
        
        _logger.Info("Order Processing Service started successfully");
        return true;
    }

    public bool Stop(HostControl hostControl)
    {
        _logger.Info("Order Processing Service stopping...");
        
        _processingTimer?.Dispose();
        _healthCheckTimer?.Dispose();
        
        // Wait for current processing to complete
        lock (_lockObject)
        {
            if (_isProcessing)
            {
                _logger.Info("Waiting for current processing to complete...");
                Thread.Sleep(5000); // Give some time to complete
            }
        }
        
        _logger.Info("Order Processing Service stopped successfully");
        return true;
    }

    public bool Pause(HostControl hostControl)
    {
        _logger.Info("Order Processing Service pausing...");
        _processingTimer?.Change(Timeout.Infinite, Timeout.Infinite);
        return true;
    }

    public bool Continue(HostControl hostControl)
    {
        _logger.Info("Order Processing Service resuming...");
        var interval = TimeSpan.FromMinutes(
            int.Parse(ConfigurationManager.AppSettings["ProcessingIntervalMinutes"] ?? "5"));
        _processingTimer?.Change(TimeSpan.Zero, interval);
        return true;
    }

    private async void ProcessOrders(object state)
    {
        lock (_lockObject)
        {
            if (_isProcessing)
            {
                _logger.Debug("Processing already in progress, skipping this cycle");
                return;
            }
            _isProcessing = true;
        }

        try
        {
            _logger.Debug("Starting order processing cycle");
            
            // Process confirmed orders that need shipping notifications
            await ProcessShippingNotifications();
            
            // Process overdue orders
            await ProcessOverdueOrders();
            
            _logger.Debug("Order processing cycle completed");
        }
        catch (Exception ex)
        {
            _logger.Error(ex, "Error during order processing cycle");
        }
        finally
        {
            lock (_lockObject)
            {
                _isProcessing = false;
            }
        }
    }

    private async Task ProcessShippingNotifications()
    {
        var confirmedOrders = await _orderService.GetOrdersByStatusAsync(OrderStatus.Confirmed);
        
        foreach (var order in confirmedOrders)
        {
            try
            {
                await _notificationService.SendShippingNotificationAsync(order.Id);
                _logger.Info("Sent shipping notification for order {OrderId}", order.Id);
            }
            catch (Exception ex)
            {
                _logger.Error(ex, "Failed to send shipping notification for order {OrderId}", order.Id);
            }
        }
    }

    private void HealthCheck(object state)
    {
        try
        {
            // Perform health checks
            var isHealthy = true;
            
            // Check database connectivity
            // Check external service availability
            // Check memory usage
            
            if (isHealthy)
            {
                _logger.Debug("Health check passed");
            }
            else
            {
                _logger.Warn("Health check failed");
            }
        }
        catch (Exception ex)
        {
            _logger.Error(ex, "Health check error");
        }
    }
}
```

## Testing Implementation

### Unit Testing with NUnit and Moq
```csharp
[TestFixture]
public class OrderServiceTests
{
    private Mock<IOrderRepository> _mockOrderRepository;
    private Mock<ICustomerRepository> _mockCustomerRepository;
    private Mock<IProductRepository> _mockProductRepository;
    private Mock<IMapper> _mockMapper;
    private Mock<ILogger> _mockLogger;
    private OrderService _orderService;

    [SetUp]
    public void SetUp()
    {
        _mockOrderRepository = new Mock<IOrderRepository>();
        _mockCustomerRepository = new Mock<ICustomerRepository>();
        _mockProductRepository = new Mock<IProductRepository>();
        _mockMapper = new Mock<IMapper>();
        _mockLogger = new Mock<ILogger>();
        
        _orderService = new OrderService(
            _mockOrderRepository.Object,
            _mockCustomerRepository.Object,
            _mockProductRepository.Object,
            _mockMapper.Object,
            _mockLogger.Object);
    }

    [Test]
    public async Task CreateOrderAsync_ValidRequest_ReturnsOrderDto()
    {
        // Arrange
        var customerId = 1;
        var customer = new Customer { Id = customerId, FirstName = "John", LastName = "Doe" };
        var request = new CreateOrderRequest { CustomerId = customerId };
        var order = new Order { Id = 1, CustomerId = customerId };
        var orderDto = new OrderDto { Id = 1, CustomerId = customerId };

        _mockCustomerRepository.Setup(r => r.GetByIdAsync(customerId))
                              .ReturnsAsync(customer);
        _mockOrderRepository.Setup(r => r.CreateAsync(It.IsAny<Order>()))
                           .ReturnsAsync(order);
        _mockMapper.Setup(m => m.Map<OrderDto>(It.IsAny<Order>()))
                  .Returns(orderDto);

        // Act
        var result = await _orderService.CreateOrderAsync(request);

        // Assert
        Assert.That(result, Is.Not.Null);
        Assert.That(result.Id, Is.EqualTo(1));
        Assert.That(result.CustomerId, Is.EqualTo(customerId));
        
        _mockOrderRepository.Verify(r => r.CreateAsync(It.IsAny<Order>()), Times.Once);
    }

    [Test]
    public void CreateOrderAsync_CustomerNotFound_ThrowsBusinessException()
    {
        // Arrange
        var customerId = 999;
        var request = new CreateOrderRequest { CustomerId = customerId };

        _mockCustomerRepository.Setup(r => r.GetByIdAsync(customerId))
                              .ReturnsAsync((Customer)null);

        // Act & Assert
        var ex = Assert.ThrowsAsync<BusinessException>(
            () => _orderService.CreateOrderAsync(request));
        
        Assert.That(ex.Message, Contains.Substring("Customer 999 not found"));
    }

    [Test]
    public async Task ConfirmOrderAsync_ValidOrder_ReturnsConfirmedOrder()
    {
        // Arrange
        var orderId = 1;
        var order = new Order 
        { 
            Id = orderId, 
            Status = OrderStatus.Draft,
            OrderItems = new List<OrderItem> 
            { 
                new OrderItem { ProductId = 1, Quantity = 2, UnitPrice = 10.00m }
            }
        };
        var orderDto = new OrderDto { Id = orderId, Status = OrderStatus.Confirmed };

        _mockOrderRepository.Setup(r => r.GetByIdAsync(orderId))
                           .ReturnsAsync(order);
        _mockMapper.Setup(m => m.Map<OrderDto>(It.IsAny<Order>()))
                  .Returns(orderDto);

        // Act
        var result = await _orderService.ConfirmOrderAsync(orderId);

        // Assert
        Assert.That(result, Is.Not.Null);
        Assert.That(result.Status, Is.EqualTo(OrderStatus.Confirmed));
        Assert.That(order.Status, Is.EqualTo(OrderStatus.Confirmed));
        
        _mockOrderRepository.Verify(r => r.UpdateAsync(order), Times.Once);
    }

    [Test]
    public void ConfirmOrderAsync_EmptyOrder_ThrowsBusinessException()
    {
        // Arrange
        var orderId = 1;
        var order = new Order 
        { 
            Id = orderId, 
            Status = OrderStatus.Draft,
            OrderItems = new List<OrderItem>() // Empty order items
        };

        _mockOrderRepository.Setup(r => r.GetByIdAsync(orderId))
                           .ReturnsAsync(order);

        // Act & Assert
        var ex = Assert.ThrowsAsync<BusinessException>(
            () => _orderService.ConfirmOrderAsync(orderId));
        
        Assert.That(ex.Message, Contains.Substring("cannot be confirmed - no items"));
    }
}
```

### Integration Testing
```csharp
[TestFixture]
[Category("Integration")]
public class OrderIntegrationTests
{
    private FeatureDbContext _context;
    private IContainer _container;
    private OrderService _orderService;

    [OneTimeSetUp]
    public void OneTimeSetUp()
    {
        // Setup test database
        var connectionString = ConfigurationManager.ConnectionStrings["TestConnection"].ConnectionString;
        Database.SetInitializer(new DropCreateDatabaseAlways<FeatureDbContext>());
        
        _context = new FeatureDbContext(connectionString);
        _context.Database.Initialize(true);
        
        // Setup container
        var builder = new ContainerBuilder();
        builder.RegisterInstance(_context).As<FeatureDbContext>();
        builder.RegisterType<OrderRepository>().As<IOrderRepository>();
        builder.RegisterType<CustomerRepository>().As<ICustomerRepository>();
        builder.RegisterType<ProductRepository>().As<IProductRepository>();
        // Register other dependencies...
        
        _container = builder.Build();
        _orderService = _container.Resolve<OrderService>();
    }

    [SetUp]
    public void SetUp()
    {
        // Clean and seed test data
        _context.Database.ExecuteSqlCommand("DELETE FROM Orders");
        _context.Database.ExecuteSqlCommand("DELETE FROM Customers");
        _context.Database.ExecuteSqlCommand("DELETE FROM Products");
        
        SeedTestData();
    }

    [Test]
    public async Task CreateOrderAsync_FullWorkflow_CreatesOrderWithItems()
    {
        // Arrange
        var customerId = 1; // From seed data
        var request = new CreateOrderRequest
        {
            CustomerId = customerId,
            InitialItems = new List<CreateOrderItemRequest>
            {
                new CreateOrderItemRequest { ProductId = 1, Quantity = 2 },
                new CreateOrderItemRequest { ProductId = 2, Quantity = 1 }
            }
        };

        // Act
        var result = await _orderService.CreateOrderAsync(request);

        // Assert
        Assert.That(result, Is.Not.Null);
        Assert.That(result.CustomerId, Is.EqualTo(customerId));
        Assert.That(result.OrderItems.Count, Is.EqualTo(2));
        Assert.That(result.Status, Is.EqualTo(OrderStatus.Draft));
        
        // Verify in database
        var orderInDb = await _context.Orders
            .Include(o => o.OrderItems)
            .FirstOrDefaultAsync(o => o.Id == result.Id);
            
        Assert.That(orderInDb, Is.Not.Null);
        Assert.That(orderInDb.OrderItems.Count, Is.EqualTo(2));
    }

    private void SeedTestData()
    {
        var customer = new Customer 
        { 
            Id = 1, 
            FirstName = "Test", 
            LastName = "Customer", 
            Email = "test@example.com" 
        };
        
        var product1 = new Product 
        { 
            Id = 1, 
            Name = "Product 1", 
            UnitPrice = 10.00m 
        };
        
        var product2 = new Product 
        { 
            Id = 2, 
            Name = "Product 2", 
            UnitPrice = 15.00m 
        };
        
        _context.Customers.Add(customer);
        _context.Products.Add(product1);
        _context.Products.Add(product2);
        _context.SaveChanges();
    }

    [OneTimeTearDown]
    public void OneTimeTearDown()
    {
        _context?.Dispose();
        _container?.Dispose();
    }
}
```

## Configuration Management

### App.config/Web.config Configuration
```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <configSections>
    <section name="entityFramework" type="System.Data.Entity.Internal.ConfigFile.EntityFrameworkSection, EntityFramework" />
    <section name="nlog" type="NLog.Config.ConfigSectionHandler, NLog" />
    <section name="autofac" type="Autofac.Configuration.SectionHandler, Autofac.Configuration" />
  </configSections>

  <connectionStrings>
    <add name="DefaultConnection" 
         connectionString="Data Source=localhost;Initial Catalog=OrderManagement;Integrated Security=true;Connect Timeout=30;Command Timeout=300" 
         providerName="System.Data.SqlClient" />
    <add name="TestConnection" 
         connectionString="Data Source=localhost;Initial Catalog=OrderManagement_Test;Integrated Security=true" 
         providerName="System.Data.SqlClient" />
  </connectionStrings>

  <appSettings>
    <!-- Application Settings -->
    <add key="Environment" value="Development" />
    <add key="ApplicationName" value="Order Management System" />
    <add key="ApplicationVersion" value="1.0.0" />
    
    <!-- Feature Settings -->
    <add key="MaxOrderItems" value="50" />
    <add key="OrderTimeoutMinutes" value="60" />
    <add key="ProcessingIntervalMinutes" value="5" />
    <add key="HealthCheckIntervalMinutes" value="1" />
    
    <!-- External Service Settings -->
    <add key="NotificationServiceUrl" value="https://api.notifications.example.com" />
    <add key="NotificationServiceApiKey" value="your-api-key-here" />
    <add key="PaymentServiceUrl" value="https://api.payments.example.com" />
    
    <!-- Cache Settings -->
    <add key="CacheExpirationMinutes" value="15" />
    <add key="EnableCaching" value="true" />
    
    <!-- Retry Settings -->
    <add key="MaxRetryAttempts" value="3" />
    <add key="RetryDelaySeconds" value="5" />
  </appSettings>

  <entityFramework>
    <defaultConnectionFactory type="System.Data.Entity.Infrastructure.LocalDbConnectionFactory, EntityFramework">
      <parameters>
        <parameter value="mssqllocaldb" />
      </parameters>
    </defaultConnectionFactory>
    <providers>
      <provider invariantName="System.Data.SqlClient" type="System.Data.Entity.SqlServer.SqlProviderServices, EntityFramework.SqlServer" />
    </providers>
  </entityFramework>

  <system.web>
    <compilation debug="false" targetFramework="4.7.2" />
    <httpRuntime targetFramework="4.7.2" maxRequestLength="51200" executionTimeout="300" />
    <customErrors mode="RemoteOnly" defaultRedirect="~/Error" />
    
    <authentication mode="None" />
    <authorization>
      <allow users="*" />
    </authorization>
  </system.web>

  <system.webServer>
    <handlers>
      <remove name="ExtensionlessUrlHandler-Integrated-4.0" />
      <add name="ExtensionlessUrlHandler-Integrated-4.0" path="*." verb="*" 
           type="System.Web.Handlers.TransferRequestHandler" 
           preCondition="integratedMode,runtimeVersionv4.0" />
    </handlers>
    
    <defaultDocument>
      <files>
        <clear />
        <add value="index.html" />
      </files>
    </defaultDocument>
  </system.webServer>

  <nlog>
    <targets>
      <target name="fileTarget" xsi:type="File"
              fileName="logs/${shortdate}.log"
              layout="${longdate} ${uppercase:${level}} ${logger} ${message} ${exception:format=tostring}" />
      <target name="eventLogTarget" xsi:type="EventLog"
              source="OrderManagement"
              layout="${message} ${exception:format=tostring}" />
    </targets>
    <rules>
      <logger name="*" minlevel="Info" writeTo="fileTarget" />
      <logger name="*" minlevel="Error" writeTo="eventLogTarget" />
    </rules>
  </nlog>
</configuration>
```

### Configuration Transformations
```xml
<!-- Web.Release.config -->
<?xml version="1.0" encoding="utf-8"?>
<configuration xmlns:xdt="http://schemas.microsoft.com/XML-Document-Transform">
  <connectionStrings>
    <add name="DefaultConnection"
         connectionString="Data Source=prod-server;Initial Catalog=OrderManagement_Prod;Integrated Security=true"
         xdt:Transform="SetAttributes" xdt:Locator="Match(name)"/>
  </connectionStrings>
  
  <appSettings>
    <add key="Environment" value="Production" xdt:Transform="SetAttributes" xdt:Locator="Match(key)"/>
    <add key="ProcessingIntervalMinutes" value="2" xdt:Transform="SetAttributes" xdt:Locator="Match(key)"/>
    <add key="NotificationServiceUrl" value="https://prod-api.notifications.example.com" xdt:Transform="SetAttributes" xdt:Locator="Match(key)"/>
  </appSettings>
  
  <system.web>
    <compilation xdt:Transform="RemoveAttributes(debug)" />
    <customErrors mode="On" xdt:Transform="Replace"/>
  </system.web>
  
  <nlog>
    <rules>
      <logger name="*" minlevel="Warn" writeTo="fileTarget" xdt:Transform="SetAttributes" xdt:Locator="Match(name)"/>
    </rules>
  </nlog>
</configuration>
```

## Deployment and Operations

### Build and Deployment Scripts
```batch
REM build-and-deploy.bat
@echo off
echo Starting build and deployment...

REM Restore NuGet packages
echo Restoring NuGet packages...
nuget restore OrderManagement.sln
if %ERRORLEVEL% NEQ 0 goto error

REM Build solution
echo Building solution...
msbuild OrderManagement.sln /p:Configuration=Release /p:Platform="Any CPU" /v:minimal
if %ERRORLEVEL% NEQ 0 goto error

REM Run unit tests
echo Running unit tests...
nunit3-console.exe OrderManagement.Tests.dll --result=TestResult.xml --where="cat==Unit"
if %ERRORLEVEL% NEQ 0 goto error

REM Deploy Web API
echo Deploying Web API...
msdeploy.exe -verb:sync -source:package=OrderManagement.Api.zip -dest:auto,ComputerName=%DEPLOY_SERVER%,UserName=%DEPLOY_USER%,Password=%DEPLOY_PASS%

REM Install/Update Windows Service
echo Updating Windows Service...
net stop OrderProcessingService
InstallUtil.exe /u OrderManagement.WindowsService.exe
xcopy "OrderManagement.WindowsService\bin\Release\*" "C:\Services\OrderProcessing\" /E /Y
InstallUtil.exe "C:\Services\OrderProcessing\OrderManagement.WindowsService.exe"
net start OrderProcessingService

echo Deployment completed successfully!
goto end

:error
echo Deployment failed with error code %ERRORLEVEL%
exit /b %ERRORLEVEL%

:end
```

### Monitoring and Health Checks
```csharp
// Health check endpoint
[Route("api/health")]
public class HealthController : ApiController
{
    private readonly FeatureDbContext _context;
    private readonly ILogger _logger;

    public HealthController(FeatureDbContext context, ILogger logger)
    {
        _context = context;
        _logger = logger;
    }

    [HttpGet]
    [Route("")]
    public async Task<IHttpActionResult> GetHealthStatus()
    {
        var healthStatus = new HealthStatus
        {
            Status = "Healthy",
            Timestamp = DateTime.UtcNow,
            Checks = new Dictionary<string, object>()
        };

        try
        {
            // Database connectivity check
            var dbConnected = await CheckDatabaseConnectivity();
            healthStatus.Checks["Database"] = dbConnected ? "Connected" : "Disconnected";
            if (!dbConnected) healthStatus.Status = "Unhealthy";

            // External service checks
            var notificationServiceUp = await CheckNotificationService();
            healthStatus.Checks["NotificationService"] = notificationServiceUp ? "Available" : "Unavailable";

            // Memory usage check
            var memoryUsage = GC.GetTotalMemory(false) / (1024 * 1024); // MB
            healthStatus.Checks["MemoryUsageMB"] = memoryUsage;
            if (memoryUsage > 500) healthStatus.Status = "Warning";

            // Application metrics
            healthStatus.Checks["Version"] = Assembly.GetExecutingAssembly().GetName().Version.ToString();
            healthStatus.Checks["Environment"] = ConfigurationManager.AppSettings["Environment"];

            var statusCode = healthStatus.Status == "Healthy" ? HttpStatusCode.OK : HttpStatusCode.ServiceUnavailable;
            return Content(statusCode, healthStatus, "application/json");
        }
        catch (Exception ex)
        {
            _logger.Error(ex, "Health check failed");
            healthStatus.Status = "Unhealthy";
            healthStatus.Checks["Error"] = ex.Message;
            return Content(HttpStatusCode.ServiceUnavailable, healthStatus, "application/json");
        }
    }

    private async Task<bool> CheckDatabaseConnectivity()
    {
        try
        {
            await _context.Database.ExecuteSqlCommandAsync("SELECT 1");
            return true;
        }
        catch
        {
            return false;
        }
    }

    private async Task<bool> CheckNotificationService()
    {
        try
        {
            var client = new HttpClient();
            client.Timeout = TimeSpan.FromSeconds(5);
            var response = await client.GetAsync(ConfigurationManager.AppSettings["NotificationServiceUrl"] + "/health");
            return response.IsSuccessStatusCode;
        }
        catch
        {
            return false;
        }
    }
}

public class HealthStatus
{
    public string Status { get; set; }
    public DateTime Timestamp { get; set; }
    public Dictionary<string, object> Checks { get; set; }
}
```

---

*Last updated: [Date]*
*Feature version: [Version]*
*Framework version: .NET Framework 4.7.2*
*Dependencies: [Key dependency versions]*