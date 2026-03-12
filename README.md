# Code Watcher

A lightweight OpenClaw skill and shell wrapper that forces background coding agents to spawn their work inside a named `tmux` session, then automatically opens a live `Warp` terminal window attached to that session so you can watch them build.

Stop running background agents blindly. Watch them work.

## What it does
Instead of your agent running `acpx` or `claude-code` silently, it runs:
1. Kills any stale session with the same name.
2. Writes a wrapper script containing the exact prompt/command.
3. Launches the wrapper inside a detached `tmux` session.
4. Uses AppleScript to open a new tab in `Warp` and `tmux attach` to it.

## Prerequisites
- macOS
- [Warp Terminal](https://www.warp.dev/)
- `tmux` installed (`brew install tmux`)
- [OpenClaw](https://openclaw.ai/) (or a similar agentic framework that can run shell commands)
- A CLI coding agent like `acpx` or `claude-code`

## Installation

**1. The Launcher Script**
Copy `launch.sh` to a secure scripts directory (e.g., `~/scripts/`) and make it executable:
```bash
mkdir -p ~/scripts
cp launch.sh ~/scripts/
chmod +x ~/scripts/launch.sh
```

**2. Configure your Agent & Paths**
By default, `launch.sh` uses `acpx` as the CLI coding agent. **Open `launch.sh` and change lines 39-40 to use your preferred agent (e.g., `claude-code`, `aider`, etc.).** 
*(You should also ensure `WORKSPACE_DIR` near the top of the file points to where your projects live.)*

**3. The OpenClaw Skill**
Open `SKILL.md` and edit the `exec command` line to point to wherever you saved `launch.sh`. Then, copy `SKILL.md` into your OpenClaw skills directory:
```bash
cp SKILL.md ~/.openclaw/workspace/skills/code-watcher/SKILL.md
```

## Usage

Just ask your agent to use the Code Watcher skill.

> **You:** "Use code-watcher to build a simple Python snake game in the snake-game project."
> 
> **Agent:** "Spawned `snake-game` — Warp viewer open."

Warp will pop open, and you will see the agent typing, thinking, running commands, and fixing errors in real time. 

*Note: The `launch.sh` script intentionally includes a `sleep 3600` at the end of the run. This keeps the `tmux` pane alive for an hour after the agent finishes so you can scroll back and read the output without the window instantly collapsing.*

## Limitations
- Heavily optimized for macOS and Warp. If you use iTerm or standard Terminal, you will need to modify the AppleScript block at the bottom of `launch.sh`.

## License
MIT
