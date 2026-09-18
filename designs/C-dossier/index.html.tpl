<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>OPD1 Dossier — variant C</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+Arabic:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&family=IBM+Plex+Sans:wght@400;500;600;700&display=swap">
<style>
/* ==========================================================================
   VARIANT C — "DOSSIER"
   Thesis: the question before a match is not "what is the score", it is "who
   am I actually playing against, and what do the numbers say". This variant
   answers that: one dense, aligned table, sorted so the threat is at the top,
   with every figure you can get from the local API on one line per player.
   Deliberately the opposite of variant A -- it is a study surface, not a
   glance surface, and it is the best of the three for the agent-select window.
   ========================================================================== */

:root{
  --paper:#f7f5f0;
  --paper-2:#efece5;
  --ink:#14181c;
  --ink-2:#5b666f;
  --ink-3:#8d979e;
  --rule:#dcd7cc;
  --rule-2:#e9e5dc;
  --ally:#0a5fd6;
  --enemy:#c8203c;
  --flag:#b26b00;
  --hot:#0a7a4a;
  --cold:#c8203c;
}

*{box-sizing:border-box;margin:0;padding:0}
body{
  background:#e6e2d9;
  font-family:"IBM Plex Sans","IBM Plex Sans Arabic",system-ui,sans-serif;
  color:var(--ink);
  display:flex;justify-content:center;align-items:flex-start;
  padding:26px 20px; min-height:100vh;
}
html[dir="rtl"] body{font-family:"IBM Plex Sans Arabic","IBM Plex Sans",system-ui,sans-serif}

.doc{
  width:1240px;background:var(--paper);
  border:1px solid #cfc9bb;
  box-shadow:0 18px 50px rgba(60,50,30,.18);
}

/* ---- masthead ----------------------------------------------------------- */
.mast{
  display:flex;align-items:flex-end;gap:20px;
  padding:20px 26px 15px;border-bottom:2px solid var(--ink);
}
.mast h1{
  font-size:21px;font-weight:700;letter-spacing:-.01em;line-height:1.1;
}
.mast h1 i{font-style:normal;font-weight:400;color:var(--ink-3);font-size:15px}
.mast .meta{
  margin-inline-start:auto;text-align:end;font-size:11.5px;color:var(--ink-3);
  font-family:"IBM Plex Mono",monospace;line-height:1.55;
}
.stamp{
  font-family:"IBM Plex Mono",monospace;font-size:10px;font-weight:600;
  letter-spacing:.1em;text-transform:uppercase;
  border:1px solid var(--ink);padding:4px 8px;
}
.stamp.live{background:var(--ink);color:var(--paper)}

/* ---- verdict block: the conclusion, stated up front -------------------- */
.verdict{
  display:grid;grid-template-columns:1fr 1fr 1fr 1fr;
  border-bottom:1px solid var(--rule);
}
.vd{padding:14px 26px;border-inline-end:1px solid var(--rule-2)}
.vd:last-child{border-inline-end:0}
.vd .k{
  font-family:"IBM Plex Mono",monospace;font-size:10px;font-weight:600;
  letter-spacing:.13em;text-transform:uppercase;color:var(--ink-3);
}
.vd .v{font-size:23px;font-weight:600;margin-top:4px;letter-spacing:-.015em}
.vd .v small{font-size:12px;color:var(--ink-3);font-weight:400;margin-inline-start:4px}
.vd .v.pos{color:var(--hot)} .vd .v.neg{color:var(--cold)}

/* ---- the table --------------------------------------------------------- */
.tbl-wrap{padding:0 0 6px}
caption, .cap{
  text-align:start;padding:15px 26px 9px;
  font-family:"IBM Plex Mono",monospace;font-size:10px;font-weight:600;
  letter-spacing:.13em;text-transform:uppercase;color:var(--ink-2);
}
.cap em{font-style:normal;color:var(--ink-3);font-weight:400;letter-spacing:.04em;
        text-transform:none;font-family:"IBM Plex Sans",sans-serif;font-size:11px}

table{width:100%;border-collapse:collapse}
thead th{
  font-family:"IBM Plex Mono",monospace;font-size:10px;font-weight:600;
  letter-spacing:.1em;text-transform:uppercase;color:var(--ink-3);
  text-align:end;padding:7px 10px;border-bottom:1px solid var(--ink);
  white-space:nowrap;
}
thead th.l{text-align:start}
thead th.grp{text-align:center;border-bottom:1px solid var(--rule);
             padding-bottom:3px;color:var(--ink-3)}
tbody td{
  padding:9px 10px;border-bottom:1px solid var(--rule-2);
  font-size:12.5px;text-align:end;
  font-variant-numeric:tabular-nums;
  white-space:nowrap;
}
tbody td.l{text-align:start}
tbody tr:hover{background:var(--paper-2)}
tbody tr.self{background:#eef4fd;box-shadow:inset 3px 0 0 var(--ally)}
tbody tr.threat{background:#fdf1f2;box-shadow:inset 3px 0 0 var(--enemy)}
tbody tr.sep td{border-bottom:1px solid var(--rule)}

.pcell{display:flex;align-items:center;gap:10px;min-width:0}
.pface{
  width:30px;height:30px;flex:none;border-radius:3px;overflow:hidden;
  background:#e2ddd2;border:1px solid var(--rule);
}
.pface img{width:100%;height:100%;object-fit:cover;transform:scale(1.55)}
.pface.ghost{border-style:dashed;display:flex;align-items:center;
             justify-content:center;color:var(--ink-3);font-size:11px}
.pname{font-weight:600;font-size:13px;overflow:hidden;text-overflow:ellipsis;
       white-space:nowrap;max-width:190px}
.ptag{font-size:10.5px;color:var(--ink-3);font-family:"IBM Plex Mono",monospace}
.pteam{
  font-family:"IBM Plex Mono",monospace;font-size:10px;font-weight:600;
  letter-spacing:.09em;padding:2px 5px;border:1px solid var(--rule);
}
.pteam.blue{color:var(--ally);border-color:#b9cfee}
.pteam.red{color:var(--enemy);border-color:#eec4ca}

.rkcell{display:flex;align-items:center;justify-content:flex-end;gap:6px}
.rkcell img{width:20px;height:20px;object-fit:contain}
.rkname{font-size:11px;color:var(--ink-2);font-weight:500}

/* inline form: five dots, the cheapest readable trend -------------------- */
.form{display:inline-flex;gap:3px;justify-content:flex-end}
.form i{width:7px;height:7px;border-radius:1px;display:block}
.form i.w{background:var(--hot)} .form i.l{background:var(--cold)}
.form i.d{background:var(--ink-3)}

/* enc: how often we have met --------------------------------------------- */
.enc{
  font-family:"IBM Plex Mono",monospace;font-size:10.5px;font-weight:600;
  padding:2px 6px;border-radius:2px;background:var(--paper-2);
  border:1px solid var(--rule);
}
.enc.foe{background:#fdeaed;border-color:#eec4ca;color:var(--enemy)}
.enc.friend{background:#e9f5ee;border-color:#b9ddc8;color:var(--hot)}

.kdcell{font-weight:600;font-size:13.5px}
.kdcell.hot{color:var(--hot)} .kdcell.cold{color:var(--cold)}
.muted{color:var(--ink-3)}
.flag{
  font-family:"IBM Plex Mono",monospace;font-size:10px;font-weight:600;
  letter-spacing:.08em;color:var(--flag);border:1px solid #e0c288;
  background:#fdf6e6;padding:2px 5px;white-space:nowrap;
}

/* ---- annotations: why the numbers say what they say -------------------- */
.notes{
  display:grid;grid-template-columns:1.35fr 1fr;gap:0;
  border-top:1px solid var(--rule);
}
.note{padding:16px 26px}
.note + .note{border-inline-start:1px solid var(--rule-2)}
.note h2{
  font-family:"IBM Plex Mono",monospace;font-size:10px;font-weight:600;
  letter-spacing:.13em;text-transform:uppercase;color:var(--ink-3);
  margin-bottom:9px;
}
.note li{
  list-style:none;font-size:12.5px;line-height:1.65;color:var(--ink-2);
  padding-inline-start:14px;position:relative;margin-bottom:5px;
}
.note li::before{
  content:"—";position:absolute;inset-inline-start:0;color:var(--ink-3);
}
.note li b{color:var(--ink);font-weight:600}
.note li .warntxt{color:var(--enemy);font-weight:600}

/* ---- empty state ------------------------------------------------------- */
.blank{padding:70px 40px;text-align:center}
.blank .h{font-size:19px;font-weight:600;margin-bottom:8px}
.blank .p{font-size:13px;color:var(--ink-3);line-height:1.65;max-width:560px;
          margin:0 auto}

/* ---- footer ------------------------------------------------------------ */
.foot{
  display:flex;gap:16px;align-items:center;
  padding:11px 26px;border-top:2px solid var(--ink);
  font-family:"IBM Plex Mono",monospace;font-size:10px;color:var(--ink-3);
  letter-spacing:.05em;
}
.foot .sp{margin-inline-start:auto}
</style>
</head>
<body>
<div class="doc" id="doc"></div>

<script>
const DATA = /*__DATA__*/;
const esc = s => String(s ?? "").replace(/[&<>"]/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;"}[c]));
const RANK_ICON = t => DATA.agents.rankIcons[String(t)] || "";
const NOMATCH = s => (s === "MENUS" || s === "OFFLINE");
const RANKS = ["Unranked","Iron 1","Iron 2","Iron 3","Bronze 1","Bronze 2","Bronze 3",
  "Silver 1","Silver 2","Silver 3","Gold 1","Gold 2","Gold 3","Plat 1","Plat 2","Plat 3",
  "Diamond 1","Diamond 2","Diamond 3","Asc 1","Asc 2","Asc 3","Immortal 1","Immortal 2",
  "Immortal 3","Radiant"];
const rankName = t => (t || t === 0) ? (RANKS[t] || "—") : "—";
const KEY = new URLSearchParams(location.search).get("state") || "__STATE__";
const d = DATA[KEY] || DATA.ingame;

const pct = v => v == null ? "—" : v + "%";
const num = (v, dp = 2) => v == null ? "—" : Number(v).toFixed(dp);
const rankOf = p => (p.rank || {}).tier;

/* The dossier sorts by threat, not by team: this is the whole point. */
function threatScore(p){
  const t = rankOf(p) || 0;
  const kd = p.kd || 1;
  const wr = (p.rank || {}).winRate || 50;
  return t * 1.0 + (kd - 1) * 22 + (wr - 50) * 0.35 + (p.smurf ? 9 : 0);
}

function encounterOf(p){
  const e = p.encounter;
  if (!e || !(e.games)) return null;
  const played = (e.withCount || 0) + (e.againstCount || 0);
  if (!played) return null;
  const foe = (e.againstCount || 0) >= (e.withCount || 0);
  return { played, foe };
}

function formDots(p){
  const f = p.form || [];
  if (!f.length) return `<span class="muted">—</span>`;
  return `<span class="form">` + f.map(x =>
    `<i class="${x === "win" ? "w" : x === "loss" ? "l" : "d"}"></i>`
  ).join("") + `</span>`;
}

function row(p){
  const r = p.rank || {};
  const icon = RANK_ICON(r.tier);
  const enc = encounterOf(p);
  const kd = p.kd;
  const kdCls = kd == null ? "" : kd >= 1.15 ? "hot" : kd < 0.95 ? "cold" : "";
  const isThreat = p.smurf || (kd != null && kd >= 1.35) || (rankOf(p) || 0) >= 22;
  const cls = [p.isSelf ? "self" : "", isThreat && !p.isSelf ? "threat" : ""].join(" ");

  return `
  <tr class="${cls}">
    <td class="l">
      <span class="pcell">
        <span class="pface">${p.agent && p.agent.portrait
          ? `<img src="${p.agent.portrait}" alt="">`
          : `<span>?</span>`}</span>
        <span>
          <span class="pname">${esc(p.name)}</span><br>
          <span class="ptag">${esc((p.agent && p.agent.name) || "—")}${
            p.party ? ` · P${p.party.number}` : ""}</span>
        </span>
        <span class="pteam ${p.team === "Blue" ? "blue" : "red"}">${esc(p.team === "Blue" ? "BLU" : "RED")}</span>
      </span>
    </td>
    <td>${p.level || "—"}</td>
    <td><span class="rkcell">${icon ? `<img src="${icon}" alt="">` : ""}
        <span class="rkname">${esc(rankName(rankOf(p)))}</span></span></td>
    <td>${r.rr != null ? r.rr : "—"}${r.peakTier && r.peakTier > (rankOf(p)||0)
        ? `<span class="muted"> ↑${esc(rankName(r.peakTier))}</span>` : ""}</td>
    <td class="kdcell ${kdCls}">${num(kd)}</td>
    <td>${r.games != null ? r.games : "—"}</td>
    <td>${r.winRate != null ? pct(r.winRate) : "—"}</td>
    <td>${formDots(p)}</td>
    <td>${enc ? `<span class="enc ${enc.foe ? "foe" : "friend"}">${enc.foe ? "vs" : "w/"} ${enc.played}×</span>`
              : `<span class="muted">—</span>`}</td>
    <td>${p.smurf ? `<span class="flag">▲ ${esc((p.smurfReasons || ["flagged"])[0]).slice(0,16)}</span>`
                  : `<span class="muted">—</span>`}</td>
  </tr>`;
}

function ghostRow(){
  return `
  <tr>
    <td class="l"><span class="pcell">
      <span class="pface ghost">?</span>
      <span><span class="pname muted">Hidden until lock-in</span><br>
      <span class="ptag">Riot withholds the enemy roster in agent select</span></span>
    </span></td>
    ${`<td class="muted">—</td>`.repeat(9)}
  </tr>`;
}

function table(d){
  if (d.state === "OFFLINE"){
    return `
    <div class="blank">
      <div class="h">No local Riot client detected</div>
      <div class="p">${esc(d.notice || "")}<br><br>
      This dossier reads the game running on this machine. Start VALORANT and
      the table rebuilds itself — no login, no account, nothing to configure.</div>
    </div>`;
  }

  const players = [...(d.players || [])];
  const isMatch = d.state === "INGAME";
  const selfTeam = d.selfTeam || "Blue";

  // Threat-first ordering: this is the design's core claim.
  players.sort((a, b) => {
    if (a.isSelf) return -1;
    if (b.isSelf) return 1;
    return threatScore(b) - threatScore(a);
  });

  const ghostCount = d.state === "PREGAME" ? 5 : 0;

  return `
  <div class="tbl-wrap">
    <div class="cap">Threat board
      <em>— sorted by estimated impact: rank, K/D, win rate and flag signals</em></div>
    <table>
      <thead>
        <tr class="grp">
          <th class="l" colspan="2"></th><th colspan="4">Rank</th>
          <th colspan="3">Recent record</th><th colspan="2">History with you</th>
        </tr>
        <tr>
          <th class="l">Player</th><th>Lvl</th><th>Rank</th><th>RR</th>
          <th>Peak</th><th>K/D</th><th>Games</th><th>Win%</th><th>Form</th>
          <th>Met</th><th>Signals</th>
        </tr>
      </thead>
      <tbody>
        ${players.map(row).join("")}
        ${Array.from({length: ghostCount}, ghostRow).join("")}
      </tbody>
    </table>
  </div>`;
}

function verdict(d){
  if (d.state === "OFFLINE"){
    return `<div class="verdict">
      <div class="vd"><div class="k">Client</div><div class="v neg">Closed</div></div>
      <div class="vd"><div class="k">Reading</div><div class="v">Local only</div></div>
      <div class="vd"><div class="k">History on file</div><div class="v">${(DATA.encounters.players||[]).length}<small>players</small></div></div>
      <div class="vd"><div class="k">Matches logged</div><div class="v">${(DATA.performance.points||[]).length}</div></div>
    </div>`;
  }

  const ts = d.teamStats || {};
  const mine = ts[d.selfTeam] || {};
  const foeKey = Object.keys(d.teams || {}).find(t => t !== d.selfTeam);
  const foe = ts[foeKey] || {};
  const flags = (d.players || []).filter(p => p.smurf).length;
  const kdEdge = (mine.avgKd != null && foe.avgKd != null)
    ? (mine.avgKd - foe.avgKd) : null;
  const rankEdge = (mine.avgRankTier != null && foe.avgRankTier != null)
    ? (mine.avgRankTier - foe.avgRankTier) : null;

  return `
  <div class="verdict">
    <div class="vd"><div class="k">Roster edge</div>
      <div class="v ${rankEdge > 0 ? "pos" : rankEdge < 0 ? "neg" : ""}">
        ${rankEdge == null ? "—" : (rankEdge > 0 ? "+" : "") + rankEdge}<small>avg tiers</small></div></div>
    <div class="vd"><div class="k">K/D edge</div>
      <div class="v ${kdEdge > 0 ? "pos" : kdEdge < 0 ? "neg" : ""}">
        ${kdEdge == null ? "—" : (kdEdge > 0 ? "+" : "") + kdEdge.toFixed(2)}<small>team avg</small></div></div>
    <div class="vd"><div class="k">Flagged accounts</div>
      <div class="v">${flags}<small>smurf signals</small></div></div>
    <div class="vd"><div class="k">Prior encounters</div>
      <div class="v">${(d.players||[]).filter(p => encounterOf(p)).length}
        <small>of ${(d.players||[]).length}</small></div></div>
  </div>`;
}

function notes(d){
  if (d.state === "OFFLINE") return "";
  const players = d.players || [];
  const flags = players.filter(p => p.smurf);
  const seen = players.filter(p => encounterOf(p));
  const top = [...players].filter(p => !p.isSelf)
    .sort((a, b) => threatScore(b) - threatScore(a))[0];

  const left = [];
  if (top) left.push(`Highest estimated impact: <b>${esc(top.name)}</b> —
    ${esc(rankName(rankOf(top)))}${top.kd != null ? `, ${num(top.kd)} K/D` : ""}${
      top.rank && top.rank.winRate != null ? `, ${top.rank.winRate}% win rate` : ""}.`);
  if (flags.length) left.push(`<span class="warntxt">${flags.length} account${
    flags.length > 1 ? "s" : ""} tripped a smurf signal.</span> These are heuristics
    from level, peak rank, K/D and win rate — treat them as a prompt to look, not a verdict.`);
  if (seen.length) left.push(`${seen.length} of ${players.length} players appear in your
    encounter history, so their figures come from matches you actually played.`);
  if (!left.length) left.push(`No comparative signals yet — the board fills in once
    rank and match history come back from the local client.`);

  const right = [];
  if (d.state === "PREGAME")
    right.push(`Enemy identities are withheld through agent select; they appear
      the moment the match goes live.`);
  right.push(`Figures come from the local Riot client on this machine. Odds and
    flags are heuristics, not official Riot data.`);
  if (d.score) right.push(`Score at capture: ${d.score.ally}–${d.score.enemy}.`);
  right.push(`Poll interval ${Math.round(d.pollInterval || 0)}s in this state,
    so the board stays current without hammering the client.`);

  return `
  <div class="notes">
    <div class="note"><h2>Reading the board</h2><ul>
      ${left.map(t => `<li>${t}</li>`).join("")}</ul></div>
    <div class="note"><h2>Method &amp; caveats</h2><ul>
      ${right.map(t => `<li>${t}</li>`).join("")}</ul></div>
  </div>`;
}

const isLive = d.state === "INGAME";
document.getElementById("doc").innerHTML = `
  <div class="mast">
    <h1>OPD1 Dossier<br><i>pre-match intelligence</i></h1>
    <div class="meta">
      ${esc(NOMATCH(d.state) ? (d.state === "OFFLINE" ? "no client" : "in lobby") : d.mapName)}
      ${NOMATCH(d.state) ? "" : (d.queueLabel ? ` · ${esc(d.queueLabel)}` : "")}<br>
      ${new Date().toLocaleString([], {dateStyle:"medium", timeStyle:"short"})}
      &nbsp;·&nbsp; local client, region na
    </div>
    <div class="stamp ${isLive ? "live" : ""}">${isLive ? "In match" : esc(d.stateLabel || "")}</div>
  </div>
  ${verdict(d)}
  ${table(d)}
  ${notes(d)}
  <div class="foot">
    <span>OPD1 Tracker · dossier view</span>
    <span>source: Riot local client (lockfile)</span>
    <span class="sp">${(d.players||[]).length} players on board</span>
  </div>
`;
</script>
</body>
</html>
