#!/usr/bin/env python3
"""PostToolUse hook: normalize em-dashes / en-dashes to plain hyphens.

Reads the tool-call JSON from stdin (the standard hook contract) and rewrites
the just-edited file in place.

Scope rule (this is the whole point of the script):
  * Write          -> the entire file content was just authored by Claude, so
                      normalizing the whole file only touches our own text.
  * Edit/MultiEdit -> normalize ONLY the exact string(s) that were inserted
                      (tool_input.new_string, or each edits[].new_string).
                      Pre-existing dashes elsewhere in the file are left alone,
                      so the diff stays limited to the lines actually changed.

Failures are swallowed: a hook should never block or corrupt an edit.
"""
import sys
import json

# Use escapes, not literal glyphs: U+2014 em-dash, U+2013 en-dash. This keeps
# the table immune to the very normalization this hook performs.
DASHES = str.maketrans({chr(0x2014): "-", chr(0x2013): "-"})


def main() -> None:
    try:
        data = json.load(sys.stdin)
    except Exception:
        return

    tool_input = data.get("tool_input") or {}
    path = tool_input.get("file_path")
    if not path:
        return

    try:
        with open(path, "r", encoding="utf-8") as fh:
            content = fh.read()
    except Exception:
        return

    tool = data.get("tool_name", "")

    if tool == "Write":
        new_content = content.translate(DASHES)
    else:
        # Edit / MultiEdit: only normalize the inserted text.
        inserted = []
        if tool_input.get("new_string"):
            inserted.append(tool_input["new_string"])
        for edit in tool_input.get("edits") or []:
            if edit.get("new_string"):
                inserted.append(edit["new_string"])

        new_content = content
        for original in inserted:
            cleaned = original.translate(DASHES)
            if cleaned != original and original in new_content:
                new_content = new_content.replace(original, cleaned)

    if new_content != content:
        try:
            with open(path, "w", encoding="utf-8") as fh:
                fh.write(new_content)
        except Exception:
            return


if __name__ == "__main__":
    main()
