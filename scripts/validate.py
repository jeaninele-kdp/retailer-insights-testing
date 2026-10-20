#!/usr/bin/env python3
"""Validate Walmart PO fixtures against validation/rules/rules.json."""

from __future__ import annotations

import argparse
import json
import sys
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RULES_PATH = ROOT / "validation" / "rules" / "rules.json"
FIXTURES_DIR = ROOT / "fixtures" / "purchase-orders"


def load_rules() -> list[dict]:
    catalog = json.loads(RULES_PATH.read_text(encoding="utf-8"))
    return catalog["rules"]


def parse_date(value: str) -> date:
    return date.fromisoformat(value)


def run_rule(rule: dict, po: dict) -> bool:
    check = rule["check"]
    if check == "required_non_empty":
        value = po.get(rule["field"])
        return bool(value and str(value).strip())

    if check == "date_gte":
        left = po.get(rule["field"])
        right = po.get(rule["compareField"])
        if not left or not right:
            return False
        return parse_date(left) >= parse_date(right)

    if check == "cancelled_zero_open_qty":
        if po.get(rule["field"]) != "Cancelled":
            return True
        lines = po.get("lines") or []
        return all(float(line.get("openQuantity", 0)) == 0 for line in lines)

    if check == "unique_line_keys":
        seen: set[tuple[int, str]] = set()
        for line in po.get("lines") or []:
            key = (line.get("lineNumber"), str(line.get("itemNumber", "")))
            if key in seen:
                return False
            seen.add(key)
        return True

    raise ValueError(f"Unknown check type: {check}")


def evaluate_po(po: dict, rules: list[dict]) -> list[str]:
    failures: list[str] = []
    for rule in rules:
        if not run_rule(rule, po):
            failures.append(rule["id"])
    return failures


def check_fixture(path: Path, rules: list[dict]) -> tuple[bool, str]:
    po = json.loads(path.read_text(encoding="utf-8"))
    meta = po.get("_meta", {})
    expected = meta.get("expectation")
    expected_failures = set(meta.get("expectedRuleFailures") or [])
    actual_failures = set(evaluate_po(po, rules))

    if expected == "pass":
        ok = not actual_failures
        detail = f"expected pass, got failures {sorted(actual_failures)}"
    elif expected == "fail":
        ok = actual_failures == expected_failures
        detail = (
            f"expected failures {sorted(expected_failures)}, "
            f"got {sorted(actual_failures)}"
        )
    else:
        ok = False
        detail = f"invalid _meta.expectation: {expected}"

    return ok, detail


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "fixtures",
        nargs="*",
        help="Fixture paths (default: all JSON under fixtures/purchase-orders)",
    )
    parser.add_argument("--list-rules", action="store_true")
    args = parser.parse_args()

    rules = load_rules()
    if args.list_rules:
        for rule in rules:
            print(f"{rule['id']}: {rule['name']}")
        return 0

    paths = [Path(p) for p in args.fixtures] if args.fixtures else sorted(FIXTURES_DIR.glob("*.json"))
    if not paths:
        print("No fixtures found.", file=sys.stderr)
        return 1

    failed = 0
    for path in paths:
        ok, detail = check_fixture(path, rules)
        status = "OK" if ok else "FAIL"
        print(f"{status}  {path.name}  ({detail})")
        if not ok:
            failed += 1

    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
