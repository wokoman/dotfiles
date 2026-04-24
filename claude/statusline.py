#!/usr/bin/env python3
"""Claude Code statusline — single line, wide display."""

import json
import os
import sys
import time

# ── ANSI ──────────────────────────────────────────────────────────────────────
R  = "\033[0m"
BD = "\033[1m"
DM = "\033[2m"
CY = "\033[36m"   # cyan
YL = "\033[33m"   # yellow
RD = "\033[31m"   # red
GR = "\033[32m"   # green
WH = "\033[97m"   # bright white

SEP = f"{DM} │ {R}"


def build_bar(pct: int, width: int,
              c_lo: str = WH, c_mid: str = YL, c_hi: str = RD,
              lo: int = 60, hi: int = 85) -> str:
    filled = round(pct * width / 100)
    color  = c_lo if pct <= lo else (c_mid if pct <= hi else c_hi)
    return f"{color}{'█' * filled}{DM}{'░' * (width - filled)}{R}"


def fmt_num(n: int) -> str:
    if n >= 1_000_000: return f"{n / 1_000_000:.1f}M"
    if n >= 1_000:     return f"{n / 1_000:.1f}k"
    return str(n)


def fmt_countdown(secs: int) -> str:
    if secs <= 0: return "now"
    d, r = divmod(secs, 86400)
    h, r = divmod(r, 3600)
    m    = r // 60
    if d: return f"{d}d"
    if h: return f"{h}h{m}m"
    return f"{m}m"


def last_turn_usage(path: str) -> dict | None:
    """Scan transcript JSONL and return the last assistant usage block."""
    if not path or not os.path.isfile(path):
        return None
    last = None
    try:
        with open(path, errors="ignore") as f:
            for line in f:
                if '"role":"assistant"' not in line:
                    continue
                try:
                    entry = json.loads(line)
                    usage = (entry.get("message") or {}).get("usage") or {}
                    if usage.get("input_tokens", 0) > 0:
                        last = usage
                except json.JSONDecodeError:
                    pass
    except OSError:
        pass
    return last


# ── Parse input ───────────────────────────────────────────────────────────────
data   = json.loads(sys.stdin.read())
model  = (data.get("model") or {}).get("display_name", "unknown")
effort = (data.get("effort") or {}).get("level", "")
ctx    = data.get("context_window") or {}
rl     = data.get("rate_limits") or {}
cost   = (data.get("cost") or {}).get("total_cost_usd")

parts: list[str] = []

# 1 · model + effort
head = f"{BD}{model}{R}"
if effort:
    head += f" {DM}[{effort}]{R}"
parts.append(head)

# 2 · context bar + %
if (used := ctx.get("used_percentage")) is not None:
    pct = round(used)
    pct_color = CY if pct <= 40 else (YL if pct <= 80 else RD)
    parts.append(f"{build_bar(pct, 15, CY, YL, RD)}  {pct_color}{pct}%{R}")

# 3 · last-turn tokens
if u := last_turn_usage(data.get("transcript_path", "")):
    tok_in    = u.get("input_tokens", 0)
    tok_out   = u.get("output_tokens", 0)
    tok_cache = u.get("cache_read_input_tokens", 0)
    total     = tok_in + tok_cache
    if total > 0 and (ratio := tok_cache / total) > 0.5:
        cache_color = GR
    elif total > 0 and ratio < 0.2 and tok_in > 500:
        cache_color = YL
    else:
        cache_color = ""
    parts.append(
        f"↑{DM}In{R} {fmt_num(tok_in)}  "
        f"↓{DM}Out{R} {fmt_num(tok_out)}  "
        f"⚡ {cache_color}{fmt_num(tok_cache)}{R}"
    )

# 4 · rate limits
rl_segs: list[str] = []
for key, label, show_cd in [("five_hour", "5h", True), ("seven_day", "7d", False)]:
    if not (w := rl.get(key)):
        continue
    pct = round(w.get("used_percentage", 0))
    pct_color = R if pct <= 60 else (YL if pct <= 85 else RD)
    seg = f"{DM}{label}{R} {build_bar(pct, 6)} {pct_color}{pct}%{R}"
    if show_cd and (resets_at := w.get("resets_at")):
        seg += f" {DM}↺{fmt_countdown(int(resets_at - time.time()))}{R}"
    rl_segs.append(seg)
if rl_segs:
    parts.append("  ".join(rl_segs))

# 5 · session cost
if cost is not None:
    parts.append(f"{DM}${cost:.2f}{R}")

print(SEP.join(parts))
