You are working on the current project. Create or regenerate documentation based on the user's request "$ARGUMENTS" using direct analysis without sub-agents.

## Auto-Loaded Project Context:
@/CLAUDE.md
@/docs/ai-context/project-structure.md
@/docs/ai-context/docs-overview.md

## Direct Documentation Creation Approach

### Step 1: Parse Target and Assess Requirements
Analyze the user's request "$ARGUMENTS" to determine:
- Target documentation path and type (Tier 2 or Tier 3)
- What needs to be documented (component, feature, or API)
- Scope and level of detail required

### Step 2: Gather Information Directly
Collect necessary information using direct analysis:

1. **Examine Target Directory/Component**
   - Use file system tools to explore the structure
   - Read key source files to understand implementation
   - Identify main patterns and architectural decisions

2. **Review Existing Documentation**
   - Check for existing CONTEXT.md files in the area
   - Review related documentation for consistency
   - Identify gaps and overlaps

3. **Analyze Dependencies and Integration**
   - Use search tools to find import/export patterns
   - Identify key integration points
   - Map relationships with other components

### Step 3: Determine Documentation Template
Based on target classification:
- **Tier 2 (Component-Level)**: Use component template focusing on architecture and integration
- **Tier 3 (Feature-Specific)**: Use feature template focusing on implementation details

### Step 4: Generate Documentation Content
Create comprehensive documentation including:

#### For Component-Level Documentation:
- Component purpose and responsibilities
- Current status and evolution context
- Development guidelines specific to the component
- Major subsystem organization
- Architectural patterns used
- Integration points with other components

#### For Feature-Specific Documentation:
- Feature area architecture and design
- Implementation patterns and conventions
- Key files and their purposes
- Integration points and dependencies
- Development and testing patterns

### Step 5: Ensure Quality and Consistency
Validate the documentation by:
- Checking accuracy against actual implementation
- Ensuring consistency with project standards
- Verifying all cross-references are valid
- Following established documentation patterns

### Step 6: Update Documentation Registry
After creating the documentation:
- Add new files to docs-overview.md if needed
- Update project structure documentation if directories were created
- Ensure proper categorization in the 3-tier system

Now proceed with creating the documentation based on the user's request using direct analysis.