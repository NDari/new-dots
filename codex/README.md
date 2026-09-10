# Portable Codex starting configuration

Source files for a personal Codex setup. Nothing here installs itself, creates
symlinks, changes Claude, or runs Git write operations.

## Files and eventual destinations

| Source | Destination |
| --- | --- |
| `AGENTS.md` | `~/.codex/AGENTS.md` |
| `config.toml` | `~/.codex/config.toml` |
| `hooks.json` | `~/.codex/hooks.json` |
| `hooks/git_read_only.py` | `~/.codex/hooks/git_read_only.py` |
| `rules/git-read-only.rules` | `~/.codex/rules/git-read-only.rules` |

Link individual files. Keep `README.md`, `tests/`, and `examples/` here; they
do not need links. Python 3.9+ is required by the hook. The config and hook
protocol were checked against Codex CLI 0.153.4 and current official docs.
No model, credentials, username, absolute workstation path, or project trust
entry is pinned. This is a Unix workstation setup, not a Windows shell setup.

Before activation, inspect existing destination files and resolve conflicts
yourself. In particular:

- A nonempty `~/.codex/AGENTS.override.md` takes precedence over `AGENTS.md`.
- Old `~/.codex/rules/default.rules` allowances remain active alongside this
  rule file. Review/remove obsolete and broad allowances before relying on
  the new baseline. Do not carry over blanket `podman`, `curl`, or `sudo`
  allowances or relative project-script allowances.
- Hooks from multiple sources accumulate. Do not configure this same hook
  in both TOML and JSON. Inspect project and plugin hooks as well.
- Restart Codex, open `/hooks`, and review/trust the hook definition. New or
  changed untrusted hooks are skipped. Do not bypass hook trust.
- Keep auth files, runtime state, hook trust, plugin caches, and project trust
  local. Codex can update its user configuration: a symlinked config may
  therefore acquire local settings. Review it before committing dotfiles.

The hook command uses `${CODEX_HOME:-$HOME/.codex}`. With a custom `CODEX_HOME`,
use that directory for the destinations instead. No shell-specific install
script is included; existing active configuration is deliberately untouched.

## Behavior and scope

`AGENTS.md` gives the agent global preferences: Git/GitHub inspection only,
focused edits, relevant verification, concise prose, fish terminal commands,
and Arch/CachyOS defaults with environment checks. It is instruction context,
not an OS-enforced permission boundary. Keep repository details in repository
`AGENTS.md` files; `examples/project-AGENTS.md.example` is an optional template.

`config.toml` permits workspace edits, keeps shell network access disabled
inside the workspace sandbox, and routes eligible escalations to the user.
App writes have a separate human-review default. This does not mean every
side effect inside the workspace asks first. Do not use full-access/bypass
modes to evade the Git policy. Standard workspace sandboxing protects Git
metadata; external tools, elevated execution, other paths, and remote actions
need their own controls.

`git-read-only.rules` blocks common direct Git/GitHub write prefixes without
granting any new out-of-sandbox allowances. Prefix rules alone do not cover
all global-option placements or hidden commands. Branch/tag inspection is
handled by the hook, so those command families are not banned wholesale.

The `PreToolUse` hook:

- Accepts direct common Git inspection commands and a finite set of flags.
  `git -C /absolute/path diff`, `git log -n 5 --oneline`, and `git branch
  --list main` are examples. Ordinary `git status` and `git diff` work.
- Rejects writes, unknown verbs/options, aliases, config overrides, and
  opaque shell forms. `gh api` is intentionally unsupported, even for GET.
  Use `gh pr view`, `gh pr diff`, `gh issue list`, etc. Place `--repo` after
  the gh subcommand. Extend the option allowlist with tests if a needed read
  form is missing.
- Rewrites accepted Git calls to disable optional locks/index refresh,
  pagers, fsmonitor, automatic signature display, and, where applicable,
  external diff/textconv helpers. Rewriting preserves the other input fields.
- Accepts simple chains of Git/GitHub calls. Mixed commands, redirects,
  expansions, wildcards, and wrappers are rejected when Git/GitHub is visible.
  Prefer separate tool calls and the tool's working-directory argument.
  The conservative detection can also reject literal Git-related text in
  shell searches or commands. It is not a general-purpose shell parser.
- Passes unrelated commands to normal Codex permissions without allowing
  them automatically. It does not ban ordinary source edits or tests.
- Blocks non-read/unknown tool names matching `mcp__.*github.*`; recognizes
  `get`, `list`, `search`, `fetch`, and `compare` action prefixes. This is a
  naming convention, not validation of a tool implementation. Audit new
  connectors and their actual names/permissions before enabling them.
- Returns an explicit deny on malformed input or parser failure.

This is a guardrail against agent mistakes, not a complete security boundary.
It cannot inspect arbitrary scripts, dynamically constructed commands, shell
functions, tools named differently, direct HTTP/browser activity, or later
input sent through `write_stdin`. Hook startup failures, timeouts, skipped
trust, and specialized tool paths are not equivalent to a successful deny.
Keep the sandbox and the instruction against bypasses. Strong guarantees
require OS-enforced filesystem/network restrictions and read-only remote
credentials or connector permissions, not a larger regex/option list.

## Validation and activation check

Run from this directory; this is fish-compatible:

```sh
python3 -B -m unittest discover -s tests -v
codex execpolicy check --rules rules/git-read-only.rules -- git commit -m example
codex execpolicy check --rules rules/git-read-only.rules -- git status
```

The policy checker evaluates arguments only; neither example runs Git.
Expect `forbidden` for commit and no matching prohibition for status.
Tests pass command strings to the hook and do not execute those commands.

After linking and trusting, confirm `/hooks` shows the active hook and use a
read-only `git status` task to check integration. Never test the guard by
actually requesting a write in a real repository. Unit/policy tests do not
prove that hooks are active in a particular Codex app/session.

## What was intentionally omitted

- Claude-specific model IDs, UI toggles, plugins, and permission syntax.
- Automatic punctuation rewriting, and regex sed/awk permission classifiers.
- Transcript-derived counts, stale infrastructure assumptions, repetitive
  unknown fields, and deployment-specific global context.
- Machine-specific trust paths, old one-off approvals, and system-wide
  privileged command allowances.
- Automatic dependency installation, system changes, or Git operations.

## Official references

- [Global and repository instructions](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [Configuration fields](https://learn.chatgpt.com/docs/config-file/config-reference)
- [Hook input, rewriting, trust, and coverage](https://learn.chatgpt.com/docs/hooks)
- [Execution rules](https://learn.chatgpt.com/docs/agent-configuration/rules)
- [Sandbox and approvals](https://learn.chatgpt.com/docs/agent-approvals-security)

Documentation checked 2026-09-06. Verify hook support and review the effective
configuration on each workstation before activation.
