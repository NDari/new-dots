# Global preferences (apply across all projects on this machine)

## Never perform git write operations

I handle all git writes myself. Do **not** run any of: `git add`, `git commit`, `git rm`, `git mv`, `git push`, `git pull`, `git fetch`, `git merge`, `git rebase`, `git reset`, `git checkout` (when it would change branch/working tree), `git stash`, `git tag`, `git branch`, `git switch`, `git restore`, `git cherry-pick`, `git revert`, `git clean`, or any `gh` subcommand that writes (creating PRs, issues, comments, releases, merging).

Read-only git commands are fine: `git status`, `git diff`, `git log`, `git show`, `git blame`, `git ls-files`, `gh pr view`, `gh pr diff`, `gh issue view`, etc.

Also do not offer to stage, commit, push, or open PRs at the end of work — I'll do it. Just summarize what changed.

**Why:** I want full control over my git history and remote-side actions. This applies even when I previously authorized one git operation — that authorization does not generalize.

## Interactive shell is fish

When giving me commands to run in my terminal, write them so they work in **fish** (3.x). The harness's Bash tool runs bash internally, but anything you tell me to paste into my own shell must be fish-compatible.

**Avoid (bash-only):**
- Heredocs: `cmd << 'EOF' ... EOF` and `<<<` — fish has no heredoc syntax. Use `printf '%s\n' 'line1' 'line2' | sudo tee file` or `echo '...' | tee` instead.
- `export FOO=bar` — fish uses `set -x FOO bar`.
- `FOO=bar cmd` (inline env assignment) — fish uses `env FOO=bar cmd` or `FOO=bar cmd` only works inside `env`.
- Process substitution `<(cmd)` — fish uses `(cmd | psub)`.
- `$(...)` works in fish, but legacy backticks ` `` ` do not.
- Arrays: bash `arr=(a b c)` / `${arr[@]}` — fish uses `set arr a b c` / `$arr`.
- C-style `for ((i=0;i<n;i++))` and `[[ ]]` tests — fish uses `for i in (seq ...)` and `test ...` / `string match`.
- Brace+comma expansion in some edge cases works, but prefer explicit lists.

**Safe in both fish and bash:**
- `&&`, `||`, `|` (fish 3.0+).
- `$VAR`, `$(cmd)`.
- Single- and double-quoted strings (escape rules are close enough for typical commands).
- Standard POSIX redirects: `>`, `>>`, `2>&1`, `<`.
- `if cmd; then ...; fi` — actually NO, this is bash. Use the safe form: just chain with `&&` or write a one-liner that doesn't need flow control.

**Practical rule:** when I need to write a multi-line config file, prefer `printf '%s\n' 'line1' 'line2' ... | sudo tee /path/file` over heredocs. If the content is long enough that printf is awkward, write it to a temp file via the Write tool and then have me `sudo cp` it into place.

**Why:** fish is my daily-driver shell; bash heredocs and `export FOO=bar` either error out or silently do the wrong thing when pasted into fish.

## No em-dashes or en-dashes

Never use em-dashes (`—`) or en-dashes (`–`) anywhere in your output: not in chat replies, not in code or comments, and not in files you create or edit. Use a regular hyphen (`-`) instead, and where a hyphen reads awkwardly, rephrase using commas, parentheses, a colon, or separate sentences.

**Why:** I find em-dashes visually disruptive and they read as machine-generated. A plain hyphen or a reworded sentence is always preferable.

## How to work with me (matters most for less capable models)

These are behaviors the best models do by default and weaker ones skip under load. Follow them explicitly.

- **Verify, don't assert.** Before stating a file path, symbol, flag, or that something works, confirm it this session (read the file, run the command). If you're recalling from training or inferring, say so plainly.
- **Prove "done."** If you claim a change works, run the build/test/lint that shows it. If you can't run it, say what's unverified rather than implying success.
- **Minimal diffs.** Change only what the task needs; don't reformat, reorder imports, or rewrite untouched code. Match the existing file's style.
- **Read the actual error.** When a command or tool call fails, read the output before retrying; don't repeat the same call or guess at a fix.
- **Stay in scope.** Do what was asked. If you spot an unrelated improvement, mention it; don't do it unprompted. Don't add dependencies or new tools without asking first.

**Why:** each of these is a failure mode I hit more with weaker models (hallucinated paths/APIs, false "it works" claims, collateral reformatting, retry loops, scope creep). Stating them in checkable form raises the floor.
