#!/bin/sh
# PreToolUse (Bash) hook: hard-deny git/gh write operations.
#
# Enforces the global CLAUDE.md policy ("I handle all git writes myself")
# mechanically, so it does not depend on the model reading and honoring the
# instruction, nor on the auto-permission classifier catching it. Greps the
# WHOLE command string, so compound forms like `cd x && git commit` are caught
# too (a plain deny-list only prefix-matches and would miss those).
#
# Fires only when `git`/`gh` is immediately followed by a write verb, so
# read-only uses pass through untouched:
#   git log --grep=commit     -> verb is `log`     -> allowed
#   git diff -- commit.txt     -> verb is `diff`    -> allowed
#   gh pr view / gh pr diff    -> verb is view/diff -> allowed
#
# Contract: read the tool-call JSON on stdin. Emitting a permissionDecision of
# "deny" blocks the call. Anything else (exit 0) leaves the normal permission
# flow untouched. Fails OPEN on parse trouble so it never wedges a real action.

cmd=$(jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
[ -n "$cmd" ] || exit 0

git_writes='add|commit|push|pull|fetch|merge|rebase|reset|checkout|switch|restore|stash|rm|mv|tag|branch|cherry-pick|revert|clean|am|apply'
gh_writes='(pr|issue|release)[[:space:]]+(create|merge|comment|edit|close|delete|ready|reopen)'

if printf '%s' "$cmd" | grep -Eq "\\bgit[[:space:]]+($git_writes)\\b" \
   || printf '%s' "$cmd" | grep -Eq "\\bgh[[:space:]]+$gh_writes\\b"; then
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"git/gh write operations are handled manually by the user (global CLAUDE.md policy). Summarize the change instead; do not stage, commit, push, or open PRs."}}'
  exit 0
fi

exit 0
