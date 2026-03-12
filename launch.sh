#!/bin/bash
# launch.sh — One-command launcher for coding sessions in tmux with Warp viewer.
# Usage: launch.sh <task-name> <project-dir> <prompt>
#
# Examples:
#   launch.sh cm-review compute-maps "review the entire codebase and write a report"
#   launch.sh cm-fix compute-maps "fix the failing deploy script"

set -euo pipefail

TASK_NAME="${1:?Usage: launch.sh <task-name> <project-dir> <prompt>}"
PROJECT="${2:?Usage: launch.sh <task-name> <project-dir> <prompt>}"
PROMPT="${3:?Usage: launch.sh <task-name> <project-dir> <prompt>}"

# Default workspace directory (Adjust as needed)
WORKSPACE_DIR="$HOME/.openclaw/workspace/projects"
PROJECT_DIR="${WORKSPACE_DIR}/${PROJECT}"
WRAPPER="/tmp/cw-${TASK_NAME}.sh"

# Resolve project dir
if [ ! -d "$PROJECT_DIR" ]; then
  # Allow absolute paths too
  if [ -d "$PROJECT" ]; then
    PROJECT_DIR="$PROJECT"
  else
    echo "ERROR: Project directory not found: $PROJECT_DIR"
    exit 1
  fi
fi

# Kill existing session if present
tmux kill-session -t "$TASK_NAME" 2>/dev/null || true

# Write wrapper script
cat > "$WRAPPER" << CWEOF
#!/bin/bash
cd "$PROJECT_DIR"
# Adjust the CLI coding agent to your preference (acpx, claude-code, etc.)
acpx --approve-all codex sessions ensure 2>/dev/null || acpx --approve-all codex sessions new 2>/dev/null
acpx --approve-all codex "$PROMPT" || true

echo '=== DONE ==='
sleep 3600
CWEOF
chmod +x "$WRAPPER"

# Launch in tmux
tmux new-session -d -s "$TASK_NAME" "$WRAPPER"

# Open Warp viewer tab attached to the session
osascript \
  -e 'tell application "Warp" to activate' \
  -e 'delay 0.5' \
  -e 'tell application "System Events" to tell process "Warp" to keystroke "t" using command down' \
  -e 'delay 0.5' \
  -e "tell application \"System Events\" to tell process \"Warp\" to keystroke \"tmux attach -t ${TASK_NAME}\r\""

echo "OK: session '${TASK_NAME}' launched — Warp viewer open."
