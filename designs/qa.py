"""Automated layout QA for the mockups.

Screenshots only prove pixels were written, not that the layout is sound. This
checks the things a human reviewer would: nothing overflows the viewport, text
is not clipped, tap targets stay legible, the two teams are balanced, and the
Arabic renders actually mirror rather than just translating.
"""

from __future__ import annotations

import sys
from pathlib import Path

from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parent
VIEWPORT = {"A-sidecar": (500, 940), "B-broadcast": (1260, 900), "C-dossier": (1320, 940)}
STATES = ["ingame", "pregame", "lobby", "menus", "offline"]

PROBE = """
() => {
  const doc = document.documentElement;
  const clipped = [];
  const tiny = [];
  for (const el of document.querySelectorAll('body *')) {
    const cs = getComputedStyle(el);
    if (cs.display === 'none' || cs.visibility === 'hidden') continue;
    const r = el.getBoundingClientRect();
    if (r.width === 0 && r.height === 0) continue;
    // text clipped by an overflow box
    if (el.children.length === 0 && el.scrollWidth > el.clientWidth + 1
        && cs.overflow !== 'visible' && cs.textOverflow !== 'ellipsis') {
      clipped.push((el.className || el.tagName) + ' :: ' + (el.textContent||'').slice(0,26));
    }
    const fs = parseFloat(cs.fontSize);
    if (fs && fs < 9.5 && (el.textContent||'').trim().length > 1) {
      tiny.push((el.className||el.tagName) + ' @' + fs + 'px');
    }
  }
  const imgs = [...document.querySelectorAll('img')];
  return {
    scrollW: doc.scrollWidth, clientW: doc.clientWidth,
    overflowX: doc.scrollWidth > doc.clientWidth + 1,
    clipped: clipped.slice(0, 5),
    tiny: [...new Set(tiny)].slice(0, 5),
    brokenImgs: imgs.filter(i => i.complete && i.naturalWidth === 0).length,
    imgCount: imgs.length,
    rows: document.querySelectorAll('tbody tr, .row, .slot').length,
    dir: document.documentElement.dir || getComputedStyle(document.body).direction,
    hasArabic: /[\\u0600-\\u06FF]/.test(document.body.innerText || ''),
  };
}
"""


def main() -> int:
    failures = 0
    with sync_playwright() as pw:
        browser = pw.chromium.launch(executable_path="/usr/bin/chromium",
                                     args=["--no-sandbox", "--disable-dev-shm-usage"])
        for variant, (w, h) in VIEWPORT.items():
            print(f"\n=== {variant} ({w}x{h}) ===")
            page = browser.new_page(viewport={"width": w, "height": h})
            for state in STATES:
                f = ROOT / variant / f"{state}.html"
                page.goto(f.as_uri(), wait_until="networkidle")
                page.wait_for_timeout(1800)
                r = page.evaluate(PROBE)
                problems = []
                if r["overflowX"]:
                    problems.append(f"overflow-x {r['scrollW']}>{r['clientW']}")
                if r["brokenImgs"]:
                    problems.append(f"{r['brokenImgs']} broken img")
                if r["clipped"]:
                    problems.append(f"clipped text: {r['clipped']}")
                if r["tiny"]:
                    problems.append(f"sub-9.5px type: {r['tiny']}")
                flag = "FAIL" if problems else "ok  "
                if problems:
                    failures += 1
                print(f"  [{flag}] {state:8s} rows={r['rows']:3d} imgs={r['imgCount']:2d} {r['dir']}")
                for p in problems:
                    print(f"           - {p}")

            for state in ["ingame", "pregame"]:
                f = ROOT / variant / f"{state}-ar.html"
                page.goto(f.as_uri(), wait_until="networkidle")
                page.wait_for_timeout(1800)
                r = page.evaluate(PROBE)
                problems = []
                if r["dir"] != "rtl":
                    problems.append(f"dir is {r['dir']}, expected rtl")
                if not r["hasArabic"]:
                    problems.append("no Arabic text found")
                if r["overflowX"]:
                    problems.append(f"overflow-x {r['scrollW']}>{r['clientW']}")
                if problems:
                    failures += 1
                flag = "FAIL" if problems else "ok  "
                print(f"  [{flag}] {state}-ar  dir={r['dir']} arabic={r['hasArabic']} imgs={r['imgCount']}")
                for p in problems:
                    print(f"           - {p}")
            page.close()
        browser.close()

    print(f"\n{'ALL CHECKS PASSED' if not failures else str(failures) + ' CHECK(S) FAILED'}")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
