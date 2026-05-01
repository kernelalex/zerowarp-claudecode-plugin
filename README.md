# Claude Code + ZeroWarp

Local-only ZeroWarp notification plugin for [Claude Code](https://docs.anthropic.com/en/docs/claude-code), maintained by Enigma Labs.

This fork preserves the useful terminal integration from the upstream Warp plugin while removing Warp-owned distribution identity. It emits local OSC 777 escape sequences for ZeroWarp to parse; it does not include telemetry, analytics SDKs, or Warp cloud service calls.

## Features

### Native Notifications

Get native ZeroWarp notifications when Claude Code:
- Completes a task, with a concise prompt/response summary
- Needs your input after becoming idle
- Requests permission to run a tool

### Session Status

The plugin keeps ZeroWarp informed of Claude's local session state by emitting structured events:
- `prompt_submit` when you send a prompt
- `tool_complete` when a tool call finishes
- `permission_request` when Claude needs approval
- `stop` when Claude completes a turn

These events stay in the local terminal session and are not sent to Warp cloud services.

## Installation

```bash
# In Claude Code, add the ZeroWarp marketplace
/plugin marketplace add kernelalex/zerowarp-claudecode-plugin

# Install the ZeroWarp plugin
/plugin install zerowarp@zerowarp-claudecode-plugin
```

After installing, restart Claude Code or run `/reload-plugins` for the plugin to activate.

## Requirements

- ZeroWarp terminal
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- `jq` for JSON parsing

## How It Works

Each hook script builds a structured JSON payload with `build-payload.sh` and writes an OSC 777 escape sequence to `/dev/tty`. ZeroWarp consumes that local terminal event to drive notifications and session UI.

Payloads include a negotiated protocol version, session ID, working directory, and event-specific fields. The protocol string remains `warp://cli-agent` for compatibility with the current ZeroWarp client.

The plugin registers six hooks:
- `SessionStart` emits the plugin version and a startup message.
- `Stop` reads the transcript to extract prompt/response context.
- `Notification` handles idle prompts.
- `PermissionRequest` includes tool name and a preview of requested input.
- `UserPromptSubmit` signals that a submitted prompt is running.
- `PostToolUse` signals that a tool call completed.

## Uninstall

```bash
/plugin uninstall zerowarp@zerowarp-claudecode-plugin
/plugin marketplace remove zerowarp-claudecode-plugin
```

## Versioning

The plugin version in `plugins/warp/.claude-plugin/plugin.json` is checked by the ZeroWarp client to detect outdated installations. When bumping this version, also update the matching minimum plugin version in ZeroWarp.

## Attribution

This project is a privacy-focused fork of the Warp Claude Code notification plugin. ZeroWarp-specific changes are maintained by Enigma Labs.

## License

MIT License. See [LICENSE](LICENSE) for details.
