"""Build the gallery pages that tie the screenshots and mockups together.

Produces:
  gallery/index.html        the shipped app, every state and view
  gallery/designs.html      the three redesign variants
  gallery/compare.html      the three variants for one state, side by side

Usage: python3 gallery.py
"""

from __future__ import annotations

import html
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SHOTS = ROOT / "shots"
RENDERS = ROOT / "designs" / "renders"
OUT = ROOT / "gallery"

VIEWS = ["live", "performance", "encounters", "saved", "settings"]
STATES = ["menus", "lobby", "pregame", "ingame", "offline"]
VARIANTS = [
    ("A-sidecar", "A · Sidecar",
     "A narrow 412px companion panel for a second monitor. Built to be read in a "
     "half-second mid-round without covering the game."),
    ("B-broadcast", "B · Broadcast",
     "A full-width theatre board with the two teams facing each other across the "
     "score. Sized for a stream overlay or a TV across the room."),
    ("C-dossier", "C · Dossier",
     "A light, print-like intelligence sheet. Sorts every player by estimated "
     "impact so the threat is at the top before the match starts."),
]

CSS = """
:root{--bg:#0b0e11;--panel:#12171c;--line:#232c34;--ink:#e8eef3;--ink2:#8fa0ac;--ink3:#5f6f7a;--accent:#2fd4a7}
*{box-sizing:border-box;margin:0;padding:0}
body{background:var(--bg);color:var(--ink);font:15px/1.6 Inter,system-ui,-apple-system,sans-serif;padding:48px 40px 80px}
.wrap{max-width:1400px;margin:0 auto}
h1{font-size:30px;font-weight:700;letter-spacing:-.02em}
h2{font-size:20px;font-weight:600;margin:52px 0 6px;padding-top:26px;border-top:1px solid var(--line)}
h3{font-size:15px;font-weight:600;color:var(--ink2);margin:26px 0 12px;
   text-transform:uppercase;letter-spacing:.09em}
p.lead{color:var(--ink2);max-width:74ch;margin-top:10px}
.meta{color:var(--ink3);font-size:13px;margin-top:12px}
.grid{display:grid;gap:16px;margin-top:16px}
.g5{grid-template-columns:repeat(auto-fill,minmax(250px,1fr))}
.g3{grid-template-columns:repeat(auto-fill,minmax(360px,1fr))}
figure{background:var(--panel);border:1px solid var(--line);border-radius:11px;overflow:hidden}
figure img{width:100%;display:block;background:#000}
figcaption{padding:10px 13px;font-size:12.5px;color:var(--ink2);
           border-top:1px solid var(--line);font-variant-numeric:tabular-nums}
figcaption b{color:var(--ink);font-weight:600}
.vcard{background:var(--panel);border:1px solid var(--line);border-radius:13px;
       padding:22px 24px;margin-top:16px}
.vcard h4{font-size:19px;font-weight:600;letter-spacing:-.01em}
.vcard p{color:var(--ink2);font-size:14px;margin-top:9px;max-width:88ch}
.pill{display:inline-block;font-size:11px;letter-spacing:.08em;text-transform:uppercase;
      color:var(--accent);border:1px solid rgba(47,212,167,.35);background:rgba(47,212,167,.07);
      padding:3px 9px;border-radius:20px;margin-top:12px}
.nav{display:flex;gap:10px;margin-top:22px;flex-wrap:wrap}
.nav a{color:var(--ink);text-decoration:none;font-size:13.5px;border:1px solid var(--line);
       padding:7px 14px;border-radius:8px;background:var(--panel)}
.nav a:hover{border-color:var(--accent);color:var(--accent)}
.bugs{background:#1a1114;border:1px solid #4a2530;border-radius:12px;padding:22px 24px;margin-top:16px}
.bugs h4{color:#ff8a9b;font-size:16px;font-weight:600}
.bugs li{color:var(--ink2);font-size:13.5px;margin:10px 0 0 20px}
.bugs code{background:#0d0f12;border:1px solid #333c45;border-radius:4px;
           padding:1px 6px;font-size:12.5px;color:#ffd9a0}
"""


def page(title: str, body: str) -> str:
    return f"""<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{html.escape(title)}</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
<style>{CSS}</style></head>
<body><div class="wrap">{body}</div></body></html>"""


def nav(current: str) -> str:
    links = [("index.html", "Shipped app"), ("designs.html", "Three designs"),
             ("compare.html", "Compare by state")]
    return '<div class="nav">' + "".join(
        f'<a href="{href}">{("▸ " if href == current else "")}{label}</a>'
        for href, label in links) + "</div>"


def fig(src: str, caption: str) -> str:
    return (f'<figure><img src="{src}" alt="{html.escape(caption)}" loading="lazy">'
            f'<figcaption>{caption}</figcaption></figure>')


def build_index() -> None:
    if not SHOTS.exists():
        return
    parts = [f"""<h1>OPD1 Tracker — interface capture</h1>
<p class="lead">Every screen of the shipped application, captured from the real
code path against a simulated local Riot client. Each state was verified before
capture — the engine reports its state, the capture asserts it, and only then
does it take the shot — so these are the interface as it genuinely renders,
including states that only appear once a match is found.</p>
<div class="meta">{len(list(SHOTS.glob('*.png')))} screenshots ·
1440×900 logical, captured at 2× device scale · EN and AR (right-to-left)</div>
{nav('index.html')}"""]

    for state in STATES:
        parts.append(f"<h2>{state.title()} state</h2>")
        parts.append('<div class="grid g5">')
        for view in VIEWS:
            p = SHOTS / f"app_{state}_{view}.png"
            if p.exists():
                parts.append(fig(f"../shots/{p.name}", f"<b>{state}</b> · {view} tab"))
        parts.append("</div>")

    parts.append("<h2>Player drawer</h2><div class='grid g3'>")
    p = SHOTS / "drawer_ingame_player_profile.png"
    if p.exists():
        parts.append(fig(f"../shots/{p.name}", "In-match · player profile drawer"))
    parts.append("</div>")

    parts.append("""<h2>Arabic, right-to-left</h2>
<p class="lead">The layout mirrors: the tab strip, the score line and the row
order all flip. Numerals stay Western because that is what the game itself
shows.</p><div class='grid g5'>""")
    for view in ["live", "performance", "encounters", "settings"]:
        p = SHOTS / f"arabic_ingame_{view}.png"
        if p.exists():
            parts.append(fig(f"../shots/{p.name}", f"<b>AR / RTL</b> · {view} tab"))
    p = SHOTS / "arabic_drawer_player_profile.png"
    if p.exists():
        parts.append(fig(f"../shots/{p.name}", "<b>AR / RTL</b> · player drawer"))
    parts.append("</div>")

    parts.append("""<h2>What exercising every state found</h2>
<div class="bugs">
<h4>Two defects the happy path hides</h4>
<ul>
<li><code>RiotLocalClient.__init__</code> leaves <code>self.puuid</code> empty and only
populates it inside <code>headers()</code>. The production path
(<code>MatchEngine.live_board</code>) reads presences before anything calls
<code>headers()</code>, so the self-presence never matches and the board can
resolve to <code>MENUS</code> even while the player is in a match. The existing
suite misses it because the fakes set <code>puuid</code> in
<code>__init__</code>.</li>
<li><code>queue_label("")</code> returns <code>"Custom"</code> and an empty map path
resolves to <code>"Unknown"</code>, so the lobby renders a queue and a map that do
not exist. Visible in the lobby captures above.</li>
</ul>
</div>""")

    (OUT / "index.html").write_text(
        page("OPD1 Tracker — interface capture", "".join(parts)), encoding="utf-8")


def build_designs() -> None:
    if not RENDERS.exists():
        return
    parts = ["""<h1>Three alternative interfaces</h1>
<p class="lead">The same application and the same data, rebuilt three ways. They
are not colour swaps: each answers a different question and accepts a different
cost. All three render live from a payload dumped out of the running tracker,
so agent portraits, rank icons, encounter counts and every figure are real
rather than placeholder.</p>
""" + nav('designs.html')]

    for variant, title, blurb in VARIANTS:
        parts.append(f"""<div class="vcard">
<h4>{title}</h4><p>{blurb}</p>
<span class="pill">{variant}</span></div>
<h3>States</h3><div class="grid g3">""")
        for state in STATES:
            p = RENDERS / f"{variant}__{state}.png"
            if p.exists():
                parts.append(fig(f"../designs/renders/{p.name}",
                                 f"<b>{title}</b> · {state}"))
        parts.append("</div>")

    parts.append("<h2>Arabic, right-to-left</h2><div class='grid g3'>")
    for variant, title, _ in VARIANTS:
        for state in ["ingame", "pregame"]:
            p = RENDERS / f"{variant}__{state}-ar.png"
            if p.exists():
                parts.append(fig(f"../designs/renders/{p.name}",
                                 f"<b>{title}</b> · {state} · AR/RTL"))
    parts.append("</div>")

    (OUT / "designs.html").write_text(
        page("Three alternative interfaces", "".join(parts)), encoding="utf-8")


def build_compare() -> None:
    if not RENDERS.exists():
        return
    parts = ["""<h1>Same state, three designs</h1>
<p class="lead">Read across a row to see how differently the same moment can be
treated. The in-match row is the clearest: A compresses, B dramatises, C
annotates.</p>
""" + nav('compare.html')]

    for state in ["ingame", "pregame", "lobby", "offline"]:
        parts.append(f"<h2>{state.title()}</h2><div class='grid g3'>")
        for variant, title, _ in VARIANTS:
            p = RENDERS / f"{variant}__{state}.png"
            if p.exists():
                parts.append(fig(f"../designs/renders/{p.name}", f"<b>{title}</b>"))
        parts.append("</div>")

    (OUT / "compare.html").write_text(
        page("Same state, three designs", "".join(parts)), encoding="utf-8")


def main() -> int:
    OUT.mkdir(exist_ok=True)
    build_index()
    build_designs()
    build_compare()
    for f in sorted(OUT.glob("*.html")):
        print(f"  {f.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
