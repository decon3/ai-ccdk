You are working on the current project. Perform a comprehensive code review of the user's request "$ARGUMENTS" using direct analysis without sub-agents.

## Auto-Loaded Project Context:
@/CLAUDE.md
@/docs/ai-context/project-structure.md
@/docs/ai-context/docs-overview.md

## Direct Code Review Approach

### Step 1: Identify Review Scope
Based on the user's request "$ARGUMENTS", determine:
- Which files or components need review
- What type of review is needed (security, performance, architecture, etc.)
- What level of detail is appropriate

### Step 2: Comprehensive Analysis
Perform a thorough review covering these key areas:

#### Security Review
- Check for common security vulnerabilities
- Validate input sanitization and validation
- Review authentication and authorization
- Check for secrets or sensitive data exposure
- Verify secure communication practices

#### Performance Review
- Analyze algorithm efficiency and complexity
- Check for memory leaks or resource management issues
- Review database query optimization
- Identify potential bottlenecks
- Assess caching strategies

#### Architecture Review
- Evaluate adherence to established patterns
- Check separation of concerns
- Review component dependencies
- Assess scalability and maintainability
- Verify compliance with project standards

#### Code Quality Review
- Check naming conventions and readability
- Review error handling and logging
- Assess test coverage and quality
- Verify documentation completeness
- Check for code duplication

### Step 3: Risk Assessment
Categorize findings by:
- **Critical**: Security vulnerabilities, data loss risks
- **High**: Performance issues, architectural violations
- **Medium**: Code quality issues, maintainability concerns
- **Low**: Style inconsistencies, minor optimizations

### Step 4: Provide Actionable Feedback
Structure your review to include:
- Summary of overall code quality
- Specific issues with file/line references
- Recommended fixes and improvements
- Priority order for addressing issues
- Positive aspects and good practices identified

Now proceed with the direct code review based on the user's request.