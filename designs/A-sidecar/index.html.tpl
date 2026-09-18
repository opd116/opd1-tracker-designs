<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>OPD1 Sidecar — variant A</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+Arabic:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap">
<style>
/* ==========================================================================
   VARIANT A — "SIDECAR"
   Thesis: the tracker lives beside the game, not in front of it. Everything
   you need for one glance fits in a narrow column with zero chrome, zero
   tabs, and zero scrolling in the common case. Density comes from removing
   columns, never from shrinking type below 11px.
   ========================================================================== */

:root{
  --bg:#0f1418; --bg-2:#141b20; --line:#222d34; --line-soft:#1a2329;
  --ink:#e7eef2; --ink-2:#93a4ae; --ink-3:#61727c;
  --accent:#2fd4a7; --accent-dim:#1d6b58;
  --ally:#4aa8ff; --enemy:#ff5c6c;
  --warn:#ffb34d;
  --r:7px;
}

*{box-sizing:border-box;margin:0;padding:0}
html,body{height:100%}
body{
  background:#070a0c;
  font-family:"Inter","IBM Plex Sans Arabic",system-ui,sans-serif;
  color:var(--ink);
  display:flex; justify-content:center; align-items:flex-start;
  padding:22px;
}
html[dir="rtl"] body{font-family:"IBM Plex Sans Arabic","Inter",system-ui,sans-serif}

.panel{
  width:412px; min-height:830px;
  background:var(--bg);
  border:1px solid var(--line);
  border-radius:14px;
  overflow:hidden;
  display:flex; flex-direction:column;
  box-shadow:0 24px 60px rgba(0,0,0,.55);
}

/* ---- header: identity + liveness, one line, 46px ------------------------ */
.hd{
  height:46px; flex:none; display:flex; align-items:center; gap:9px;
  padding:0 13px; border-bottom:1px solid var(--line);
  background:var(--bg-2);
}
.brand{font-size:12.5px; font-weight:600; letter-spacing:.02em}
.brand i{font-style:normal; color:var(--ink-3); font-weight:500}
.live{
  margin-inline-start:auto; display:flex; align-items:center; gap:6px;
  font-size:11px; color:var(--ink-2); font-variant-numeric:tabular-nums;
}
.dot{width:6px;height:6px;border-radius:50%;background:var(--accent);
     box-shadow:0 0 0 3px rgba(47,212,167,.15)}
.dot[data-s="offline"]{background:var(--ink-3);box-shadow:none}
.dot[data-s="select"]{background:var(--warn);box-shadow:0 0 0 3px rgba(255,179,77,.15)}
.dot[data-s="live"]{animation:pulse 1.9s ease-in-out infinite}
@keyframes pulse{50%{box-shadow:0 0 0 6px rgba(47,212,167,0)}}

/* ---- score hero: the one thing worth real size -------------------------- */
.hero{
  flex:none; padding:15px 13px 13px;
  border-bottom:1px solid var(--line);
  background:linear-gradient(180deg,var(--bg-2),var(--bg));
}
.hero-top{display:flex;align-items:baseline;gap:8px;margin-bottom:9px}
.map{font-size:13px;font-weight:600}
.queue{
  font-size:10px;color:var(--ink-3);border:1px solid var(--line);
  padding:1px 6px;border-radius:20px;
}
.clock{margin-inline-start:auto;font-size:10.5px;color:var(--ink-3);
       font-variant-numeric:tabular-nums}
.score{display:flex;align-items:center;gap:14px}
.sn{font-size:44px;font-weight:700;line-height:1;letter-spacing:-.02em;
    font-variant-numeric:tabular-nums}
.sn.ally{color:var(--ally)} .sn.enemy{color:var(--enemy)}
.sn.dim{color:var(--ink-3);font-size:34px}
.sdivide{width:1px;height:34px;background:var(--line)}

/* win probability: a hairline, not a chart -------------------------------- */
.wp{margin-top:12px}
.wp-head{display:flex;justify-content:space-between;font-size:10px;
         color:var(--ink-3);margin-bottom:5px;letter-spacing:.03em}
.wp-bar{height:3px;border-radius:2px;background:var(--enemy);overflow:hidden}
.wp-bar span{display:block;height:100%;background:var(--ally)}

/* ---- team blocks: the core of the design -------------------------------- */
.teams{flex:1;padding:4px 0}
.team + .team{border-top:1px solid var(--line-soft);margin-top:4px}
.team-hd{
  display:flex;align-items:center;gap:7px;padding:9px 13px 5px;
  font-size:10px;letter-spacing:.07em;text-transform:uppercase;
  color:var(--ink-3);
}
.team-hd b{color:var(--ink-2);font-weight:600}
.tagg{
  margin-inline-start:auto;display:flex;gap:9px;font-size:10px;
  color:var(--ink-3);text-transform:none;letter-spacing:0;
  font-variant-numeric:tabular-nums;
}
.flag{color:var(--warn)}

/* a player row: 34px tall, six zones, no wasted pixel --------------------- */
.row{
  display:grid;
  grid-template-columns:26px 1fr auto auto auto;
  align-items:center;gap:9px;
  height:34px;padding:0 13px;
  position:relative;
}
.row:hover{background:var(--bg-2)}
.row.self{background:rgba(74,168,255,.07)}
.row.self::before{
  content:"";position:absolute;inset-inline-start:0;top:6px;bottom:6px;
  width:2px;background:var(--ally);border-radius:0 2px 2px 0;
}
.ag{
  width:26px;height:26px;border-radius:50%;overflow:hidden;flex:none;
  background:#1b2429;display:flex;align-items:center;justify-content:center;
}
.ag img{width:100%;height:100%;object-fit:cover;transform:scale(1.5) translateY(3%)}
.ag.ghost{border:1px dashed var(--line);color:var(--ink-3);font-size:11px;
          font-weight:600;background:none}
.who{min-width:0;display:flex;align-items:center;gap:5px}
.nm{font-size:12px;font-weight:500;white-space:nowrap;overflow:hidden;
    text-overflow:ellipsis}
.pdot{width:5px;height:5px;border-radius:50%;flex:none}
.rk{width:20px;height:20px;flex:none}
.rk img{width:100%;height:100%;object-fit:contain;display:block}
.lv{font-size:10px;color:var(--ink-3);min-width:22px;text-align:end;
    font-variant-numeric:tabular-nums}
.kd{font-size:11.5px;font-weight:600;min-width:30px;text-align:end;
    font-variant-numeric:tabular-nums;color:var(--ink-2)}
.kd[data-st="hot"]{color:var(--accent)}
.kd[data-st="cold"]{color:var(--enemy)}
.pend{font-size:10px;color:var(--ink-3);font-style:italic}

/* empty / offline: quiet, not shouty -------------------------------------- */
.quiet{
  flex:1;display:flex;flex-direction:column;align-items:center;
  justify-content:center;gap:8px;padding:36px 30px;text-align:center;
}
.quiet .t{font-size:13px;font-weight:600}
.quiet .s{font-size:11.5px;color:var(--ink-3);line-height:1.55}

/* ---- footer: one actionable line --------------------------------------- */
.ft{
  flex:none;height:34px;display:flex;align-items:center;gap:8px;
  padding:0 13px;border-top:1px solid var(--line);
  background:var(--bg-2);font-size:10.5px;color:var(--ink-3);
}
.ft b{color:var(--ink-2);font-weight:600}
.caret{margin-inline-start:auto;color:var(--ink-3)}
</style>
</head>
<body>
<div class="panel" id="panel"></div>

<script>
const DATA = /*__DATA__*/;

/* ---- tiny helpers ------------------------------------------------------- */
const NOMATCH = s => (s === "MENUS" || s === "OFFLINE");
const esc = s => String(s ?? "").replace(/[&<>"]/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;"}[c]));
const RANK_ICON = t => (DATA.agents.rankIcons[String(t)] || "");
const AGENT = id => DATA.agents.agents.find(a => a.uuid === id) || {};
const stateOf = k => DATA[k] || DATA.menus;

function kdClass(kd){
  if (kd == null) return "";
  if (kd >= 1.15) return "hot";
  if (kd < 0.95) return "cold";
  return "";
}

/* ---- pieces ------------------------------------------------------------- */

function scoreHero(d){
  const isMatch = d.state === "INGAME" || d.state === "PREGAME";
  const isLive  = d.state === "INGAME";
  const wp = d.winProb || {};
  const mine = wp[d.selfTeam] ?? wp.Blue ?? 50;

  let scoreBlock;
  if (isLive && d.score){
    scoreBlock = `
      <div class="score">
        <span class="sn ally">${d.score.ally}</span>
        <span class="sdivide"></span>
        <span class="sn enemy">${d.score.enemy}</span>
      </div>`;
  } else if (isMatch){
    scoreBlock = `
      <div class="score">
        <span class="sn dim">—</span>
        <span class="sdivide"></span>
        <span class="sn dim">—</span>
      </div>`;
  } else {
    scoreBlock = `<div class="score"><span class="sn dim">${d.state === "OFFLINE" ? "—" : "1×5"}</span></div>`;
  }

  const title = d.state === "OFFLINE" ? "VALORANT closed"
              : isLive ? (d.mapName || "Live match")
              : d.state === "PREGAME" ? (d.mapName || "Agent select")
              : "In lobby";
  // The engine fills mapName/queueLabel with "Unknown"/"Custom" when there is
  // no match, which would render as a real map and queue. Suppress both.
  const queue = NOMATCH(d.state) ? "" : d.queueLabel;

  const clock = new Date().toLocaleTimeString([], {hour:"2-digit", minute:"2-digit"});

  return `
  <div class="hero">
    <div class="hero-top">
      <span class="map">${esc(title)}</span>
      ${queue ? `<span class="queue">${esc(queue)}</span>` : ""}
      <span class="clock">${clock}</span>
    </div>
    ${scoreBlock}
    ${isMatch && d.winProb ? `
    <div class="wp">
      <div class="wp-head"><span>WIN CHANCE</span><span>${mine}% · ${100 - mine}%</span></div>
      <div class="wp-bar" style="direction:ltr"><span style="width:${mine}%"></span></div>
    </div>` : ""}
  </div>`;
}

function playerRow(p, opts = {}){
  const rank = p.rank || {};
  const icon = RANK_ICON(rank.tier);
  const party = p.party
    ? `<i class="pdot" style="background:${p.party.color}" title="Party ${p.party.number}"></i>` : "";
  const kd = p.kd == null ? (p.pending ? `<span class="pend">…</span>`
                                      : `<span class="kd">—</span>`)
                          : `<span class="kd" data-st="${kdClass(p.kd)}">${p.kd.toFixed(2)}</span>`;
  return `
  <div class="row ${p.isSelf ? "self" : ""}">
    <span class="ag">${p.agent && p.agent.portrait
        ? `<img src="${p.agent.portrait}" alt="">`
        : `<span>${esc((p.agent && p.agent.name || "?").slice(0,2))}</span>`}</span>
    <span class="who">
      <span class="nm">${esc(p.name)}</span>${party}
      ${p.smurf ? `<span class="flag" title="Smurf signals">▲</span>` : ""}
    </span>
    ${icon ? `<span class="rk"><img src="${icon}" alt="${rank.tier}"></span>` : `<span class="rk"></span>`}
    <span class="lv">${p.level ? "lvl " + p.level : ""}</span>
    ${kd}
  </div>`;
}

function teamBlock(players, title, sub){
  return `
  <section class="team">
    <div class="team-hd"><b>${title}</b><span class="tagg">${sub}</span></div>
    ${players.map(p => playerRow(p)).join("")}
  </section>`;
}

function ghostTeam(n, title){
  const rows = Array.from({length:n}, () => `
    <div class="row">
      <span class="ag ghost">?</span>
      <span class="who"><span class="nm" style="color:var(--ink-3)">Hidden until lock-in</span></span>
      <span class="rk"></span><span class="lv"></span><span class="kd">—</span>
    </div>`).join("");
  return `<section class="team"><div class="team-hd"><b>${title}</b></div>${rows}</section>`;
}

function teams(d){
  if (d.state === "OFFLINE"){
    return `
    <div class="quiet">
      <div class="t">Reading the local Riot client…</div>
      <div class="s">${esc(d.notice || "VALORANT is not running.")}<br>The board fills in the moment you open the game.</div>
    </div>`;
  }

  const ts = d.teamStats || {};
  const allies = (d.teams && d.teams[d.selfTeam]) || (d.players || []).filter(p => p.team === "Blue");
  const others = Object.keys(d.teams || {}).filter(t => t !== d.selfTeam);
  const foes = others.length ? d.teams[others[0]] : [];

  if (d.state === "PREGAME"){
    return teamBlock(allies, "Your team",
             `<span>avg ${rankName(ts[d.selfTeam])}</span>`) + ghostTeam(5, "Opponents");
  }
  if (d.state === "INGAME"){
    let html = teamBlock(allies, "Your team",
      `<span>avg ${rankName(ts[d.selfTeam])}</span>
       <span>K/D ${fmt(ts[d.selfTeam] && ts[d.selfTeam].avgKd)}</span>
       ${ts[d.selfTeam] && ts[d.selfTeam].smurfs ? `<span class="flag">${ts[d.selfTeam].smurfs} flagged</span>` : ""}`);
    if (foes.length){
      html += teamBlock(foes, "Opponents",
        `<span>avg ${rankName(ts[others[0]])}</span>
         <span>K/D ${fmt(ts[others[0]] && ts[others[0]].avgKd)}</span>
         ${ts[others[0]] && ts[others[0]].smurfs ? `<span class="flag">${ts[others[0]].smurfs} flagged</span>` : ""}`);
    }
    return html;
  }
  // MENUS: a party read
  return teamBlock(allies, "In your party",
    `<span>${allies.length} of 5</span>`);
}

const rankName = t => !t && t !== 0 ? "—"
  : ["Unranked","Iron 1","Iron 2","Iron 3","Bronze 1","Bronze 2","Bronze 3",
     "Silver 1","Silver 2","Silver 3","Gold 1","Gold 2","Gold 3",
     "Plat 1","Plat 2","Plat 3","Diamond 1","Diamond 2","Diamond 3",
     "Asc 1","Asc 2","Asc 3","Immortal 1","Immortal 2","Immortal 3",
     "Radiant"][t] || "—";
const fmt = v => v == null ? "—" : Number(v).toFixed(2);

function footer(d){
  if (d.state === "OFFLINE")
    return `<div class="ft"><span>Demo data available</span><span class="caret">open Settings →</span></div>`;
  const known = (DATA.encounters.players || []).length;
  return `
  <div class="ft">
    <span><b>${known}</b> known players in your history</span>
    <span class="caret">Encounters ›</span>
  </div>`;
}

/* ---- state routing ------------------------------------------------------ */
const params = new URLSearchParams(location.search);
const KEY = params.get("state") || "__STATE__";
const d = stateOf(KEY);

document.getElementById("panel").innerHTML = `
  <div class="hd">
    <span class="dot" data-s="${d.state === "OFFLINE" ? "offline" : d.state === "PREGAME" ? "select" : d.state === "INGAME" ? "live" : "idle"}"></span>
    <span class="brand">OPD1 <i>Sidecar</i></span>
    <span class="live">${esc(d.stateLabel || "")} · ${Math.round(d.pollInterval || 0)}s</span>
  </div>
  ${scoreHero(d)}
  <div class="teams">${teams(d)}</div>
  ${footer(d)}
`;
</script>
</body>
</html>
