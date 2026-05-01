#!/bin/bash
# Hook script for Claude Code SessionStart event
# Shows welcome message and ZeroWarp detection status

# Check if running in a compatible terminal
if [ "$TERM_PROGRAM" = "WarpTerminal" ]; then
    # Running in a compatible terminal - notifications will work
    cat << 'EOF'
{
  "systemMessage": "ZeroWarp plugin active. You'll receive native ZeroWarp notifications when tasks complete or input is needed."
}
EOF
else
    exit 0
fi
