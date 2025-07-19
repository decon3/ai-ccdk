#!/usr/bin/env bash

# Claude Code Development Kit Setup Script
# 
# This script installs the Claude Code Development Kit into a target project,
# providing automated context management and multi-agent workflows for Claude Code.

set -euo pipefail

# Script directory (where this script lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration variables
TARGET_DIR=""
INSTALL_CONTEXT7="n"
INSTALL_GEMINI="n"
INSTALL_NOTIFICATIONS="n"
USE_DIRECT_COMMANDS="n"
INSTALL_DOTNET_TEMPLATES="n"
INSTALL_DOTNET_FRAMEWORK_TEMPLATES="n"
INSTALL_GOLANG_TEMPLATES="n"
OS=""
AUDIO_PLAYER=""
OVERWRITE_ALL="n"
SKIP_ALL="n"

# Print colored output
print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Print header
print_header() {
    echo
    print_color "$BLUE" "==========================================="
    print_color "$BLUE" "   Claude Code Development Kit Setup"
    print_color "$BLUE" "==========================================="
    echo
}

# Safe read function that works in piped contexts
# Usage: safe_read <variable_name> <prompt_string>
safe_read() {
    local var_name="$1"
    local prompt="$2"
    local temp_input  # Renamed to avoid scope collision

    # Check if a TTY is available for interactive input
    if [ ! -t 0 ] && [ ! -c /dev/tty ]; then
        print_color "$RED" "❌ Cannot prompt for input: No TTY available."
        return 1
    fi

    # Determine the input source
    local input_source
    if [ -t 0 ]; then
        input_source="/dev/stdin" # Standard input is the terminal
    else
        input_source="/dev/tty"   # Standard input is piped, use the terminal
    fi

    # Use read -p for the prompt. The prompt is sent to stderr by default
    # when reading from a source other than the terminal, so it's visible.
    read -r -p "$prompt" temp_input < "$input_source"

    # Assign the value to the variable name passed as the first argument
    # using `printf -v`. This is a safer way to do indirect assignment.
    printf -v "$var_name" '%s' "$temp_input"
}

# Safe read function for yes/no questions with validation
# Usage: safe_read_yn <variable_name> <prompt_string>
safe_read_yn() {
    local var_name="$1"
    local prompt="$2"
    local user_input
    local sanitized_input
    local valid_input=false

    while [ "$valid_input" = false ]; do
        if ! safe_read user_input "$prompt"; then
            return 1
        fi

        # Sanitize input: remove carriage returns and whitespace
        sanitized_input="${user_input//$'\r'/}"  # Remove \r
        sanitized_input="$(echo "$sanitized_input" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"

        case "$sanitized_input" in
            y|n)
                valid_input=true
                printf -v "$var_name" '%s' "$sanitized_input"
                ;;
            *)
                print_color "$YELLOW" "Please enter 'y' for yes or 'n' for no."
                ;;
        esac
    done
}

# Safe read function for file conflict choices with validation
# Usage: safe_read_conflict <variable_name>
safe_read_conflict() {
    local var_name="$1"
    local user_input
    local sanitized_input
    local valid_input=false

    while [ "$valid_input" = false ]; do
        if ! safe_read user_input "   Your choice: "; then
            return 1
        fi

        # Sanitize input: remove carriage returns and whitespace
        sanitized_input="${user_input//$'\r'/}"  # Remove \r
        sanitized_input="$(echo "$sanitized_input" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"

        case "$sanitized_input" in
            o|s|a|n)
                valid_input=true
                printf -v "$var_name" '%s' "$sanitized_input"
                ;;
            *)
                print_color "$YELLOW" "   Invalid choice. Please enter o, s, a, or n."
                ;;
        esac
    done
}

# Check if Claude Code is installed
check_claude_code() {
    print_color "$YELLOW" "Checking prerequisites..."
    
    # Check if claude command is available (handles both PATH and aliases)
    if command -v claude &> /dev/null; then
        print_color "$GREEN" "✓ Claude Code is installed"
        return 0
    fi
    
    # If not found via command, try to check for aliases in interactive shell
    if bash -i -c 'type claude' &> /dev/null 2>&1; then
        print_color "$GREEN" "✓ Claude Code is available (via alias)"
        return 0
    fi
    
    # Alternative check: try to source common shell configs and check again
    local shell_configs=(
        "$HOME/.bashrc"
        "$HOME/.bash_profile"
        "$HOME/.zshrc"
        "$HOME/.profile"
    )
    
    for config in "${shell_configs[@]}"; do
        if [ -f "$config" ]; then
            if bash -c "source '$config' && type claude" &> /dev/null 2>&1; then
                print_color "$GREEN" "✓ Claude Code is available (via alias in $config)"
                return 0
            fi
        fi
    done
    
    # Check common installation paths
    local claude_paths=(
        "$HOME/.local/bin/claude"
        "$HOME/bin/claude"
        "/usr/local/bin/claude"
        "/opt/homebrew/bin/claude"
    )
    
    for path in "${claude_paths[@]}"; do
        if [ -f "$path" ] && [ -x "$path" ]; then
            print_color "$GREEN" "✓ Claude Code found at: $path"
            return 0
        fi
    done
    
    # If still not found, show error with helpful guidance
    print_color "$RED" "❌ Claude Code is not installed or not accessible"
    echo
    echo "Please ensure Claude Code is installed and available:"
    echo "  • Install from: https://github.com/anthropics/claude-code"
    echo "  • Make sure 'claude' command works in your terminal"
    echo "  • If using an alias, make sure it's properly configured"
    echo "  • Try running 'claude --version' to verify installation"
    echo
    echo "If you have Claude Code installed but still see this error:"
    echo "  • Check your PATH environment variable"
    echo "  • Verify the claude binary has execute permissions"
    echo "  • Try running the setup script from the same shell where 'claude' works"
    echo
    echo "If you're certain Claude Code is installed and working:"
    if ! safe_read_yn skip_check "  Skip Claude Code check and continue anyway? (y/n): "; then
        exit 1
    fi
    
    if [ "$skip_check" = "y" ]; then
        print_color "$YELLOW" "⚠️  Skipping Claude Code check - proceeding with installation"
        return 0
    else
        exit 1
    fi
}

# Check for required tools
check_required_tools() {
    local missing_tools=()
    
    for tool in jq grep cat mkdir cp chmod; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        print_color "$RED" "❌ Missing required tools: ${missing_tools[*]}"
        echo
        echo "These tools are needed for:"
        echo "  • jq     - Parse and generate JSON configuration files"
        echo "  • grep   - Search and filter file contents"
        echo "  • cat    - Read and display files"
        echo "  • mkdir  - Create directory structure"
        echo "  • cp     - Copy framework files"
        echo "  • chmod  - Set executable permissions on scripts"
        echo
        echo "On macOS: Most are pre-installed, install jq with: brew install jq"
        echo "On Ubuntu/Debian: sudo apt-get install ${missing_tools[*]}"
        echo "On other systems: Use your package manager to install these tools"
        exit 1
    fi
    
    print_color "$GREEN" "✓ All required tools are available"
}

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            OS="macOS"
            AUDIO_PLAYER="afplay"
            ;;
        Linux*)
            OS="Linux"
            # Check for available audio players
            for player in paplay aplay pw-play play ffplay; do
                if command -v "$player" &> /dev/null; then
                    AUDIO_PLAYER="$player"
                    break
                fi
            done
            ;;
        MINGW*|MSYS*|CYGWIN*)
            OS="Windows"
            AUDIO_PLAYER="powershell"
            ;;
        *)
            OS="Unknown"
            AUDIO_PLAYER=""
            ;;
    esac
    
    print_color "$GREEN" "✓ Detected OS: $OS"
}

# Get target directory
get_target_directory() {
    echo
    print_color "$YELLOW" "Where would you like to install the Claude Code Development Kit?"
    local prompt="Enter target project directory (or . for current directory): "
    if ! safe_read input_dir "$prompt"; then
        exit 1
    fi
    
    if [ "$input_dir" = "." ]; then
        # If run from installer, use the original directory
        if [ -n "${INSTALLER_ORIGINAL_PWD:-}" ]; then
            TARGET_DIR="$INSTALLER_ORIGINAL_PWD"
        else
            # Otherwise use current directory (for manual runs)
            TARGET_DIR="$(pwd)"
        fi
    else
        TARGET_DIR="$(cd "$input_dir" 2>/dev/null && pwd)" || {
            print_color "$RED" "❌ Directory '$input_dir' does not exist"
            exit 1
        }
    fi
    
    # Check if target is the framework source directory
    if [ "$TARGET_DIR" = "$SCRIPT_DIR" ]; then
        print_color "$RED" "❌ Cannot install framework into its own source directory"
        echo "Please choose a different target directory"
        exit 1
    fi
    
    print_color "$GREEN" "✓ Target directory: $TARGET_DIR"
}

# Prompt for optional components
prompt_optional_components() {
    echo
    print_color "$YELLOW" "Optional Components:"
    echo
    
    # Context7 MCP
    print_color "$CYAN" "Context7 MCP Server (Highly Recommended)"
    echo "  Provides up-to-date documentation for external libraries (React, FastAPI, etc.)"
    if ! safe_read_yn INSTALL_CONTEXT7 "  Install Context7 integration? (y/n): "; then
        exit 1
    fi
    echo
    
    # Gemini MCP
    print_color "$CYAN" "Gemini Assistant MCP Server (Highly Recommended)"
    echo "  Enables architectural consultation and advanced code review capabilities"
    if ! safe_read_yn INSTALL_GEMINI "  Install Gemini integration? (y/n): "; then
        exit 1
    fi
    echo
    
    # Notifications
    print_color "$CYAN" "Notification System (Convenience Feature)"
    echo "  Plays audio alerts when tasks complete or input is needed"
    if ! safe_read_yn INSTALL_NOTIFICATIONS "  Set up notification hooks? (y/n): "; then
        exit 1
    fi
    echo
    
    # Sub-agent preference
    print_color "$CYAN" "Command Template Preference"
    echo "  Choose between multi-agent orchestration and direct analysis commands"
    echo "  • Multi-agent: Uses sub-agents for complex analysis (original behavior)"
    echo "  • Direct: Single-agent analysis without sub-agents (simpler, faster)"
    if ! safe_read_yn USE_DIRECT_COMMANDS "  Use direct commands (no sub-agents)? (y/n): "; then
        exit 1
    fi
    echo
    
    # .NET Core 8 specialization
    print_color "$CYAN" ".NET Core 8 Specialization (Optional)"
    echo "  Install .NET Core 8 specific templates and configurations"
    echo "  • Replaces generic templates with .NET Core 8 optimized versions"
    echo "  • Includes C# 12, ASP.NET Core 8, and Entity Framework Core 8 patterns"
    echo "  • Adds .NET specific security patterns and development commands"
    if ! safe_read_yn INSTALL_DOTNET_TEMPLATES "  Install .NET Core 8 templates? (y/n): "; then
        exit 1
    fi
    echo
    
    # .NET Framework 4.7.2 specialization
    print_color "$CYAN" ".NET Framework 4.7.2 Specialization (Optional)"
    echo "  Install .NET Framework 4.7.2 specific templates and configurations"
    echo "  • Replaces generic templates with .NET Framework 4.7.2 optimized versions"
    echo "  • Includes C# 7.3, ASP.NET Web API 2, and Entity Framework 6.x patterns"
    echo "  • Adds Windows service, IIS deployment, and legacy enterprise patterns"
    if ! safe_read_yn INSTALL_DOTNET_FRAMEWORK_TEMPLATES "  Install .NET Framework 4.7.2 templates? (y/n): "; then
        exit 1
    fi
    echo
    
    # Go language specialization
    print_color "$CYAN" "Go Language Specialization (Optional)"
    echo "  Install Go specific templates and configurations"
    echo "  • Replaces generic templates with Go optimized versions"
    echo "  • Includes Go 1.21+ features, concurrency patterns, and best practices"
    echo "  • Adds Go specific security patterns and development commands"
    if ! safe_read_yn INSTALL_GOLANG_TEMPLATES "  Install Go templates? (y/n): "; then
        exit 1
    fi
    
    # Only detect OS if notifications are enabled
    if [ "$INSTALL_NOTIFICATIONS" = "y" ]; then
        detect_os
        if [ -z "$AUDIO_PLAYER" ] && [ "$OS" = "Linux" ]; then
            print_color "$YELLOW" "⚠️  No audio player found. Install one of: paplay, aplay, pw-play, play, ffplay"
        fi
    fi
}

# Create directory structure
create_directories() {
    print_color "$YELLOW" "Creating directory structure..."
    
    # Main directories
    mkdir -p "$TARGET_DIR/.claude/commands"
    mkdir -p "$TARGET_DIR/.claude/hooks/config"
    mkdir -p "$TARGET_DIR/docs/ai-context"
    mkdir -p "$TARGET_DIR/docs/open-issues"
    mkdir -p "$TARGET_DIR/docs/specs"
    mkdir -p "$TARGET_DIR/logs"
    
    # Only create sounds directory if notifications are enabled
    if [ "$INSTALL_NOTIFICATIONS" = "y" ]; then
        mkdir -p "$TARGET_DIR/.claude/hooks/sounds"
    fi
    
    print_color "$GREEN" "✓ Directory structure created"
}

# Helper function to handle file conflicts
handle_file_conflict() {
    local source_file="$1"
    local dest_file="$2"
    local file_type="$3"
    
    # If policies are already set, apply them
    if [ "$OVERWRITE_ALL" = "y" ]; then
        cp "$source_file" "$dest_file"
        return 0
    elif [ "$SKIP_ALL" = "y" ]; then
        return 1
    fi
    
    # Show conflict and ask user
    print_color "$YELLOW" "⚠️  File already exists: $(basename "$dest_file")"
    echo "   Type: $file_type"
    echo "   Location: $dest_file"
    echo
    echo "   What would you like to do?"
    echo "   [o] Overwrite - Replace the existing file with the new one"
    echo "   [s] Skip - Keep the existing file, don't copy the new one"
    echo "   [a] Always overwrite - Replace this and all future existing files"
    echo "   [n] Never overwrite - Skip this and all future existing files"
    echo
    if ! safe_read_conflict choice; then
        return 1
    fi
    
    case "$choice" in
        o)
            cp "$source_file" "$dest_file"
            print_color "$GREEN" "   ✓ Overwritten"
            return 0
            ;;
        s)
            print_color "$YELLOW" "   → Skipped"
            return 1
            ;;
        a)
            OVERWRITE_ALL="y"
            cp "$source_file" "$dest_file"
            print_color "$GREEN" "   ✓ Overwritten (will automatically overwrite all future conflicts)"
            return 0
            ;;
        n)
            SKIP_ALL="y"
            print_color "$YELLOW" "   → Skipped (will automatically skip all future conflicts)"
            return 1
            ;;
        *)
            print_color "$RED" "   Invalid choice, skipping file"
            return 1
            ;;
    esac
}

# Copy a file with conflict handling
copy_with_check() {
    local source="$1"
    local dest="$2"
    local file_type="$3"
    
    if [ -f "$dest" ]; then
        handle_file_conflict "$source" "$dest" "$file_type"
    else
        cp "$source" "$dest"
    fi
}

# Copy framework files
copy_framework_files() {
    print_color "$YELLOW" "Copying framework files..."
    echo
    
    # Copy commands
    if [ -d "$SCRIPT_DIR/commands" ]; then
        for cmd in "$SCRIPT_DIR/commands/"*.md; do
            if [ -f "$cmd" ]; then
                basename_cmd="$(basename "$cmd")"
                
                # Skip gemini-consult.md unless Gemini is selected
                if [ "$basename_cmd" = "gemini-consult.md" ] && [ "$INSTALL_GEMINI" != "y" ]; then
                    continue
                fi
                
                # Handle direct vs multi-agent command preference
                if [ "$USE_DIRECT_COMMANDS" = "y" ]; then
                    # Use direct versions if they exist, otherwise use original
                    direct_cmd="${basename_cmd%.md}-direct.md"
                    if [ -f "$SCRIPT_DIR/commands/$direct_cmd" ]; then
                        # Copy direct version with original name
                        dest="$TARGET_DIR/.claude/commands/$basename_cmd"
                        copy_with_check "$SCRIPT_DIR/commands/$direct_cmd" "$dest" "Direct command template"
                    else
                        # No direct version exists, use original
                        dest="$TARGET_DIR/.claude/commands/$basename_cmd"
                        copy_with_check "$cmd" "$dest" "Command template"
                    fi
                else
                    # Use original multi-agent versions
                    dest="$TARGET_DIR/.claude/commands/$basename_cmd"
                    copy_with_check "$cmd" "$dest" "Command template"
                fi
            fi
        done
    fi
    
    # Copy hooks based on user selections
    if [ -d "$SCRIPT_DIR/hooks" ]; then
        # Copy subagent context injector only if not using direct commands
        if [ "$USE_DIRECT_COMMANDS" != "y" ] && [ -f "$SCRIPT_DIR/hooks/subagent-context-injector.sh" ]; then
            copy_with_check "$SCRIPT_DIR/hooks/subagent-context-injector.sh" \
                          "$TARGET_DIR/.claude/hooks/subagent-context-injector.sh" \
                          "Hook script (core feature)"
        fi
        
        # Copy MCP security scanner if any MCP server is selected
        if [ "$INSTALL_CONTEXT7" = "y" ] || [ "$INSTALL_GEMINI" = "y" ]; then
            if [ -f "$SCRIPT_DIR/hooks/mcp-security-scan.sh" ]; then
                copy_with_check "$SCRIPT_DIR/hooks/mcp-security-scan.sh" \
                              "$TARGET_DIR/.claude/hooks/mcp-security-scan.sh" \
                              "MCP security scanner hook"
            fi
        fi
        
        # Copy Gemini context injector if Gemini is selected
        if [ "$INSTALL_GEMINI" = "y" ]; then
            if [ -f "$SCRIPT_DIR/hooks/gemini-context-injector.sh" ]; then
                copy_with_check "$SCRIPT_DIR/hooks/gemini-context-injector.sh" \
                              "$TARGET_DIR/.claude/hooks/gemini-context-injector.sh" \
                              "Gemini context injector hook"
            fi
        fi
        
        # Copy notification hook and sounds if notifications are selected
        if [ "$INSTALL_NOTIFICATIONS" = "y" ]; then
            if [ -f "$SCRIPT_DIR/hooks/notify.sh" ]; then
                copy_with_check "$SCRIPT_DIR/hooks/notify.sh" \
                              "$TARGET_DIR/.claude/hooks/notify.sh" \
                              "Notification hook"
            fi
            
            # Copy sounds with conflict handling
            if [ -d "$SCRIPT_DIR/hooks/sounds" ]; then
                for sound in "$SCRIPT_DIR/hooks/sounds/"*; do
                    if [ -f "$sound" ]; then
                        dest="$TARGET_DIR/.claude/hooks/sounds/$(basename "$sound")"
                        copy_with_check "$sound" "$dest" "Notification sound"
                    fi
                done
            fi
        fi
        
        # Copy config files with conflict handling
        if [ -d "$SCRIPT_DIR/hooks/config" ]; then
            for config in "$SCRIPT_DIR/hooks/config/"*; do
                if [ -f "$config" ]; then
                    dest="$TARGET_DIR/.claude/hooks/config/$(basename "$config")"
                    copy_with_check "$config" "$dest" "Configuration file"
                fi
            done
            
            # Copy .NET Core 8 specific security patterns if .NET Core templates are selected
            if [ "$INSTALL_DOTNET_TEMPLATES" = "y" ] && [ -f "$SCRIPT_DIR/hooks/config/sensitive-patterns-dotnet.json" ]; then
                copy_with_check "$SCRIPT_DIR/hooks/config/sensitive-patterns-dotnet.json" \
                              "$TARGET_DIR/.claude/hooks/config/sensitive-patterns.json" \
                              ".NET Core 8 security patterns"
            fi
            
            # Copy .NET Framework 4.7.2 specific security patterns if .NET Framework templates are selected
            if [ "$INSTALL_DOTNET_FRAMEWORK_TEMPLATES" = "y" ] && [ -f "$SCRIPT_DIR/hooks/config/sensitive-patterns-dotnet-framework.json" ]; then
                copy_with_check "$SCRIPT_DIR/hooks/config/sensitive-patterns-dotnet-framework.json" \
                              "$TARGET_DIR/.claude/hooks/config/sensitive-patterns.json" \
                              ".NET Framework 4.7.2 security patterns"
            fi
            
            # Copy Go specific security patterns if Go templates are selected
            if [ "$INSTALL_GOLANG_TEMPLATES" = "y" ] && [ -f "$SCRIPT_DIR/hooks/config/sensitive-patterns-golang.json" ]; then
                copy_with_check "$SCRIPT_DIR/hooks/config/sensitive-patterns-golang.json" \
                              "$TARGET_DIR/.claude/hooks/config/sensitive-patterns.json" \
                              "Go security patterns"
            fi
        fi
        
        # Copy README for reference
        if [ -f "$SCRIPT_DIR/hooks/README.md" ]; then
            copy_with_check "$SCRIPT_DIR/hooks/README.md" \
                          "$TARGET_DIR/.claude/hooks/README.md" \
                          "Hooks documentation"
        fi
        
        # Copy setup files
        if [ -d "$SCRIPT_DIR/hooks/setup" ]; then
            mkdir -p "$TARGET_DIR/.claude/hooks/setup"
            for setup_file in "$SCRIPT_DIR/hooks/setup/"*; do
                if [ -f "$setup_file" ]; then
                    dest="$TARGET_DIR/.claude/hooks/setup/$(basename "$setup_file")"
                    copy_with_check "$setup_file" "$dest" "Setup file"
                fi
            done
        fi
    fi
    
    # Copy documentation structure
    if [ -d "$SCRIPT_DIR/docs" ]; then
        # Copy ai-context files
        if [ -d "$SCRIPT_DIR/docs/ai-context" ]; then
            for doc in "$SCRIPT_DIR/docs/ai-context/"*.md; do
                if [ -f "$doc" ]; then
                    dest="$TARGET_DIR/docs/ai-context/$(basename "$doc")"
                    copy_with_check "$doc" "$dest" "AI context documentation"
                fi
            done
        fi
        
        # Copy example issues
        if [ -d "$SCRIPT_DIR/docs/open-issues" ]; then
            for issue in "$SCRIPT_DIR/docs/open-issues/"*.md; do
                if [ -f "$issue" ]; then
                    dest="$TARGET_DIR/docs/open-issues/$(basename "$issue")"
                    copy_with_check "$issue" "$dest" "Issue template"
                fi
            done
        fi
        
        # Copy spec templates
        if [ -d "$SCRIPT_DIR/docs/specs" ]; then
            for spec in "$SCRIPT_DIR/docs/specs/"*.md; do
                if [ -f "$spec" ]; then
                    dest="$TARGET_DIR/docs/specs/$(basename "$spec")"
                    copy_with_check "$spec" "$dest" "Specification template"
                fi
            done
        fi
        
        # Copy docs README
        if [ -f "$SCRIPT_DIR/docs/README.md" ]; then
            copy_with_check "$SCRIPT_DIR/docs/README.md" \
                          "$TARGET_DIR/docs/README.md" \
                          "Documentation guide"
        fi
        
        # Copy CONTEXT template files
        if [ "$INSTALL_DOTNET_TEMPLATES" = "y" ]; then
            # Use .NET Core 8 specific templates
            if [ -f "$SCRIPT_DIR/docs/CONTEXT-tier2-dotnet-component.md" ]; then
                copy_with_check "$SCRIPT_DIR/docs/CONTEXT-tier2-dotnet-component.md" \
                              "$TARGET_DIR/docs/CONTEXT-tier2-component.md" \
                              ".NET Core 8 Tier 2 documentation template"
            fi
            
            if [ -f "$SCRIPT_DIR/docs/CONTEXT-tier3-dotnet-feature.md" ]; then
                copy_with_check "$SCRIPT_DIR/docs/CONTEXT-tier3-dotnet-feature.md" \
                              "$TARGET_DIR/docs/CONTEXT-tier3-feature.md" \
                              ".NET Core 8 Tier 3 documentation template"
            fi
            
            # Copy .NET Core 8 specific project structure
            if [ -f "$SCRIPT_DIR/docs/ai-context/project-structure-dotnet-core-8.md" ]; then
                copy_with_check "$SCRIPT_DIR/docs/ai-context/project-structure-dotnet-core-8.md" \
                              "$TARGET_DIR/docs/ai-context/project-structure.md" \
                              ".NET Core 8 project structure template"
            fi
        elif [ "$INSTALL_DOTNET_FRAMEWORK_TEMPLATES" = "y" ]; then
            # Use .NET Framework 4.7.2 specific templates
            if [ -f "$SCRIPT_DIR/docs/CONTEXT-tier2-dotnet-framework-component.md" ]; then
                copy_with_check "$SCRIPT_DIR/docs/CONTEXT-tier2-dotnet-framework-component.md" \
                              "$TARGET_DIR/docs/CONTEXT-tier2-component.md" \
                              ".NET Framework 4.7.2 Tier 2 documentation template"
            fi
            
            if [ -f "$SCRIPT_DIR/docs/CONTEXT-tier3-dotnet-framework-feature.md" ]; then
                copy_with_check "$SCRIPT_DIR/docs/CONTEXT-tier3-dotnet-framework-feature.md" \
                              "$TARGET_DIR/docs/CONTEXT-tier3-feature.md" \
                              ".NET Framework 4.7.2 Tier 3 documentation template"
            fi
            
            # Copy .NET Framework 4.7.2 specific project structure
            if [ -f "$SCRIPT_DIR/docs/ai-context/project-structure-dotnet-framework-4-7-2.md" ]; then
                copy_with_check "$SCRIPT_DIR/docs/ai-context/project-structure-dotnet-framework-4-7-2.md" \
                              "$TARGET_DIR/docs/ai-context/project-structure.md" \
                              ".NET Framework 4.7.2 project structure template"
            fi
            
            # Copy .NET Framework 4.7.2 specific commands
            if [ -f "$SCRIPT_DIR/docs/dotnet-framework-4-7-2-commands.md" ]; then
                copy_with_check "$SCRIPT_DIR/docs/dotnet-framework-4-7-2-commands.md" \
                              "$TARGET_DIR/docs/commands.md" \
                              ".NET Framework 4.7.2 commands reference"
            fi
        elif [ "$INSTALL_GOLANG_TEMPLATES" = "y" ]; then
            # Use Go specific templates
            if [ -f "$SCRIPT_DIR/docs/CONTEXT-tier2-golang-component.md" ]; then
                copy_with_check "$SCRIPT_DIR/docs/CONTEXT-tier2-golang-component.md" \
                              "$TARGET_DIR/docs/CONTEXT-tier2-component.md" \
                              "Go Tier 2 documentation template"
            fi
            
            if [ -f "$SCRIPT_DIR/docs/CONTEXT-tier3-golang-feature.md" ]; then
                copy_with_check "$SCRIPT_DIR/docs/CONTEXT-tier3-golang-feature.md" \
                              "$TARGET_DIR/docs/CONTEXT-tier3-feature.md" \
                              "Go Tier 3 documentation template"
            fi
            
            # Copy Go specific project structure
            if [ -f "$SCRIPT_DIR/docs/ai-context/project-structure-golang.md" ]; then
                copy_with_check "$SCRIPT_DIR/docs/ai-context/project-structure-golang.md" \
                              "$TARGET_DIR/docs/ai-context/project-structure.md" \
                              "Go project structure template"
            fi
        else
            # Use generic templates
            if [ -f "$SCRIPT_DIR/docs/CONTEXT-tier2-component.md" ]; then
                copy_with_check "$SCRIPT_DIR/docs/CONTEXT-tier2-component.md" \
                              "$TARGET_DIR/docs/CONTEXT-tier2-component.md" \
                              "Tier 2 documentation template"
            fi
            
            if [ -f "$SCRIPT_DIR/docs/CONTEXT-tier3-feature.md" ]; then
                copy_with_check "$SCRIPT_DIR/docs/CONTEXT-tier3-feature.md" \
                              "$TARGET_DIR/docs/CONTEXT-tier3-feature.md" \
                              "Tier 3 documentation template"
            fi
        fi
    fi
    
    # Create CLAUDE.md from template if it doesn't exist
    if [ ! -f "$TARGET_DIR/CLAUDE.md" ]; then
        if [ "$INSTALL_DOTNET_TEMPLATES" = "y" ] && [ -f "$SCRIPT_DIR/docs/CLAUDE-dotnet-core-8.md" ]; then
            cp "$SCRIPT_DIR/docs/CLAUDE-dotnet-core-8.md" "$TARGET_DIR/CLAUDE.md"
            print_color "$GREEN" "✓ Created CLAUDE.md from .NET Core 8 template"
        elif [ "$INSTALL_DOTNET_FRAMEWORK_TEMPLATES" = "y" ] && [ -f "$SCRIPT_DIR/docs/CLAUDE-dotnet-framework-4-7-2.md" ]; then
            cp "$SCRIPT_DIR/docs/CLAUDE-dotnet-framework-4-7-2.md" "$TARGET_DIR/CLAUDE.md"
            print_color "$GREEN" "✓ Created CLAUDE.md from .NET Framework 4.7.2 template"
        elif [ "$INSTALL_GOLANG_TEMPLATES" = "y" ] && [ -f "$SCRIPT_DIR/docs/CLAUDE-golang.md" ]; then
            cp "$SCRIPT_DIR/docs/CLAUDE-golang.md" "$TARGET_DIR/CLAUDE.md"
            print_color "$GREEN" "✓ Created CLAUDE.md from Go template"
        elif [ -f "$SCRIPT_DIR/docs/CLAUDE.md" ]; then
            cp "$SCRIPT_DIR/docs/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
            print_color "$GREEN" "✓ Created CLAUDE.md from template"
        fi
    else
        print_color "$YELLOW" "→ Preserved existing CLAUDE.md"
    fi
    
    # Create MCP-ASSISTANT-RULES.md from template if Gemini is selected
    if [ "$INSTALL_GEMINI" = "y" ]; then
        if [ ! -f "$TARGET_DIR/MCP-ASSISTANT-RULES.md" ] && [ -f "$SCRIPT_DIR/docs/MCP-ASSISTANT-RULES.md" ]; then
            cp "$SCRIPT_DIR/docs/MCP-ASSISTANT-RULES.md" "$TARGET_DIR/MCP-ASSISTANT-RULES.md"
            print_color "$GREEN" "✓ Created MCP-ASSISTANT-RULES.md from template"
        else
            if [ -f "$TARGET_DIR/MCP-ASSISTANT-RULES.md" ]; then
                print_color "$YELLOW" "→ Preserved existing MCP-ASSISTANT-RULES.md"
            fi
        fi
    else
        print_color "$YELLOW" "→ Skipped MCP-ASSISTANT-RULES.md (Gemini not selected)"
    fi
    
    print_color "$GREEN" "✓ Framework files copied"
}

# Set executable permissions
set_permissions() {
    print_color "$YELLOW" "Setting file permissions..."
    
    # Make only copied shell scripts executable
    if [ -d "$TARGET_DIR/.claude/hooks" ]; then
        for script in "$TARGET_DIR/.claude/hooks/"*.sh; do
            if [ -f "$script" ]; then
                chmod +x "$script"
            fi
        done
    fi
    
    print_color "$GREEN" "✓ Permissions set"
}

# Generate configuration file
generate_config() {
    print_color "$YELLOW" "Generating configuration..."
    
    local config_file="$TARGET_DIR/.claude/settings.local.json"
    
    # Start building the configuration with new hooks format
    cat > "$config_file" << EOF
{
  "hooks": {
EOF

    # PreToolUse hooks
    local pretooluse_hooks=()
    
    # Security scan hook for MCP tools
    if [ "$INSTALL_CONTEXT7" = "y" ] || [ "$INSTALL_GEMINI" = "y" ]; then
        pretooluse_hooks+=("mcp-security")
    fi
    
    # Gemini context injector
    if [ "$INSTALL_GEMINI" = "y" ]; then
        pretooluse_hooks+=("gemini-context")
    fi
    
    # Add sub-agent context injector only if not using direct commands
    if [ "$USE_DIRECT_COMMANDS" != "y" ]; then
        pretooluse_hooks+=("subagent-context")
    fi
    
    # Write PreToolUse hooks
    if [ ${#pretooluse_hooks[@]} -gt 0 ]; then
        cat >> "$config_file" << EOF
    "PreToolUse": [
EOF
        
        local first_hook=true
        
        # MCP security scanner
        if [[ " ${pretooluse_hooks[@]} " =~ " mcp-security " ]]; then
            [ "$first_hook" = false ] && echo "," >> "$config_file"
            cat >> "$config_file" << EOF
      {
        "matcher": "mcp__",
        "hooks": [
          {
            "type": "command",
            "command": "bash $TARGET_DIR/.claude/hooks/mcp-security-scan.sh"
          }
        ]
      }
EOF
            first_hook=false
        fi
        
        # Gemini context injector
        if [[ " ${pretooluse_hooks[@]} " =~ " gemini-context " ]]; then
            [ "$first_hook" = false ] && echo "," >> "$config_file"
            cat >> "$config_file" << EOF
      {
        "matcher": "mcp__gemini",
        "hooks": [
          {
            "type": "command",
            "command": "bash $TARGET_DIR/.claude/hooks/gemini-context-injector.sh"
          }
        ]
      }
EOF
            first_hook=false
        fi
        
        # Sub-agent context injector
        [ "$first_hook" = false ] && echo "," >> "$config_file"
        cat >> "$config_file" << EOF
      {
        "matcher": "Task",
        "hooks": [
          {
            "type": "command",
            "command": "bash $TARGET_DIR/.claude/hooks/subagent-context-injector.sh"
          }
        ]
      }
EOF
        
        cat >> "$config_file" << EOF
    ]
EOF
    fi
    
    # Add notification hooks if enabled
    if [ "$INSTALL_NOTIFICATIONS" = "y" ]; then
        [ ${#pretooluse_hooks[@]} -gt 0 ] && echo "," >> "$config_file"
        cat >> "$config_file" << EOF
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash $TARGET_DIR/.claude/hooks/notify.sh input"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash $TARGET_DIR/.claude/hooks/notify.sh complete"
          }
        ]
      }
    ]
EOF
    fi
    
    cat >> "$config_file" << EOF

  },
  "environment": {
    "WORKSPACE": "$TARGET_DIR"
  }
}
EOF
    
    print_color "$GREEN" "✓ Configuration generated: $config_file"
}

# Display MCP server information
display_mcp_info() {
    if [ "$INSTALL_CONTEXT7" = "y" ] || [ "$INSTALL_GEMINI" = "y" ]; then
        echo
        print_color "$BLUE" "=== MCP Server Setup (Required) ==="
        echo
        echo "To complete the setup, you need to install the MCP servers you selected:"
        echo
        
        if [ "$INSTALL_CONTEXT7" = "y" ]; then
            print_color "$YELLOW" "Context7 MCP Server:"
            echo "  Repository: https://github.com/upstash/context7"
            echo "  Documentation: See the Context7 README for setup instructions"
            echo
        fi
        
        if [ "$INSTALL_GEMINI" = "y" ]; then
            print_color "$YELLOW" "Gemini MCP Server:"
            echo "  Repository: https://github.com/peterkrueck/mcp-gemini-assistant"
            echo "  Documentation: See the MCP Gemini Assistant README for setup instructions"
            echo
        fi
        
        echo "After installing the MCP servers, add their configuration to:"
        print_color "$BLUE" "  $TARGET_DIR/.claude/settings.local.json"
        echo
        echo "Add a 'mcpServers' section with the appropriate server configurations."
    fi
}

# Show next steps
show_next_steps() {
    echo
    print_color "$GREEN" "=== Installation Complete! ==="
    echo
    print_color "$YELLOW" "Next Steps:"
    echo
    local step_num=1
    
    echo "${step_num}. Customize your project context:"
    echo "   - Edit: $TARGET_DIR/CLAUDE.md"
    echo "   - Update project structure in: $TARGET_DIR/docs/ai-context/project-structure.md"
    echo
    ((step_num++))
    
    if [ "$INSTALL_GEMINI" = "y" ]; then
        echo "${step_num}. Set your coding standards for Gemini:"
        echo "   - Edit: $TARGET_DIR/MCP-ASSISTANT-RULES.md"
        echo
        ((step_num++))
    fi
    
    if [ "$INSTALL_CONTEXT7" = "y" ] || [ "$INSTALL_GEMINI" = "y" ]; then
        echo "${step_num}. Configure security patterns:"
        echo "   - Edit: $TARGET_DIR/.claude/hooks/config/sensitive-patterns.json"
        echo
        ((step_num++))
    fi
    
    echo "${step_num}. Test your installation:"
    echo "   - Run: claude"
    echo "   - Then: /full-context \"analyze my project structure\""
    echo
    ((step_num++))
    
    if [ "$INSTALL_NOTIFICATIONS" = "y" ]; then
        echo "${step_num}. Test notifications:"
        echo "   - Run: bash $TARGET_DIR/.claude/hooks/notify.sh"
        echo
        ((step_num++))
    fi
    
    echo "${step_num}. Documentation Templates:"
    print_color "$CYAN" "   The framework includes documentation templates:"
    echo "   - $TARGET_DIR/docs/CONTEXT-tier2-component.md"
    echo "   - $TARGET_DIR/docs/CONTEXT-tier3-feature.md"
    echo
    echo "   These are TEMPLATES. To use them:"
    echo "   • Copy to your component/feature directories and rename to CONTEXT.md"
    echo "   • OR use the /create-docs command to generate documentation automatically"
    echo
    
    print_color "$BLUE" "For documentation and examples, see:"
    echo "  - Commands: $TARGET_DIR/.claude/commands/README.md"
    echo "  - Hooks: $TARGET_DIR/.claude/hooks/README.md"
    echo "  - Docs: $TARGET_DIR/docs/README.md"
}

# Main execution
main() {
    print_header
    
    # Run checks
    check_claude_code
    check_required_tools
    
    # Get user input
    get_target_directory
    prompt_optional_components
    
    # Confirm installation
    echo
    print_color "$YELLOW" "Ready to install Claude Code Development Kit to:"
    echo "  $TARGET_DIR"
    echo
    if ! safe_read_yn confirm "Continue? (y/n): "; then
        exit 1
    fi
    
    if [ "$confirm" != "y" ]; then
        print_color "$RED" "Installation cancelled"
        exit 0
    fi
    
    # Perform installation
    create_directories
    copy_framework_files
    set_permissions
    generate_config
    
    # Show completion information
    display_mcp_info
    show_next_steps
}

# Run the script
main "$@"