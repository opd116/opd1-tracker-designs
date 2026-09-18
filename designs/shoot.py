"""Screenshot every rendered mockup, including the Arabic RTL variants.

Usage: python3 shoot.py
"""

from __future__ import annotations

from pathlib import Path

from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parent
OUT = ROOT / "renders"

VIEWPORT = {"A-sidecar": (500, 940), "B-broadcast": (1260, 900),
            "C-dossier": (1320, 940)}


def main() -> int:
    OUT.mkdir(exist_ok=True)
    jobs = []
    for variant in ["A-sidecar", "B-broadcast", "C-dossier"]:
        for state in ["ingame", "pregame", "lobby", "menus", "offline"]:
            jobs.append((variant, f"{state}.html", f"{variant}__{state}"))
        for state in ["ingame", "pregame"]:
            jobs.append((variant, f"{state}-ar.html", f"{variant}__{state}-ar"))

    with sync_playwright() as pw:
        browser = pw.chromium.launch(
            executable_path="/usr/bin/chromium",
            args=["--no-sandbox", "--disable-dev-shm-usage"],
        )
        for variant, src, name in jobs:
            w, h = VIEWPORT[variant]
            page = browser.new_page(viewport={"width": w, "height": h},
                                    device_scale_factor=2)
            page.goto((ROOT / variant / src).as_uri(), wait_until="networkidle")
            # Give webfonts and the remote agent/rank artwork time to land.
            page.wait_for_timeout(2600)
            page.screenshot(path=str(OUT / f"{name}.png"), full_page=True)
            print(f"  {name}.png", flush=True)
            page.close()
        browser.close()
    print(f"done -> {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
