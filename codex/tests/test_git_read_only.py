"""Policy tests only. Git/GitHub command strings are never executed."""

import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "hooks" / "git_read_only.py"
SPEC = importlib.util.spec_from_file_location("git_read_only", SCRIPT)
POLICY = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(POLICY)


def payload(command):
    return {"hook_event_name": "PreToolUse", "tool_name": "Bash",
            "tool_input": {"command": command, "cwd": "/tmp/example"}}


class GitPolicyTests(unittest.TestCase):
    def test_inspection(self):
        cases = [
            "git status", "git status --porcelain=v1 -b", "git diff",
            "git -C '/tmp/a repo' diff --cached --name-only",
            "/usr/bin/git log -n 5 --oneline", "git log -n5 --format=%H",
            "git log --grep=commit --since=2026-01-01",
            "git show HEAD:src/main.py", "git blame -L 1,20 -- src/main.py",
            "git ls-files --exclude-standard --others",
            "git ls-tree -r --name-only HEAD", "git rev-parse --show-toplevel",
            "git branch", "git branch --show-current", "git branch --list main",
            "git tag", "git tag --list v1", "git diff HEAD~1 -- file.py",
            "git --no-pager --no-optional-locks diff --no-ext-diff --no-textconv",
            "git status && git diff", "git status\ngit diff",
            "gh pr view 12 --json title,body", "gh pr diff 12 --repo owner/repo",
            "gh issue list --limit 10", "gh run view 123 --log-failed",
            "gh repo view owner/repo", "gh pr checks 12",
        ]
        for command in cases:
            with self.subTest(command=command):
                result = POLICY.evaluate(payload(command))["hookSpecificOutput"]
                self.assertEqual(result["permissionDecision"], "allow")
                self.assertEqual(result["updatedInput"]["cwd"], "/tmp/example")

    def test_unrelated_commands_unchanged(self):
        for command in ["rg --files", "python3 -m unittest", "awk '{ print $1 }' data.txt",
                        "sed -n '1,40p' README.md", "cat .git/HEAD", "ls .github"]:
            with self.subTest(command=command):
                self.assertIsNone(POLICY.evaluate(payload(command)))

    def test_writes_and_unsafe_forms(self):
        cases = [
            "git add .", "git commit -m example", "git fetch origin",
            "git pull", "git push", "git init", "git clone example",
            "git -C /tmp/repo commit -m example",
            "/usr/bin/git -C /tmp/repo fetch", "git -c alias.x=commit x",
            "git --git-dir=/tmp/repo/.git update-ref refs/heads/main HEAD",
            "git config user.name example", "git worktree add /tmp/tree",
            "git branch new", "git tag new", "git branch -D old", "git tag -d old",
            "git branch new -- --list", "git tag new -- --list",
            "git status && git commit -m example", "cd /tmp/repo && git commit",
            "git status\ngit push", "git status | git apply",
            "env git commit", "command git commit", "sudo git commit",
            "bash -c 'git commit'", "python3 -c \"import os; os.system('git commit')\"",
            "git diff --output=/tmp/result", "git log --output /tmp/result",
            "git log --out=/tmp/result", "git diff --ext-diff", "git show --textconv",
            "git diff > /tmp/result", "git status &", "git status;",
            "git status $(touch /tmp/result)", "git log `touch /tmp/result`",
            "g\\it commit", "git diff -- *.py", "git -C ~/repo status",
            "git diff | cat", "git unknown", "git -C", "git log -n",
            "gh pr create", "gh pr merge 12", "gh issue comment 12 --body hello",
            "gh api repos/owner/repo -X DELETE", "gh api user",
            "gh alias set x 'pr create'", "gh extension exec something",
            "gh pr view 12 --web", "gh run download 123",
            "gh -R owner/repo pr create", "gh repo delete owner/repo",
        ]
        for command in cases:
            with self.subTest(command=command):
                with self.assertRaises((POLICY.Denied, ValueError)):
                    POLICY.evaluate(payload(command))

    def test_git_side_effect_controls(self):
        for verb in ["diff", "log", "show", "blame", "status"]:
            result = POLICY.evaluate(payload("git " + verb))
            command = result["hookSpecificOutput"]["updatedInput"]["command"]
            self.assertIn("--no-optional-locks", command)
            self.assertIn("--no-pager", command)
            self.assertIn("core.fsmonitor=false", command)
            self.assertIn("log.showSignature=false", command)
            if verb in {"diff", "log", "show"}:
                self.assertIn("--no-ext-diff", command)
                self.assertIn("--no-textconv", command)
            if verb == "blame":
                self.assertIn("--no-textconv", command)

    def test_github_connector(self):
        for name in ["mcp__codex_apps__github_search", "mcp__github__get_commit",
                     "mcp__codex_apps__github_fetch"]:
            self.assertIsNone(POLICY.evaluate({"hook_event_name": "PreToolUse", "tool_name": name}))
        for name in ["mcp__codex_apps__github_create_pull_request", "mcp__github__push_files",
                     "mcp__github__add_issue_comment", "mcp__github__unknown"]:
            with self.assertRaises(POLICY.Denied):
                POLICY.evaluate({"hook_event_name": "PreToolUse", "tool_name": name})

    def test_hook_protocol(self):
        for raw in ["not json", "null", "{}", "[]", json.dumps(payload(""))]:
            result = subprocess.run([sys.executable, "-B", str(SCRIPT)], input=raw,
                                    capture_output=True, text=True, check=True)
            self.assertEqual(json.loads(result.stdout)["hookSpecificOutput"]["permissionDecision"], "deny")
        result = subprocess.run([sys.executable, "-B", str(SCRIPT)],
                                input=json.dumps(payload("rg --files")),
                                capture_output=True, text=True, check=True)
        self.assertEqual(result.stdout, "")


if __name__ == "__main__":
    unittest.main()
