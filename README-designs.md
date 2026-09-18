# OPD1 Tracker — interface captures and three alternative designs

This folder holds two separate bodies of work:

1. **`shots/`** — 31 screenshots of the *shipped* application, captured from the
   real code path, covering every page, every tab and every dynamic state.
2. **`designs/`** — three complete alternative interfaces for the same app,
   built from the same real data.

Open **`gallery/index.html`** to browse all of it. There are three gallery pages:
the shipped app, the three designs, and a state-by-state comparison.

---

## Part 1 — Captures of the shipped app

31 screenshots at `shots/`, captured with Playwright at 1440×900 logical
resolution and 2× device scale.

Coverage is by **state × view**, not by page alone:

| State | What it represents |
|---|---|
| `menus` | In the client, solo, nothing queued |
| `lobby` | In a party of five, match not yet found |
| `pregame` | Agent select: your team revealed, opponents withheld |
| `ingame` | Live match: both teams, score, live stats |
| `offline` | VALORANT not running |

Each state is captured across all five tabs — `live`, `performance`,
`encounters`, `saved`, `settings` — plus a player-profile drawer and five
Arabic right-to-left renders. That is the point the request was making: the
*page* does not change, but what it displays changes completely between "before
a match" and "in a match", and both needed capturing.

### How these were captured honestly

The real Riot client cannot run in this environment, so the local Riot API is
faked at the `jsonhttp` boundary — the same seam the project's own tests use.
That means the screenshots come from the **production** request path
(`/api/live` → `MatchEngine`), not from a hand-built mock of the interface.

Each capture is verified before the shutter: the engine reports its state, the
capture asserts that the rendered board actually matches that state (row counts,
score, map), and only then does it screenshot. A state that fails to settle
prints a warning instead of silently capturing the wrong screen. This matters —
an earlier run captured the lobby twice because a 20-second board cache had not
expired, and the assertion is what caught it.

---

## Part 2 — Three alternative designs

Each design is a different answer to a different question, not a recolouring.
They are in `designs/`, built by `designs/build.py` and rendered by
`designs/shoot.py`.

### A · Sidecar — `designs/A-sidecar/`

**A narrow 412px panel that sits beside the game.**

Thesis: the tracker should cost you nothing mid-round. One column, no tabs, no
scrolling in the common case. Density comes from removing columns rather than
shrinking text — every row is a 34px grid with six zones and nothing decorative.
The score is the only element allowed to be large.

- Best for: a second monitor, mid-match.
- Cost accepted: it cannot show match history or settings at all.

### B · Broadcast — `designs/B-broadcast/`

**A full-width scoreboard you could put on a stream or read across a room.**

Thesis: the tensest moment of the app is mid-match, and that moment deserves
scale. The two teams physically face each other across a central score column;
type is large enough to read at distance; aggregate stats sit in a strip
underneath.

- Best for: streaming, or a screen across the room.
- Cost accepted: far too much vertical space for a companion panel, and worse
  than C for pre-match analysis.

### C · Dossier — `designs/C-dossier/`

**A light, print-like intelligence sheet that sorts by threat.**

Thesis: before a match the real question is not "what is the score" but "who am
I actually playing against". This one is a dense, aligned table — every figure
the local API exposes on one line per player — ordered by estimated impact
(rank, K/D, win rate and flag signals combined) so the biggest threat is at the
top. Highest-risk rows are tinted; the self row is marked.

- Best for: the agent-select window, and studying opponents afterwards.
- Cost accepted: it is a study surface, not a glance surface.

### Why the three are genuinely different

| | A · Sidecar | B · Broadcast | C · Dossier |
|---|---|---|---|
| Width | 412px | 1180px | 1240px |
| Palette | dark, cool | dark, high-contrast | light, print |
| Primary axis | vertical list | team vs team | sorted table |
| Type scale | small, dense | large, dramatic | medium, data-first |
| Ordering | by team | by team | **by threat** |
| Signature element | hairline win-probability bar | central score theatre | verdict strip + form dots |
| Arabic | mirrored single column | mirrored theatre | mirrored table |

### Nothing is placeholder

Every design renders from `designs/data.json`, a real payload dumped out of the
running tracker. Agent portraits, rank icons, party colours, levels, K/D,
win rates, form streaks and encounter counts are the actual values the app
produced. Swap the payload and all three rebuild truthfully — which is also why
the designs double as a check on the data model: anything the UI wanted and the
API could not supply would have shown up immediately.

### Bilingual by construction

Each design ships English and Arabic right-to-left renders (`*-ar.html`). The
Arabic pass translates the **rendered DOM** rather than the source, because
these interfaces build their text at runtime — counts are interpolated and
state labels come from the payload, so translating the HTML would miss them.
All three mirror properly: the two-column layouts swap, the table flips, and
numerals stay Western because that is what VALORANT itself shows.

---

## Verification

Screenshots prove pixels were written; they do not prove the layout is sound.
`designs/qa.py` checks every render for the things a reviewer would:

- no horizontal overflow against the declared viewport
- no text clipped by an overflow box
- no broken images
- no meaningful type below 10px
- Arabic renders genuinely `dir="rtl"` and contain Arabic text

`python3 designs/qa.py` currently reports **all checks passed** across all 21
renders — five states plus two Arabic renders, for each of the three variants. It found three real faults during development that
screenshots alone hid: variant A was throwing a JavaScript error and rendering
nothing (a helper was referenced before it existed), the Arabic pass was only
partially translating, and variant C had 9px type.

---

## Reproducing

```bash
# 1. Captures of the shipped app (needs the harness serving the app)
cd /tmp/review/shot && python3 capture.py /tmp/review/shot/app

# 2. The three designs
cd designs && python3 build.py      # inject real data into the templates
python3 shoot.py                    # render every state to PNG
python3 qa.py                       # assert the layouts are sound

# 3. Galleries
cd ../gallery && python3 gallery.py
```

| Folder | Contents |
|---|---|
| `shots/` | 31 captures of the shipped app |
| `designs/data.json` | the real payload all three designs render from |
| `designs/<variant>/index.html.tpl` | one template per design |
| `designs/<variant>/*.html` | built mockups, EN and AR |
| `designs/renders/` | PNG renders of every mockup |
| `gallery/` | browsable galleries |
