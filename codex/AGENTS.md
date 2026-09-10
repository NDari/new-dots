# Personal working preferences

## Git and GitHub are for inspection only

I handle all Git and GitHub write operations myself. Do not stage, commit,
fetch, pull, push, change branches, create worktrees, or modify the index,
refs, history, Git configuration, or remote state. Do not use Git to modify
the working tree. Do not create or change PRs, issues, comments, or releases.
Read-only inspection is welcome. Ordinary source-file edits are allowed.

This applies to shell commands, scripts, libraries, APIs, connectors,
browser actions, and direct edits to Git metadata. Do not work around a
blocked command or seek escalation for a prohibited Git/GitHub operation.
An implementation request does not authorize Git/GitHub writes. If such an
operation is needed, explain the dependency and leave it to me.
Do not offer to stage, commit, push, or open a PR when finishing a task.

Use direct Git/GitHub inspection commands. Set the shell tool's working
directory or use `git -C PATH`; avoid wrapping Git in shell scripts, aliases,
interpreters, substitutions, or environment assignments. The personal hook
accepts common inspection forms and rejects unknown forms conservatively.

## Scope and verification

- Read the relevant code and repository instructions before editing.
- Keep changes scoped to the task. Preserve unrelated user changes and the
  existing style. Avoid incidental reformatting and unsolicited dependencies.
- Verify repository-specific paths, symbols, flags, and behavior before
  stating them as facts. Identify inferences and uncertainty clearly.
- Run checks appropriate to the change. Report what passed, failed, or was
  not run. Do not imply that untested behavior works.
- Read failure output before choosing the next action. Do not repeat a
  failed command without addressing its cause.
- Continue authorized local work without unnecessary confirmation. Ask when
  a material choice cannot be inferred, or before host-affecting operations
  such as deployment, package installation, or destructive system changes
  unless that specific operation is already authorized.
- Keep private code and secrets within the task's authorized destinations.
  A private repository does not make secrets safe to publish there.

## Workstation and shell

Commands for me to paste into my terminal should work in fish. Prefer simple
commands and `env NAME=value command`; avoid Bash heredocs and Bash-specific
control flow in terminal instructions. Commands executed by tools must match
the tool's actual shell.

My usual workstations run Arch/CachyOS with pacman/paru, systemd,
Btrfs/Snapper, and Podman. Confirm the actual environment before host changes.
Follow repository documentation for build containers and deployment targets,
which may use other operating systems or tools.

## Communication

Be concise and direct. Explain the outcome, relevant checks, and limitations.
Avoid em dashes and en dashes in newly authored prose. Preserve exact quoted
text, existing data, fixtures, and syntax whose spelling matters.
