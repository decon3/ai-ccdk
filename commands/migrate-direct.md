You are working on the current project. The user has requested to migrate from one technology stack to another using the format: "$ARGUMENTS"

## Auto-Loaded Project Context:
@/CLAUDE.md
@/docs/ai-context/project-structure.md
@/docs/ai-context/docs-overview.md

## Direct Migration Approach

This is the direct (single-agent) version of the migration command, designed for simpler migration scenarios or when sub-agent orchestration is not desired.

## Step 1: Parse and Validate Migration Arguments

Extract the source and target technologies from the user's arguments:

**Expected Format**: `from=source-technology to=target-technology`

**Supported Migration Paths:**
- `dotnet-framework-4-7-2` → `dotnet-core-8`
- `dotnet-framework-4-8` → `dotnet-core-8`

**Validation Steps:**
1. Parse arguments to extract source and target
2. Verify the migration path is supported
3. Analyze current project to confirm source technology match
4. Load appropriate migration template from `/docs/migration-templates/` directory

## Step 2: Comprehensive Migration Analysis

Perform direct analysis of the entire migration scope:

### Current State Assessment
- Examine project structure and organization
- Catalog all dependencies and packages
- Identify configuration files and patterns
- Map custom code that needs updating
- Document external service integrations

### Target Technology Requirements
- Identify new project structure patterns
- Map package migrations (old → new)
- Plan configuration transformation strategy
- Assess code modernization opportunities
- Evaluate performance and security improvements

### Migration Complexity Assessment
- Identify high-risk changes
- Flag manual intervention requirements
- Plan testing and validation strategy
- Assess parallel operation needs
- Document rollback procedures

## Step 3: Create Migration Execution Plan

Develop a comprehensive step-by-step migration plan:

### Pre-Migration Preparation
1. **Backup Strategy**: Create comprehensive backup of current codebase
2. **Environment Documentation**: Document current development and deployment setup
3. **Dependency Audit**: List all current packages and their versions
4. **Test Baseline**: Ensure all tests pass before migration
5. **Integration Points**: Document all external service dependencies

### Migration Execution Phases

#### Phase 1: Project Structure Migration
- Convert solution and project files to target technology format
- Update build configuration and MSBuild properties
- Transform project dependencies and references
- Create new directory structure if needed

#### Phase 2: Package and Dependency Migration
- Convert package management format (packages.config → PackageReference)
- Update package versions to target technology equivalents
- Remove obsolete dependencies
- Add new framework-specific packages

#### Phase 3: Source Code Transformation
- Update namespace and using statements
- Transform API calls to new framework equivalents
- Modernize language features and patterns
- Update async/await implementation patterns
- Handle nullable reference types

#### Phase 4: Configuration Migration
- Transform configuration files (app.config/web.config → appsettings.json)
- Update connection string formats
- Migrate authentication and authorization configuration
- Set up environment-specific configuration patterns

#### Phase 5: Testing Framework Migration
- Update test project structure and framework
- Migrate test helper libraries and utilities
- Transform integration test setup
- Update mocking and assertion patterns

#### Phase 6: Build and Deployment
- Update build scripts and CI/CD pipelines
- Transform deployment configuration
- Update containerization (if applicable)
- Plan production deployment strategy

## Step 4: Execute Migration

Perform the actual migration with detailed progress tracking:

### Execution Strategy
1. **Incremental Approach**: Migrate one component at a time
2. **Validation Points**: Test after each major change
3. **Rollback Ready**: Maintain ability to revert changes
4. **Documentation**: Record all changes made

### Progress Monitoring
- Report completion of each migration phase
- Document any issues encountered and resolutions
- Track manual intervention requirements
- Validate successful completion of each step

## Step 5: Parallel Operation Support (When Required)

For migrations requiring both systems to run in parallel:

### Compatibility Assurance
- **API Contract Preservation**: Ensure identical endpoint behavior
- **Data Format Consistency**: Maintain serialization compatibility
- **Enum and Constants**: Preserve exact values and ordering
- **Encryption Compatibility**: Verify shared encryption works across both systems

### Validation Testing
- **Side-by-Side Testing**: Compare outputs from both systems
- **Load Testing**: Verify performance parity
- **Integration Testing**: Confirm external service compatibility
- **Data Consistency**: Validate shared data integrity

### Deployment Strategy
- **Gradual Rollout**: Plan phased traffic shifting
- **Monitoring Setup**: Implement comparison monitoring
- **Rollback Procedures**: Define quick reversion process
- **Team Communication**: Document parallel operation procedures

## Step 6: Post-Migration Validation

Comprehensive validation of the completed migration:

### Technical Validation
- **Build Verification**: Confirm clean compilation
- **Test Execution**: Verify all tests pass
- **Performance Testing**: Compare performance metrics
- **Security Scanning**: Run security analysis on new codebase

### Functional Validation
- **Feature Testing**: Verify all features work correctly
- **Integration Testing**: Confirm external service connectivity
- **User Acceptance**: Validate user-facing functionality
- **Data Integrity**: Verify data processing accuracy

### Documentation and Handoff
- **Migration Report**: Document all changes made
- **Known Issues**: Record any limitations or known problems
- **Deployment Guide**: Update deployment procedures
- **Team Training**: Identify training needs for new technology

## Step 7: Migration Completion Summary

Provide comprehensive summary of migration results:

### Success Metrics
- Files successfully migrated
- Dependencies updated
- Configuration files transformed
- Tests passing
- Performance comparison

### Manual Follow-Up Required
- Items requiring manual intervention
- Team training recommendations
- Documentation updates needed
- Monitoring setup requirements

### Risk Assessment
- Identified risks and mitigation strategies
- Rollback procedures if needed
- Performance considerations
- Security implications

## Error Handling and Recovery

### Common Issues and Solutions
- **Compilation Errors**: Systematic approach to resolving build issues
- **Package Conflicts**: Dependency resolution strategies
- **Configuration Problems**: Troubleshooting configuration loading
- **Test Failures**: Strategies for updating and fixing tests

### Recovery Procedures
- **Partial Rollback**: Revert specific components if needed
- **Full Rollback**: Complete reversion to original state
- **Issue Escalation**: When to seek additional help
- **Documentation**: Record lessons learned

## Integration with Existing Tools

### MCP Server Usage (Optional)
- **Context7**: Access latest documentation for target technology
- **Gemini**: Consult on complex architectural decisions

### CCDK Integration
- **Documentation Updates**: Update project documentation post-migration
- **Security Scanning**: Apply security hooks to validate migration safety
- **Notification**: Use audio notifications for completion (if enabled)

Now proceed with direct migration analysis and execution for: $ARGUMENTS