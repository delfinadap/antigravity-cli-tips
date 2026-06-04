# Antigravity CLI Scripts

## context-bar.sh

A status line script for Antigravity CLI that shows model, directory, git branch, dirty status, sync status with origin, and context usage.

**Example output:**
```
Gemini | 📁my-project | 🔀main (clean, synced 12m ago) | ██░░░░░░░░ 8% of 1M tokens
```

### Installation

1. Copy the script to your Antigravity CLI scripts directory:
   ```bash
   mkdir -p ~/.gemini/antigravity-cli
   cp context-bar.sh ~/.gemini/antigravity-cli/statusline.sh
   chmod +x ~/.gemini/antigravity-cli/statusline.sh
   ```

2. Update your `~/.gemini/antigravity-cli/settings.json`:
   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "~/.gemini/antigravity-cli/statusline.sh"
     }
   }
   ```

That's it!

### Color themes

The script supports optional color themes for the model name and progress bar. Edit the `COLOR` variable at the top of the script:

```bash
# Color theme: gray, orange, blue, teal, green, lavender, rose, gold, slate, cyan
COLOR="orange"
```

Preview all options by running `bash scripts/color-preview.sh`.

### Requirements

- `jq` (for JSON parsing)
- `bash`
- `git` (optional, for sync status)

### How it works

Antigravity CLI passes session metadata to status line commands via stdin as JSON, including:
- `model.display_name` - The model name
- `cwd` - Current working directory
- `vcs.branch` - Current git branch
- `vcs.dirty` - Whether there are uncommitted changes
- `context_window.used_percentage` - Percentage of context window used
- `context_window.context_window_size` - Maximum context window size

See the [official status line docs](https://antigravity.google/docs/cli-statusline) for the full list of available JSON fields.
