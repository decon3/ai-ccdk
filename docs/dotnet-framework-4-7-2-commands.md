# .NET Framework 4.7.2 Development Commands

This document provides comprehensive .NET Framework 4.7.2 development commands for integration into CLAUDE.md files.

## Solution and Project Management

### Solution Operations
```bash
# Create new solution
devenv /command "File.NewProject" "Visual C#\Windows\Class Library"

# Build solution
msbuild YourSolution.sln
msbuild YourSolution.sln /p:Configuration=Release
msbuild YourSolution.sln /p:Configuration=Debug /p:Platform="Any CPU"

# Clean solution
msbuild YourSolution.sln /t:Clean
msbuild YourSolution.sln /t:Clean /p:Configuration=Release

# Rebuild solution
msbuild YourSolution.sln /t:Rebuild
msbuild YourSolution.sln /t:Rebuild /p:Configuration=Release

# Build specific project
msbuild YourProject.csproj
msbuild YourProject.csproj /p:Configuration=Release /p:OutputPath=..\bin\
```

### Project File Operations
```bash
# Create new projects
# Console Application
dotnet new console -n YourProject.Console -f net472

# Class Library
dotnet new classlib -n YourProject.Core -f net472

# Web API (manual creation required for .NET Framework)
# Use Visual Studio templates or copy existing structure

# Add project references
# Edit .csproj file manually or use Visual Studio
```

## NuGet Package Management

### Package Installation and Management
```bash
# Restore packages for solution
nuget restore YourSolution.sln
nuget restore YourSolution.sln -PackagesDirectory packages

# Install packages
nuget install packages.config -OutputDirectory packages
nuget install EntityFramework -Version 6.4.4 -OutputDirectory packages

# Update packages
nuget update packages.config
nuget update EntityFramework -Source https://api.nuget.org/v3/index.json

# List installed packages
nuget list -Source packages

# Pack project into NuGet package
nuget pack YourProject.nuspec
nuget pack YourProject.csproj -Properties Configuration=Release

# Push package to repository
nuget push YourPackage.1.0.0.nupkg -Source https://api.nuget.org/v3/index.json -ApiKey YOUR_API_KEY

# Search for packages
nuget search EntityFramework
nuget search AutoMapper -Source https://api.nuget.org/v3/index.json
```

### Package Configuration
```bash
# Generate packages.config from project
nuget restore YourProject.csproj -PackagesConfigOutputDirectory .

# Migrate packages.config to PackageReference (requires tools)
dotnet migrate-2017 --project-path YourProject.csproj

# Check for package vulnerabilities
nuget audit
nuget verify -signatures
```

## Build Operations

### MSBuild Commands
```bash
# Basic build operations
msbuild /version
msbuild YourProject.csproj /t:Build
msbuild YourProject.csproj /t:Clean
msbuild YourProject.csproj /t:Rebuild

# Build with specific configuration
msbuild YourProject.csproj /p:Configuration=Release
msbuild YourProject.csproj /p:Configuration=Debug
msbuild YourProject.csproj /p:Platform=x64

# Build with output directory
msbuild YourProject.csproj /p:OutputPath=..\bin\Release\
msbuild YourProject.csproj /p:OutDir=C:\Deploy\

# Verbose build output
msbuild YourProject.csproj /verbosity:detailed
msbuild YourProject.csproj /v:diag /fl /flp:logfile=build.log

# Parallel builds
msbuild YourSolution.sln /maxcpucount:4
msbuild YourSolution.sln /m

# Build with warnings as errors
msbuild YourProject.csproj /p:TreatWarningsAsErrors=true
msbuild YourProject.csproj /p:WarningsAsErrors=CS0618
```

### Advanced Build Options
```bash
# Build with code analysis
msbuild YourProject.csproj /p:RunAnalysis=true
msbuild YourProject.csproj /p:CodeAnalysisRuleSet=..\rules.ruleset

# Build with strong naming
msbuild YourProject.csproj /p:AssemblyOriginatorKeyFile=key.snk /p:SignAssembly=true

# Build with specific target framework
msbuild YourProject.csproj /p:TargetFrameworkVersion=v4.7.2

# Build with preprocessor directives
msbuild YourProject.csproj /p:DefineConstants="DEBUG;TRACE;CUSTOM"

# Build with specific runtime
msbuild YourProject.csproj /p:PlatformTarget=x86
msbuild YourProject.csproj /p:PlatformTarget=x64
msbuild YourProject.csproj /p:PlatformTarget=AnyCPU
```

## Testing Framework Commands

### NUnit Testing
```bash
# Install NUnit console runner
nuget install NUnit.ConsoleRunner -OutputDirectory packages

# Run NUnit tests
packages\NUnit.ConsoleRunner.3.15.0\tools\nunit3-console.exe YourProject.Tests.dll
nunit3-console.exe YourProject.Tests.dll --result=TestResult.xml
nunit3-console.exe YourProject.Tests.dll --where="cat==Unit"

# Run tests with coverage (using OpenCover)
packages\OpenCover.4.7.922\tools\OpenCover.Console.exe -target:"nunit3-console.exe" -targetargs:"YourProject.Tests.dll" -output:coverage.xml

# Generate coverage reports
packages\ReportGenerator.4.8.13\tools\net47\ReportGenerator.exe -reports:coverage.xml -targetdir:coverage-report
```

### MSTest Testing
```bash
# Run MSTest tests
mstest.exe /testcontainer:YourProject.Tests.dll
mstest.exe /testcontainer:YourProject.Tests.dll /resultsfile:TestResults.trx

# Run specific test methods
mstest.exe /testcontainer:YourProject.Tests.dll /test:TestMethodName
mstest.exe /testcontainer:YourProject.Tests.dll /testcategory:Unit

# Run tests with settings
mstest.exe /testcontainer:YourProject.Tests.dll /testsettings:test.testsettings
```

### xUnit Testing
```bash
# Install xUnit runner
nuget install xunit.runner.console -OutputDirectory packages

# Run xUnit tests
packages\xunit.runner.console.2.4.1\tools\net472\xunit.console.exe YourProject.Tests.dll
xunit.console.exe YourProject.Tests.dll -xml TestResults.xml
xunit.console.exe YourProject.Tests.dll -trait "Category=Unit"

# Run tests with parallel execution
xunit.console.exe YourProject.Tests.dll -parallel all
xunit.console.exe YourProject.Tests.dll -parallel collections
```

## Entity Framework Commands

### Entity Framework 6.x Commands (Package Manager Console)
```powershell
# Enable migrations
Enable-Migrations -ProjectName YourProject.Data
Enable-Migrations -Force -ProjectName YourProject.Data

# Add migration
Add-Migration InitialCreate -ProjectName YourProject.Data
Add-Migration AddCustomerTable -ProjectName YourProject.Data

# Update database
Update-Database -ProjectName YourProject.Data
Update-Database -TargetMigration:InitialCreate -ProjectName YourProject.Data

# Generate script
Update-Database -Script -ProjectName YourProject.Data
Update-Database -Script -SourceMigration:InitialCreate -TargetMigration:AddCustomers

# Get migration history
Get-Migrations -ProjectName YourProject.Data

# Scaffold DbContext from existing database
Scaffold-DbContext "connection-string" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models -ProjectName YourProject.Data
```

### EF Command Line (ef6.exe)
```bash
# Install EF6 command line tools
nuget install EntityFramework -OutputDirectory packages

# Database operations
packages\EntityFramework.6.4.4\tools\ef6.exe database update --connection-string "your-connection-string" --config-file App.config
packages\EntityFramework.6.4.4\tools\ef6.exe migrations add InitialCreate --config-file App.config

# Generate migration script
packages\EntityFramework.6.4.4\tools\ef6.exe migrations script --config-file App.config
```

## Web API Development

### IIS Express Operations
```bash
# Start IIS Express
iisexpress.exe /config:applicationhost.config /site:YourSite
iisexpress.exe /path:C:\YourApp /port:8080
iisexpress.exe /config:".vs\config\applicationhost.config" /site:"YourProject.Api"

# List IIS Express sites
iisexpress.exe /config:applicationhost.config /listSites

# Stop IIS Express
taskkill /IM iisexpress.exe /F
```

### IIS Deployment
```bash
# Create application pool
%windir%\system32\inetsrv\appcmd.exe add apppool /name:"YourAppPool" /managedRuntimeVersion:"v4.0"

# Create web application
%windir%\system32\inetsrv\appcmd.exe add app /site.name:"Default Web Site" /path:/YourApp /physicalPath:"C:\inetpub\wwwroot\YourApp"

# Set application pool
%windir%\system32\inetsrv\appcmd.exe set app "Default Web Site/YourApp" /applicationPool:"YourAppPool"

# List applications
%windir%\system32\inetsrv\appcmd.exe list app

# Start/Stop application pool
%windir%\system32\inetsrv\appcmd.exe start apppool "YourAppPool"
%windir%\system32\inetsrv\appcmd.exe stop apppool "YourAppPool"
```

## Windows Service Development

### Service Installation (InstallUtil)
```bash
# Install service
%windir%\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe YourService.exe
InstallUtil.exe YourService.exe

# Uninstall service
InstallUtil.exe /u YourService.exe

# Install with custom parameters
InstallUtil.exe /LogFile=install.log /LogToConsole=true YourService.exe
```

### Service Control
```bash
# Start service
net start YourServiceName
sc start YourServiceName

# Stop service
net stop YourServiceName
sc stop YourServiceName

# Query service status
sc query YourServiceName
sc queryex YourServiceName

# Configure service
sc config YourServiceName start=auto
sc config YourServiceName obj=LocalSystem
sc config YourServiceName depend="MSSQLSERVER"

# Delete service
sc delete YourServiceName
```

### TopShelf Service Management
```bash
# Install TopShelf service
YourService.exe install
YourService.exe install -servicename:CustomName -displayname:"Custom Display Name"

# Start/Stop TopShelf service
YourService.exe start
YourService.exe stop

# Uninstall TopShelf service
YourService.exe uninstall

# Run as console application
YourService.exe console
YourService.exe help
```

## Code Quality and Analysis

### Code Analysis Tools
```bash
# Run FxCop analysis
FxCopCmd.exe /f:YourAssembly.dll /o:CodeAnalysisResults.xml
FxCopCmd.exe /project:YourProject.fxcop /out:Results.xml

# Run StyleCop
packages\StyleCop.MSBuild.6.0.0\tools\StyleCop.exe -project YourProject.csproj
```

### Static Analysis
```bash
# Run Visual Studio Code Analysis
msbuild YourProject.csproj /p:RunAnalysis=true
msbuild YourProject.csproj /p:RunCodeAnalysis=true /p:CodeAnalysisRuleSet=rules.ruleset

# Run SonarQube analysis (requires SonarQube Scanner)
SonarScanner.MSBuild.exe begin /k:"project-key" /d:sonar.host.url="http://localhost:9000"
msbuild YourSolution.sln /p:Configuration=Release
SonarScanner.MSBuild.exe end
```

## Performance and Profiling

### Performance Counter Commands
```bash
# List performance counters
typeperf -q ".NET CLR Memory"
typeperf -qx ".NET CLR Exceptions"

# Monitor performance counters
typeperf ".NET CLR Memory(*)\Gen 0 heap size" -sc 10
typeperf -cf counters.txt -o performance.csv -sc 100

# Create custom performance counters
lodctr /C:counter.ini
unlodctr YourApplication
```

### Memory Dump Analysis
```bash
# Create memory dump
procdump.exe -ma YourProcess.exe dump.dmp
procdump.exe -e -x dump.dmp YourProcess.exe

# Analyze with DebugDiag
DebugDiag.exe -dump dump.dmp -hang -o report.html
```

## Debugging Commands

### Debug Build Configuration
```bash
# Build with debug symbols
msbuild YourProject.csproj /p:Configuration=Debug /p:DebugSymbols=true /p:DebugType=full

# Attach debugger
vsjitdebugger.exe -p ProcessId
```

### Assembly and GAC Operations
```bash
# Register assembly in GAC
gacutil.exe /i YourAssembly.dll
gacutil.exe /if YourAssembly.dll

# Unregister from GAC
gacutil.exe /u YourAssembly

# List GAC assemblies
gacutil.exe /l
gacutil.exe /l YourAssembly

# Verify strong name
sn.exe -v YourAssembly.dll
sn.exe -vf YourAssembly.dll
```

## Configuration Management

### Configuration Transformation
```bash
# Transform web.config
msbuild YourProject.csproj /p:Configuration=Release /p:TransformWebConfigEnabled=true
msbuild YourProject.csproj /p:Configuration=Production /p:PublishProfile=FolderProfile
```

### Configuration Encryption
```bash
# Encrypt connection strings
aspnet_regiis.exe -pef "connectionStrings" "C:\YourApp" -prov "RsaProtectedConfigurationProvider"

# Decrypt connection strings
aspnet_regiis.exe -pdf "connectionStrings" "C:\YourApp"

# Create RSA key container
aspnet_regiis.exe -pc "YourKeyContainer" -exp
aspnet_regiis.exe -pa "YourKeyContainer" "NT AUTHORITY\NETWORK SERVICE"
```

## Deployment Operations

### Web Deploy (MSDeploy)
```bash
# Deploy to IIS
msdeploy.exe -verb:sync -source:package=YourApp.zip -dest:auto,ComputerName=server,UserName=user,Password=pass

# Sync directories
msdeploy.exe -verb:sync -source:dirPath=C:\Source -dest:dirPath=C:\Destination

# Backup before deploy
msdeploy.exe -verb:sync -source:package=YourApp.zip -dest:auto,ComputerName=server -enableRule:BackupRule
```

### ClickOnce Deployment
```bash
# Publish ClickOnce application
msbuild YourProject.csproj /target:Publish /property:PublishUrl=\\server\share\

# Update ClickOnce manifest
mage.exe -Update YourApp.application -AppCodeBase YourApp.exe.manifest
```

### MSI Deployment
```bash
# Build MSI installer (requires WiX Toolset)
candle.exe YourInstaller.wxs
light.exe -out YourInstaller.msi YourInstaller.wixobj

# Install MSI
msiexec.exe /i YourInstaller.msi /quiet /l*v install.log

# Uninstall MSI
msiexec.exe /x YourInstaller.msi /quiet
```

## Security Commands

### Certificate Management
```bash
# Import certificate
certutil.exe -addstore "My" certificate.cer
certutil.exe -importPFX certificate.pfx

# Export certificate
certutil.exe -exportPFX "My" "certificate-name" certificate.pfx

# List certificates
certutil.exe -store "My"
certutil.exe -store -user "My"
```

### Security Policy
```bash
# Configure .NET security policy
caspol.exe -machine -list
caspol.exe -machine -addgroup All_Code -url file://C:\YourApp\* FullTrust -name "YourApp"

# Reset security policy
caspol.exe -machine -reset
caspol.exe -user -reset
```

## Development Workflow Scripts

### Build Script (build.bat)
```batch
@echo off
echo Building solution...

:: Restore NuGet packages
nuget restore YourSolution.sln

:: Build solution
msbuild YourSolution.sln /p:Configuration=Release /p:Platform="Any CPU" /v:minimal

if %ERRORLEVEL% NEQ 0 (
    echo Build failed!
    exit /b 1
)

echo Build completed successfully!
```

### Test Script (test.bat)
```batch
@echo off
echo Running tests...

:: Run unit tests
nunit3-console.exe YourProject.Tests.dll --result=TestResult.xml --where="cat==Unit"

:: Run integration tests
nunit3-console.exe YourProject.Integration.Tests.dll --result=IntegrationTestResult.xml

if %ERRORLEVEL% NEQ 0 (
    echo Tests failed!
    exit /b 1
)

echo All tests passed!
```

### Deploy Script (deploy.bat)
```batch
@echo off
set TARGET_SERVER=%1
set DEPLOY_PATH=%2

if "%TARGET_SERVER%"=="" (
    echo Usage: deploy.bat ^<server^> ^<path^>
    exit /b 1
)

echo Deploying to %TARGET_SERVER%...

:: Build for release
msbuild YourSolution.sln /p:Configuration=Release

:: Deploy using robocopy
robocopy "bin\Release" "\\%TARGET_SERVER%\%DEPLOY_PATH%" /MIR /R:3 /W:10

echo Deployment completed!
```

## Makefile Integration

### Common .NET Framework commands in Makefile
```makefile
# Variables
SOLUTION = YourSolution.sln
CONFIGURATION = Release
MSBUILD = msbuild
NUNIT = packages\NUnit.ConsoleRunner.3.15.0\tools\nunit3-console.exe

.PHONY: build clean test restore deploy

# Default target
all: restore build test

# Restore NuGet packages
restore:
	nuget restore $(SOLUTION)

# Build solution
build:
	$(MSBUILD) $(SOLUTION) /p:Configuration=$(CONFIGURATION)

# Clean solution
clean:
	$(MSBUILD) $(SOLUTION) /t:Clean /p:Configuration=$(CONFIGURATION)

# Rebuild solution
rebuild: clean build

# Run tests
test:
	$(NUNIT) YourProject.Tests.dll --result=TestResult.xml

# Run only unit tests
test-unit:
	$(NUNIT) YourProject.Tests.dll --where="cat==Unit"

# Run only integration tests
test-integration:
	$(NUNIT) YourProject.Integration.Tests.dll

# Package for deployment
package: build
	if not exist "deploy" mkdir deploy
	xcopy "YourProject.Api\bin\$(CONFIGURATION)\*" "deploy\" /E /Y
	xcopy "YourProject.WindowsService\bin\$(CONFIGURATION)\*" "deploy\service\" /E /Y

# Deploy to local IIS
deploy-local: package
	iisreset /stop
	xcopy "deploy\*" "C:\inetpub\wwwroot\YourApp\" /E /Y
	iisreset /start

# Install Windows service
install-service:
	InstallUtil.exe YourProject.WindowsService.exe
	net start YourServiceName

# Uninstall Windows service
uninstall-service:
	net stop YourServiceName
	InstallUtil.exe /u YourProject.WindowsService.exe
```

These commands provide comprehensive coverage of .NET Framework 4.7.2 development workflows and can be integrated into your CLAUDE.md file for AI-assisted .NET Framework development.