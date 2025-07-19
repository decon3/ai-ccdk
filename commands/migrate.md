You are working on the current project. The user has requested to migrate from one technology stack to another using the format: "$ARGUMENTS"

## Auto-Loaded Project Context:
@/CLAUDE.md
@/docs/ai-context/project-structure.md
@/docs/ai-context/docs-overview.md

## Step 1: Parse Migration Arguments

Extract the source and target technologies from the user's arguments in format "from=source-tech to=target-tech".

**Example parsing:**
- Input: "from=dotnet-framework-4-7-2 to=dotnet-core-8"
- Extract: source="dotnet-framework-4-7-2", target="dotnet-core-8"

**Supported Migration Paths:**
- `dotnet-framework-4-7-2` → `dotnet-core-8`: .NET Framework 4.7.2 to .NET Core 8
- `dotnet-framework-4-8` → `dotnet-core-8`: .NET Framework 4.8 to .NET Core 8
- More migration paths can be added in the future

## Step 2: Validate Migration Request

1. **Verify Source Technology**: Analyze the current project structure to confirm it matches the specified source technology
2. **Check Target Compatibility**: Ensure the target technology is supported and compatible
3. **Load Migration Template**: Read the appropriate migration template from `/docs/migration-templates/` directory based on the migration path

If no specific migration arguments are provided, analyze the current project to suggest available migration paths.

## Step 3: Migration Analysis

Perform comprehensive analysis of the migration requirements:

### Project Structure Analysis
- Map current file organization and project types
- Identify configuration files that need transformation
- Catalog dependencies and packages that need updating
- Assess custom code patterns that need modernization

### Compatibility Assessment
- Identify breaking changes between source and target technologies
- Flag API changes that require code updates
- Assess performance implications
- Evaluate security considerations

### Dependency Mapping
- Map old packages to new equivalents
- Identify packages that are no longer needed
- Flag dependencies that don't have direct equivalents
- Plan NuGet package.config to PackageReference migration

### Configuration Migration
- Plan app.config/web.config to appsettings.json transformation
- Identify connection string format changes
- Map configuration sections to new patterns
- Plan environment-specific configuration strategy

## Step 4: Migration Planning

Based on the analysis, create a detailed migration plan:

### Pre-Migration Checklist
- [ ] Backup current codebase
- [ ] Document current system configuration
- [ ] Verify all tests are passing
- [ ] Document external service dependencies
- [ ] Plan parallel operation strategy (if required)

### Migration Phases
1. **Project Structure Migration**: Convert project files and solution structure
2. **Dependency Migration**: Update packages and references
3. **Code Migration**: Transform source code patterns
4. **Configuration Migration**: Convert configuration files
5. **Testing Migration**: Update test frameworks and patterns
6. **Deployment Migration**: Update build and deployment processes

### Post-Migration Validation
- [ ] Verify all projects build successfully
- [ ] Confirm all tests pass
- [ ] Validate configuration loading
- [ ] Test API compatibility (for parallel operation)
- [ ] Performance comparison with original system

## Step 5: Migration Execution

Execute the migration in phases, providing clear progress updates:

### Phase 1: Project Structure
- Convert .csproj files to SDK-style format
- Update solution file structure
- Create new directory organization if needed
- Update global.json and Directory.Build.props

### Phase 2: Dependencies
- Convert packages.config to PackageReference
- Update package versions to target technology equivalents
- Remove obsolete packages
- Add new target technology packages

### Phase 3: Code Transformation
- Update using statements and namespace imports
- Transform API calls to new equivalents
- Update async/await patterns for new framework
- Modernize language features (nullable reference types, etc.)

### Phase 4: Configuration
- Convert app.config/web.config to appsettings.json
- Update connection string formats
- Transform authentication configuration
- Set up environment-specific configurations

### Phase 5: Testing
- Update test project structures
- Migrate test frameworks if needed
- Update test helper libraries
- Verify integration test compatibility

### Phase 6: Documentation
- Update project documentation
- Create migration notes for team
- Document parallel operation procedures (if applicable)
- Update deployment instructions

## Step 6: Parallel Operation Support

For migrations requiring parallel operation (like .NET Framework → .NET Core):

### Wire-Level Compatibility
- Ensure identical API endpoint contracts
- Maintain consistent serialization formats
- Preserve enum values and constants
- Validate encryption/decryption compatibility

### Data Compatibility
- Test shared encryption keys work in both systems
- Verify database compatibility
- Validate message queue format consistency
- Ensure external service integration compatibility

### Monitoring Setup
- Set up side-by-side comparison monitoring
- Create health checks for both systems
- Plan gradual traffic shifting strategy
- Prepare rollback procedures

## Step 7: Migration Validation

After migration completion:

### Build Verification
- Confirm clean builds in target technology
- Verify no compilation warnings
- Test debug and release configurations
- Validate package restoration

### Functional Testing
- Run all unit tests
- Execute integration tests
- Perform end-to-end testing
- Validate external service integrations

### Performance Validation
- Compare performance metrics
- Monitor memory usage patterns
- Assess startup times
- Evaluate throughput under load

### Security Verification
- Run security scans on new codebase
- Verify authentication flows
- Test authorization policies
- Validate data encryption

## Step 8: Migration Completion

Provide comprehensive migration summary:

### Migration Results
- List all files created/modified
- Document configuration changes made
- Summarize package migrations performed
- Report any manual steps required

### Next Steps
- Deployment preparation checklist
- Team training requirements
- Documentation updates needed
- Monitoring setup recommendations

### Potential Issues
- Known limitations in the migration
- Manual verification steps required
- Performance considerations
- Compatibility notes for parallel operation

## Error Handling

- **Invalid Arguments**: Guide user on correct format and supported migrations
- **Unsupported Migration**: List available migration paths and suggest alternatives
- **Project Mismatch**: Explain detected vs specified technology mismatch
- **Migration Conflicts**: Provide resolution steps for common issues

## MCP Server Integration (Optional)

Consider leveraging MCP servers for complex migration decisions:
- **Context7**: Get latest documentation for target technology
- **Gemini**: Complex architectural guidance for migration strategy

Now proceed with migration analysis and execution for: $ARGUMENTS