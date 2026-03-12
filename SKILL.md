---
name: code-watcher
description: "Spawn a coding session in tmux with a live Warp viewer window so you can watch. Use for any real coding work — building features, reading codebases, writing reports, refactoring."
metadata:
  {
    "openclaw": { "emoji": "👁️", "requires": { "anyBins": ["acpx", "tmux"] } },
  }
---

# Code Watcher

When you need your agent to do sustained coding work, run this ONE command. Do NOT split it into multiple steps.

## Installation

1. Copy `launch.sh` to a secure scripts directory (e.g. `~/scripts/launch.sh`) and make it executable (`chmod +x ~/scripts/launch.sh`).
2. Update the `WORKSPACE_DIR` in `launch.sh` if your projects live somewhere else.
3. Update the `exec command` paths below to point to your `launch.sh` location.

## The Command

```bash
exec command:"~/scripts/launch.sh [task-name] [project] \"[prompt]\""
```

That is the ONLY exec call you need. It does everything: kills old sessions, writes the wrapper, launches tmux, opens Warp.

## Examples

```bash
exec command:"~/scripts/launch.sh auth-review my-project \"read the auth codebase and write a detailed architecture report\""
```

```bash
exec command:"~/scripts/launch.sh build-ui frontend \"scaffold the dashboard components\""
```

## Rules

- **task-name**: short, descriptive, no spaces (e.g. auth-review, build-ui)
- **project**: directory name under your workspace (or an absolute path)
- **prompt**: the full task description in quotes — be detailed, this is what the coding agent sees
- **ONE exec call.** Do not write multiple exec calls. Do not ask clarifying questions. Pick reasonable defaults and go.

## After Launching

Send a message: "Spawned `[task-name]` — Warp viewer open."
