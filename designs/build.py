"""Render the three design variants into standalone HTML with real app data.

Each variant is a .tpl with a `/*__DATA__*/` placeholder. The build injects the
real payload dumped from the running tracker, so every mockup shows schema-true
values: real agent UUIDs and artwork URLs, real rank tiers, real encounter
counts. Nothing is lorem ipsum.

Also produces an Arabic RTL render of each variant, because bilingual EN/AR with
right-to-left layout is a hard requirement of the original brief.

Usage: python3 build.py
"""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent
DATA = json.loads((ROOT / "data.json").read_text(encoding="utf-8"))

VARIANTS = {
    "A-sidecar": "Sidecar",
    "B-broadcast": "Broadcast",
    "C-dossier": "Dossier",
}

# Key strings per variant, translated. Only the labels each variant actually
# renders are listed; the app's own i18n catalogue is the source of truth for
# the product, this is just so the mockups read as Arabic rather than as an
# LTR layout with English text rotated.
"""Phrase map for the Arabic renders.

The mockups build their text in JavaScript at runtime (state labels come from
the payload, counts are interpolated), so translating the HTML source would
miss anything computed. Instead the Arabic render gets a small in-page pass
that walks the rendered text nodes. That is also why this map is phrase-based
rather than per-string: it matches whatever the variant actually printed.
"""
AR_PHRASES = {
    # shells
    "Sidecar": "الشريط الجانبي",
    "Broadcast": "البث",
    "Dossier": "الملف",
    "pre-match intelligence": "استخبارات ما قبل المباراة",
    # states
    "In Game": "داخل المباراة",
    "Agent Select": "اختيار الوكيل",
    "In Lobby": "في القائمة",
    "Offline": "غير متصل",
    "Live": "مباشر",
    "no client": "لا يوجد عميل",
    "in lobby": "في القائمة",
    "lobby": "القائمة",
    "VALORANT closed": "VALORANT مغلق",
    # teams and players
    "Your team": "فريقك",
    "YOUR TEAM": "فريقك",
    "Opponents": "الخصوم",
    "your team": "فريقك",
    "opponents": "الخصوم",
    "In your party": "في مجموعتك",
    "IN YOUR PARTY": "في مجموعتك",
    "of 5": "من 5",
    "Not yet revealed": "لم يُكشف بعد",
    "Hidden until lock-in": "مخفي حتى التثبيت",
    "Riot reveals the enemy team at lock-in": "Riot تكشف فريق الخصم عند التثبيت",
    "Riot withholds the enemy roster in agent select": "Riot تحجب تشكيلة الخصم في اختيار الوكيل",
    "avg": "المتوسط",
    "K/D": "قتل/موت",
    "flag": "مُعلَّم",
    "flagged": "مُعلَّم",
    "FLAG": "مُعلَّم",
    "FLAGGED": "مُعلَّم",
    "lvl": "مستوى",
    "RR": "RR",
    "Locked in": "تم التثبيت",
    "locked in": "مثبّت",
    # metrics
    "WIN CHANCE": "فرصة الفوز",
    "Win chance": "فرصة الفوز",
    "Players tracked": "لاعبون متتبعون",
    "Known history": "السجل المعروف",
    "met before": "التقيت بهم",
    "Matches logged": "مباريات مسجلة",
    "Refresh": "التحديث",
    "sec": "ث",
    "Avg rank": "متوسط الرتبة",
    "Team K/D": "قتل/موت الفريق",
    "Flagged": "مُعلَّم",
    "vs": "ضد",
    "Roster edge": "تفوق التشكيلة",
    "K/D edge": "تفوق قتل/موت",
    "Flagged accounts": "حسابات مُعلَّمة",
    "Prior encounters": "مواجهات سابقة",
    "avg tiers": "رتب متوسطة",
    "team avg": "متوسط الفريق",
    "smurf signals": "إشارات smurf",
    "of": "من",
    # table
    "Threat board": "لوحة الخطر",
    "sorted by estimated impact: rank, K/D, win rate and flag signals":
        "مرتبة حسب التأثير المتوقع: الرتبة، قتل/موت، نسبة الفوز، والإشارات",
    "Player": "اللاعب",
    "Lvl": "المستوى",
    "Rank": "الرتبة",
    "Peak": "الأعلى",
    "Games": "المباريات",
    "Win%": "الفوز٪",
    "Form": "الأداء",
    "Met": "التقيت",
    "Signals": "إشارات",
    "Recent record": "السجل الأخير",
    "History with you": "سجلك معه",
    "BLU": "أزرق",
    "RED": "أحمر",
    "Unranked": "غير مصنّف",
    # empty / waiting
    "Waiting for VALORANT": "بانتظار VALORANT",
    "No local Riot client detected": "لم يُعثر على عميل Riot المحلي",
    "Reading the local Riot client…": "جارٍ قراءة عميل Riot المحلي…",
    "The Riot client is not running.": "عميل Riot لا يعمل.",
    "Start the game and this board fills itself in. Nothing to configure.":
        "شغّل اللعبة وستمتلئ اللوحة تلقائيًا. لا شيء لإعداده.",
    "This dossier reads the game running on this machine. Start VALORANT and":
        "هذا الملف يقرأ اللعبة على هذا الجهاز. شغّل VALORANT",
    "the table rebuilds itself — no login, no account, nothing to configure.":
        "وستُبنى الجدول من جديد — بدون تسجيل دخول أو حساب أو أي إعداد.",
    "You are in the client. Queue up and this board turns into a live scoreboard.":
        "أنت في العميل. ابدأ الطابور وستتحول هذه اللوحة إلى لوحة نتائج مباشرة.",
    "Your party is stacked:": "مجموعتك مكتملة:",
    "The board goes live the moment a match is found.":
        "تصبح اللوحة مباشرة لحظة إيجاد مباراة.",
    "The enemy roster stays hidden through agent select. Lock in and the":
        "تبقى تشكيلة الخصم مخفية خلال اختيار الوكيل. ثبّت اختيارك",
    "live board takes over automatically.": "وستتولى اللوحة المباشرة الأمر تلقائيًا.",
    "Enemy identities are withheld through agent select; they appear":
        "هويات الخصوم محجوبة خلال اختيار الوكيل؛ وتظهر",
    "the moment the match goes live.": "لحظة بدء المباراة.",
    "The enemy roster stays hidden through agent select. Lock in and the live board takes over automatically.":
        "تبقى تشكيلة الخصم مخفية خلال اختيار الوكيل. ثبّت اختيارك وستتولى اللوحة المباشرة الأمر تلقائيًا.",
    # dossier notes
    "Reading the board": "قراءة اللوحة",
    "Method & caveats": "الطريقة والتحفظات",
    "Highest estimated impact:": "الأعلى تأثيرًا متوقعًا:",
    "These are heuristics": "هذه تقديرات",
    "from level, peak rank, K/D and win rate — treat them as a prompt to look, not a verdict.":
        "من المستوى وأعلى رتبة وقتل/موت ونسبة الفوز — خُذها كدعوة للتحقق لا كحكم.",
    "Figures come from the local Riot client on this machine. Odds and":
        "الأرقام من عميل Riot المحلي على هذا الجهاز. الاحتمالات",
    "flags are heuristics, not official Riot data.":
        "والإشارات تقديرات، وليست بيانات رسمية من Riot.",
    "Score at capture:": "النتيجة عند الالتقاط:",
    "Poll interval": "فاصل التحديث",
    "so the board stays current without hammering the client.":
        "لتبقى اللوحة محدثة دون إرهاق العميل.",
    "account": "حساب",
    "accounts": "حسابات",
    "tripped a smurf signal.": "أطلقت إشارة smurf.",
    "players appear in your": "لاعبون يظهرون في",
    "encounter history, so their figures come from matches you actually played.":
        "سجل مواجهاتك، لذا أرقامهم من مباريات لعبتها فعلًا.",
    "No comparative signals yet — the board fills in once":
        "لا توجد إشارات مقارنة بعد — تمتلئ اللوحة بعد",
    "rank and match history come back from the local client.":
        "رجوع الرتبة وسجل المباريات من العميل المحلي.",
    # footer
    "Demo data available": "البيانات التجريبية متاحة",
    "open Settings": "افتح الإعدادات",
    "known players in your history": "لاعبون معروفون في سجلك",
    "Encounters": "المواجهات",
    "OPD1 Tracker · dossier view": "متتبع OPD1 · عرض الملف",
    "source: Riot local client (lockfile)": "المصدر: عميل Riot المحلي (lockfile)",
    "players on board": "لاعبون على اللوحة",
    "local client": "عميل محلي",
    "Local only": "محلي فقط",
    "Client": "العميل",
    "Closed": "مغلق",
    "History on file": "السجل المحفوظ",
    "players": "لاعب",
    "player": "لاعب",
    "source": "المصدر",
}

AR_SCRIPT = """
<script>
/* Arabic render: translate the already-rendered DOM. Doing it here (rather than
   by rewriting the source) means interpolated values and state labels are
   covered too. Longest phrase first so partial words cannot pre-empt. */
(function(){
  const MAP = %s;
  const keys = Object.keys(MAP).sort((a,b) => b.length - a.length);
  document.documentElement.lang = "ar";
  document.documentElement.dir = "rtl";
  const walk = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
  const nodes = [];
  while (walk.nextNode()) nodes.push(walk.currentNode);
  for (const node of nodes) {
    let text = node.nodeValue;
    if (!text || !text.trim()) continue;
    for (const k of keys) {
      if (text.indexOf(k) !== -1) text = text.split(k).join(MAP[k]);
    }
    node.nodeValue = text;
  }
})();
</script>
"""


def arabicize(html: str, variant_title: str) -> str:
    """Inject the DOM translation pass that flips a render to Arabic RTL."""
    return html.replace(
        "</body>",
        AR_SCRIPT % json.dumps(AR_PHRASES, ensure_ascii=False) + "</body>",
        1,
    )


def render(variant: str, title: str, state: str, lang: str) -> str:
    tpl = (ROOT / variant / "index.html.tpl").read_text(encoding="utf-8")
    html = tpl.replace("/*__DATA__*/", json.dumps(DATA, ensure_ascii=False))
    # The state is baked in rather than passed as ?state=..., because these files
    # are opened straight off disk (file://) where a query string is awkward.
    html = html.replace("__STATE__", state)
    html = html.replace(
        "</style>",
        """
/* The mockup is a viewport, not a browser window: no horizontal scrollbar. */
html,body{overflow-x:hidden}
</style>""",
        1,
    )
    if lang == "ar":
        html = arabicize(html, title)
    return html


def main() -> int:
    states = ["ingame", "pregame", "lobby", "menus", "offline"]
    made = 0
    for variant, title in VARIANTS.items():
        for state in states:
            out = ROOT / variant / f"{state}.html"
            out.write_text(render(variant, title, state, "en"), encoding="utf-8")
            made += 1
        for state in ["ingame", "pregame"]:
            out = ROOT / variant / f"{state}-ar.html"
            out.write_text(render(variant, title, state, "ar"), encoding="utf-8")
            made += 1
    print(f"wrote {made} mockups")
    for variant in VARIANTS:
        files = sorted(p.name for p in (ROOT / variant).glob("*.html"))
        print(f"  {variant}: {', '.join(files)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
