#!/usr/bin/env python3
"""Conservative guard for visible Git/GitHub tool calls, not a shell sandbox.

Accept a deliberately small command grammar and read-option allowlist. Never
execute the supplied command. Unknown Git/GitHub forms are denied; unrelated
shell commands remain subject to Codex's normal sandbox and approval policy.
"""

import json
import os
import re
import shlex
import sys


class Denied(ValueError):
    pass


DIFF_FLAGS = {
    "--stat", "--shortstat", "--numstat", "--name-only", "--name-status",
    "--summary", "--check", "--raw", "--patch", "-p", "-s", "--no-patch",
    "--binary", "--full-index", "--no-renames", "--find-renames",
    "--no-color", "--no-ext-diff", "--no-textconv", "--relative",
    "--ignore-space-at-eol", "--ignore-all-space", "-w", "--ignore-space-change",
    "-b", "--ignore-blank-lines", "--exit-code", "--quiet",
}
LOG_FLAGS = DIFF_FLAGS | {
    "--oneline", "--graph", "--all", "--decorate", "--no-decorate",
    "--reverse", "--first-parent", "--no-merges", "--merges", "--follow",
    "--topo-order", "--date-order", "--abbrev-commit", "--no-abbrev-commit",
    "--left-right", "--cherry-pick", "--boundary",
}
GIT_FLAGS = {
    "status": {"--short", "-s", "--branch", "-b", "--porcelain", "--ignored", "-z"},
    "diff": DIFF_FLAGS | {"--cached", "--staged"},
    "log": LOG_FLAGS,
    "show": LOG_FLAGS,
    "blame": {"--porcelain", "--line-porcelain", "--incremental", "-w", "-s", "-e", "--no-textconv"},
    "ls-files": {"--cached", "--deleted", "--modified", "--others", "--ignored", "--stage", "--unmerged", "--exclude-standard", "--full-name", "-z"},
    "ls-tree": {"-r", "-t", "-d", "-l", "-z", "--name-only", "--name-status", "--full-tree", "--full-name"},
    "rev-parse": {"--verify", "--quiet", "--short", "--abbrev-ref", "--show-toplevel", "--show-prefix", "--git-dir", "--is-inside-work-tree", "--is-bare-repository", "--show-object-format", "--symbolic-full-name", "--end-of-options"},
    "branch": {"--list", "--all", "-a", "--remotes", "-r", "--show-current", "-v", "-vv", "--no-color"},
    "tag": {"--list", "-l", "--no-color"},
}
GIT_VALUES = {
    "status": {"--porcelain", "--untracked-files", "--ignore-submodules"},
    "diff": {"--unified", "-U", "--inter-hunk-context", "--diff-filter", "--find-renames", "--relative"},
    "log": {"--max-count", "-n", "--format", "--pretty", "--since", "--until", "--author", "--committer", "--grep", "--date", "--unified", "-U"},
    "show": {"--format", "--pretty", "--date", "--unified", "-U"},
    "blame": {"-L"},
    "rev-parse": {"--short"},
    "branch": {"--format", "--sort", "--contains", "--merged", "--no-merged"},
    "tag": {"--format", "--sort", "--contains", "--merged", "--no-merged"},
}
GH_COMMANDS = {
    ("pr", "view"), ("pr", "list"), ("pr", "diff"), ("pr", "checks"), ("pr", "status"),
    ("issue", "view"), ("issue", "list"), ("issue", "status"),
    ("repo", "view"), ("run", "view"), ("run", "list"),
}
GH_FLAGS = {"--comments", "--patch", "--name-only", "--watch", "--required", "--log", "--log-failed", "--exit-status"}
GH_VALUES = {"--repo", "-R", "--json", "--jq", "-q", "--limit", "-L", "--state", "--author", "--assignee", "--label", "--search", "--base", "--head", "--branch", "--workflow", "--status", "--job", "--interval", "--color"}


def check_options(args, flags, values):
    """Return positional arguments; reject unknown options, including abbreviations."""
    positional = []
    index = 0
    while index < len(args):
        arg = args[index]
        if arg == "--":
            positional.extend(args[index + 1:])
            break
        if arg in flags:
            pass
        elif arg in values:
            index += 1
            if index == len(args) or args[index].startswith("-"):
                raise Denied("Missing or ambiguous inspection option value.")
        elif "=" in arg and arg.split("=", 1)[0] in values:
            pass
        elif re.fullmatch(r"-(?:n|U)\d+", arg) and arg[:2] in values:
            pass
        elif arg.startswith("-"):
            raise Denied("Unknown inspection option: " + arg)
        else:
            positional.append(arg)
        index += 1
    return positional


def git_command(argv):
    index = 1
    while index < len(argv):
        arg = argv[index]
        if arg in {"--no-pager", "--no-optional-locks"}:
            index += 1
        elif arg == "-C" and index + 1 < len(argv):
            index += 2
        else:
            break
    if index == len(argv) or argv[index] not in GIT_FLAGS:
        raise Denied("Only known Git inspection commands are permitted; global config overrides and aliases are blocked.")
    verb, args = argv[index], argv[index + 1:]
    positional = check_options(args, GIT_FLAGS[verb], GIT_VALUES.get(verb, set()))
    options = args[:args.index("--")] if "--" in args else args
    if verb in {"branch", "tag"} and positional and not ({"--list", "-l"} & set(options)):
        raise Denied("Branch/tag patterns require --list; creation is prohibited.")
    # Neutralize configured pagers, optional index writes, external diff drivers,
    # and textconv (which can execute commands and cache results).
    safe = [argv[0], "--no-pager", "--no-optional-locks",
            "-c", "core.fsmonitor=false", "-c", "log.showSignature=false",
            *argv[1:index], verb]
    if verb in {"diff", "log", "show"}:
        safe += ["--no-ext-diff", "--no-textconv"]
    elif verb == "blame":
        safe += ["--no-textconv"]
    return safe + args


def gh_command(argv):
    if len(argv) < 3 or tuple(argv[1:3]) not in GH_COMMANDS:
        raise Denied("Only known gh inspection commands are permitted. API calls, extensions, aliases, and writes are blocked.")
    check_options(argv[3:], GH_FLAGS, GH_VALUES)
    return argv


def shell_command(command):
    lexer = shlex.shlex(command, posix=True, punctuation_chars=";&|()<>\n")
    lexer.whitespace = " \t\r"
    lexer.commenters = ""
    tokens = list(lexer)
    mentions_git = any(os.path.basename(token) in {"git", "gh"} for token in tokens)
    # Opaque interpreter strings and substitutions containing visible Git also
    # need review. This intentionally errs on the side of false positives.
    mentions_git |= bool(re.search(r"(?<![\w.-])(?:git|gh)(?![\w.-])", command))
    if not mentions_git:
        return None
    if any(char in command for char in "$`\\"):
        raise Denied("Use a direct Git/GitHub inspection call without expansion or escapes.")
    if any(char in command for char in "*?[") or any(token.startswith("~") for token in tokens):
        raise Denied("Use literal paths and arguments in Git/GitHub calls; shell glob/tilde expansion is not supported.")
    segments, current, separators = [], [], []
    for token in tokens:
        if token in {"&&", "||", ";", "\n", "|"}:
            if not current:
                raise Denied("Use a simple Git/GitHub inspection command.")
            segments.append(current)
            current = []
            separators.append(";" if token == "\n" else token)
        elif token and all(char in ";&|()<>\n" for char in token):
            raise Denied("Git/GitHub calls cannot use redirection, backgrounding, or subshells.")
        else:
            current.append(token)
    if current:
        segments.append(current)
    if not segments or len(separators) >= len(segments):
        raise Denied("Use a simple Git/GitHub inspection command without trailing separators.")
    rewritten = []
    found = False
    for argv in segments:
        program = os.path.basename(argv[0])
        if program == "git":
            rewritten.append(shlex.join(git_command(argv)))
            found = True
        elif program == "gh":
            rewritten.append(shlex.join(gh_command(argv)))
            found = True
        else:
            # Never reinterpret/requote unrelated shell commands. Split mixed
            # pipelines/chains into separate tool calls instead.
            raise Denied("Run Git/GitHub separately from other commands; use the tool working directory or git -C.")
    if not found:
        raise Denied("Cannot validate an indirect Git/GitHub reference. Use a direct inspection call.")
    result = rewritten[0]
    for separator, part in zip(separators, rewritten[1:]):
        result += " " + separator + " " + part
    return result


def evaluate(payload):
    if not isinstance(payload, dict) or payload.get("hook_event_name") != "PreToolUse":
        raise Denied("Invalid hook event; expected PreToolUse.")
    name = payload.get("tool_name", "")
    if not isinstance(name, str):
        raise Denied("Invalid tool name.")
    if name.startswith("mcp__") and "github" in name:
        action = re.split(r"github_+", name, maxsplit=1)[-1]
        if not re.match(r"(?:get|list|search|fetch|compare)(?:_|$)", action):
            raise Denied("GitHub connector writes and unknown operations are handled manually by the user.")
        return None
    if name != "Bash":
        raise Denied("Unexpected tool name for Git policy hook.")
    tool_input = payload.get("tool_input")
    if not isinstance(tool_input, dict) or not isinstance(tool_input.get("command"), str):
        raise Denied("Missing shell command in hook input.")
    if not tool_input["command"].strip():
        raise Denied("Empty shell command.")
    rewritten = shell_command(tool_input["command"])
    if rewritten is None:
        return None
    return {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "allow",
            "updatedInput": {**tool_input, "command": rewritten},
        }
    }


def main():
    try:
        result = evaluate(json.load(sys.stdin))
    except Exception as error:
        # Explicit deny, including malformed JSON and internal parser failures.
        result = {"hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": "Personal Git/GitHub read-only policy: " + str(error),
        }}
    if result is not None:
        print(json.dumps(result))


if __name__ == "__main__":
    main()
