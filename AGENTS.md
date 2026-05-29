# Project instructions

This file is `AGENTS.md`. `CLAUDE.md` is symlinked to this file.

- Writing: keep user's voice, conversational, stick closely to what user said without making things up, but fix small grammar mistakes. Don't embellish or add sentences the user didn't say. Rephrasing and light cleanup is fine, but the content should come from the user.

## Filing issues on the official repo

File issues on `google-antigravity/antigravity-cli` using host `gh` (not through a container).

Use `DX:` prefix for developer experience issues. Before filing, check the user's past submitted issues on the repo to match the style. Checking issues and duplicates are read-only calls on a public repo - use a safeclaw container per the global CLAUDE.md rules. Only use host `gh` for the actual write operation (creating the issue).
