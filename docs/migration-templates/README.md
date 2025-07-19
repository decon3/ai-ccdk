# Migration Templates

This directory contains comprehensive migration guides for transitioning between different technology stacks using the Claude Code Development Kit.

## Available Migration Templates

### .NET Migrations

#### [`dotnet-framework-to-dotnet-core.md`](./dotnet-framework-to-dotnet-core.md)
**Source**: .NET Framework 4.7.2/4.8  
**Target**: .NET Core 8  
**Complexity**: High  
**Parallel Operation**: Supported  

Complete migration guide covering:
- Framework compatibility assessment
- Project structure transformation  
- API and library migrations
- Configuration management changes
- Parallel operation requirements
- Wire-level compatibility preservation
- Encryption and serialization compatibility

**Key Features:**
- Maintains enum/constant compatibility for parallel operation
- Preserves wire-level protocol compatibility
- Comprehensive security and performance validation
- Detailed rollback procedures

## Template Structure

Each migration template follows a standardized structure:

1. **Framework Compatibility Assessment**
2. **Project Structure Transformation** 
3. **API and Library Migrations**
4. **Code Pattern Updates**
5. **Configuration Management**
6. **Deployment and Infrastructure**
7. **Testing Framework Migration**
8. **Security Updates**
9. **Performance Considerations**
10. **Breaking Changes to Address**
11. **Parallel Operation & Data Compatibility** (when applicable)

## Usage with `/migrate` Command

These templates are automatically loaded by the `/migrate` command:

```bash
# Example usage
/migrate from=dotnet-framework-4-7-2 to=dotnet-core-8
```

The command will:
1. Parse the migration request
2. Load the appropriate template
3. Analyze the current project structure
4. Execute the migration following the template guidance
5. Validate the results

## Adding New Migration Templates

To add support for new migration paths:

1. **Create Template**: Add a new `.md` file following the naming pattern `source-to-target.md`
2. **Follow Structure**: Use the standardized template structure above
3. **Update Commands**: Add the new migration path to supported migrations in `commands/migrate.md`
4. **Test Migration**: Validate the migration template with real projects

### Template Naming Convention

- Use lowercase with hyphens: `source-technology-to-target-technology.md`
- Be specific about versions: `dotnet-framework-4-7-2-to-dotnet-core-8.md`
- Use consistent technology names across templates

### Required Sections

Every migration template must include:
- **Compatibility Assessment**: What changes between source and target
- **Breaking Changes**: Critical changes that require attention
- **Step-by-Step Guide**: Detailed migration procedures
- **Validation Steps**: How to verify successful migration
- **Rollback Procedures**: How to revert if needed

## Integration with CCDK

Migration templates integrate with the broader Claude Code Development Kit:

- **Auto-Loading**: Templates are automatically loaded by migration commands
- **Context Injection**: Templates receive project context automatically
- **MCP Integration**: Templates can leverage external documentation and consultation
- **Security Scanning**: Migration results are validated using security hooks
- **Documentation Updates**: Post-migration documentation is automatically updated

## Best Practices

### Template Development
- **Real-World Testing**: Test templates with actual migration projects
- **Community Feedback**: Gather feedback from migration experiences
- **Version Updates**: Keep templates current with latest framework versions
- **Clear Examples**: Include concrete code examples for transformations

### Migration Execution
- **Incremental Approach**: Migrate in phases with validation points
- **Backup Strategy**: Always backup before starting migration
- **Parallel Testing**: When applicable, run both systems in parallel
- **Team Communication**: Document migration process for team awareness

---

*These templates are designed to work with the Claude Code Development Kit's migration orchestration system, providing comprehensive guidance for complex technology stack transitions.*