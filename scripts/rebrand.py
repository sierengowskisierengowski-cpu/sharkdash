#!/usr/bin/env python3
"""Rebrand btop++ sources to sharkdash."""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKIP_DIRS = {".git", "obj", "bin", "build"}

# Order matters: longer / more specific patterns first
REPLACEMENTS = [
    ("btop_main", "sharkdash_main"),
    ("BTOP_DEBUG", "SHARKDASH_DEBUG"),
    ("BTOP_VERSION", "SHARKDASH_VERSION"),
    ("btop_collect", "sharkdash_collect"),
    ("btop.hpp", "sharkdash.hpp"),
    ("btop_", "sharkdash_"),
    ("/btop/", "/sharkdash/"),
    ("/btop\"", "/sharkdash\""),
    ("share/btop", "share/sharkdash"),
    ("doc/btop", "doc/sharkdash"),
    ("applications/btop", "applications/sharkdash"),
    ("apps/btop", "apps/sharkdash"),
    ("man1/btop", "man1/sharkdash"),
    ("bin/btop", "bin/sharkdash"),
    ("btop.1", "sharkdash.1"),
    ("btop.desktop", "sharkdash.desktop"),
    (" name=btop", " name=sharkdash"),
    ("Exec=btop", "Exec=sharkdash"),
    ("project(btop", "project(sharkdash"),
    ("add_executable(btop", "add_executable(sharkdash"),
    ("TARGET btop", "TARGET sharkdash"),
    ("btop++", "Sharkdash"),
    ("Btop++", "Sharkdash"),
    ("Btop", "Sharkdash"),
    # Binary / app name as standalone token
    (re.compile(r"\bbtop\b"), "sharkdash"),
]

TEXT_EXTENSIONS = {
    ".cpp", ".hpp", ".h", ".c", ".in", ".md", ".txt", ".yml", ".yaml",
    ".desktop", ".cmake", ".json", ".json5", ".utf8", ".1", "Makefile",
    "CMakeLists.txt", ".sh",
}


def should_process(path: Path) -> bool:
    if any(part in SKIP_DIRS for part in path.parts):
        return False
    if path.name in TEXT_EXTENSIONS:
        return True
    return path.suffix in TEXT_EXTENSIONS


def apply_replacements(text: str) -> str:
    for old, new in REPLACEMENTS:
        if isinstance(old, re.Pattern):
            text = old.sub(new, text)
        else:
            text = text.replace(old, new)
    return text


def main() -> None:
    changed = 0
    for path in sorted(ROOT.rglob("*")):
        if not path.is_file() or not should_process(path):
            continue
        try:
            original = path.read_text(encoding="utf-8")
        except (UnicodeDecodeError, OSError):
            continue
        updated = apply_replacements(original)
        if updated != original:
            path.write_text(updated, encoding="utf-8")
            changed += 1
            print(f"updated: {path.relative_to(ROOT)}")
    print(f"Done. {changed} files updated.")


if __name__ == "__main__":
    main()
