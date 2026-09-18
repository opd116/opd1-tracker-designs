<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>OPD1 Broadcast — variant B</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+Arabic:wght@400;500;600;700&family=Archivo:wght@500;600;700;800&family=Inter:wght@400;500;600&display=swap">
<style>
/* ==========================================================================
   VARIANT B — "BROADCAST"
   Thesis: the tracker as a scoreboard you could put on a stream overlay or a
   TV across the room. Type is large, the score dominates, and the two teams
   face each other across a central versus axis. Optimised for the moment of
   maximum tension -- mid-match -- and for legibility at distance.
   Tradeoff accepted: far more vertical space than variant A, and it is a
   worse tool for pre-match analysis (that is variant C's job).
   ========================================================================== */

:root{
  --void:#05070a;
  --slate:#0c1015;
  --edge:#1b232b;
  --ink:#f2f6f8;
  --ink-2:#8b9aa6;
  --ink-3:#56646e;
  --ally:#38b6ff;
  --ally-deep:#0b4d75;
  --enemy:#ff4057;
  --enemy-deep:#6d1622;
  --gold:#ffc44d;
}

*{box-sizing:border-box;margin:0;padding:0}
body{
  background:radial-gradient(1200px 600px at 50% -10%, #121a22 0%, var(--void) 60%);
  min-height:100vh; display:flex; justify-content:center; align-items:flex-start;
  padding:26px 20px;
  font-family:"Inter","IBM Plex Sans Arabic",system-ui,sans-serif;
  color:var(--ink);
}
html[dir="rtl"] body{font-family:"IBM Plex Sans Arabic","Inter",system-ui,sans-serif}

.board{
  width:1180px; background:var(--slate);
  border:1px solid var(--edge); border-radius:18px; overflow:hidden;
  box-shadow:0 30px 90px rgba(0,0,0,.7);
}

/* ---- top rail ----------------------------------------------------------- */
.rail{
  display:flex; align-items:center; gap:14px;
  height:58px; padding:0 24px;
  background:linear-gradient(180deg,#111820,#0b1015);
  border-bottom:1px solid var(--edge);
}
.logo{
  font-family:"Archivo",sans-serif; font-weight:800; font-size:16px;
  letter-spacing:.16em; text-transform:uppercase;
}
.logo span{color:var(--ink-3)}
.rail-mid{display:flex;align-items:center;gap:10px;margin-inline-start:auto}
.pill{
  font-family:"Archivo",sans-serif; font-size:11px; font-weight:700;
  letter-spacing:.12em; text-transform:uppercase;
  padding:5px 11px; border-radius:4px;
  border:1px solid var(--edge); color:var(--ink-2);
}
.pill.live{
  color:#04150f; background:#2ee6a8; border-color:transparent;
  animation:breathe 2s ease-in-out infinite;
}
@keyframes breathe{50%{opacity:.62}}
.pill.live::before{content:"";display:inline-block;width:6px;height:6px;
  border-radius:50%;background:#04150f;margin-inline-end:6px;vertical-align:1px}

/* ---- the versus theatre ------------------------------------------------- */
.theatre{
  display:grid; grid-template-columns:1fr 300px 1fr;
  align-items:stretch; min-height:236px;
  border-bottom:1px solid var(--edge);
}
.side{
  padding:24px 26px; display:flex; flex-direction:column; gap:16px;
  position:relative;
}
.side.ally{background:linear-gradient(135deg,rgba(56,182,255,.13),transparent 62%)}
.side.enemy{background:linear-gradient(225deg,rgba(255,64,87,.13),transparent 62%)}
.side-tag{
  font-family:"Archivo",sans-serif; font-weight:800; font-size:13px;
  letter-spacing:.2em; text-transform:uppercase;
}
.side.ally .side-tag{color:var(--ally)}
.side.enemy .side-tag{color:var(--enemy)}
.side.enemy{align-items:flex-end; text-align:end}

.roster{display:flex; flex-direction:column; gap:9px; width:100%}
.slot{display:flex; align-items:center; gap:11px}
.side.enemy .slot{flex-direction:row-reverse}
.face{
  width:46px;height:46px;border-radius:10px;overflow:hidden;flex:none;
  background:#141c23;border:1px solid var(--edge);
  display:flex;align-items:center;justify-content:center;
}
.face img{width:100%;height:100%;object-fit:cover;transform:scale(1.55)}
.face.ghost{border-style:dashed;color:var(--ink-3);font-weight:700}
.meta{min-width:0;flex:1}
.name{
  font-family:"Archivo",sans-serif; font-size:16px; font-weight:700;
  letter-spacing:.005em; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
}
.name.self{color:var(--ally)}
.sub{display:flex;align-items:center;gap:7px;margin-top:2px;font-size:11.5px;color:var(--ink-3)}
.side.enemy .sub{justify-content:flex-end}
.rk{width:22px;height:22px}
.rk img{width:100%;height:100%;object-fit:contain}
.badge{
  font-family:"Archivo",sans-serif;font-weight:700;font-size:12px;
  padding:3px 8px;border-radius:4px;background:#141c23;
  border:1px solid var(--edge);color:var(--ink-2);
  font-variant-numeric:tabular-nums;
}
.badge.hot{color:var(--gold);border-color:#5d4a1c}
.badge.smurf{color:var(--gold);border-color:#5d4a1c}

/* centre column: the score */
.centre{
  border-inline:1px solid var(--edge);
  display:flex; flex-direction:column; align-items:center; justify-content:center;
  gap:8px; padding:22px 16px;
  background:linear-gradient(180deg,#0e141b,#0a0f14);
}
.map-name{
  font-family:"Archivo",sans-serif;font-size:12px;font-weight:700;
  letter-spacing:.19em;text-transform:uppercase;color:var(--ink-2);
}
.queue{font-size:11px;color:var(--ink-3);letter-spacing:.08em;text-transform:uppercase}
.big-score{
  display:flex; align-items:center; gap:16px;
  font-family:"Archivo",sans-serif; font-weight:800;
  font-size:74px; line-height:.92; letter-spacing:-.03em;
  font-variant-numeric:tabular-nums;
}
.big-score .a{color:var(--ally);text-shadow:0 0 40px rgba(56,182,255,.4)}
.big-score .b{color:var(--enemy);text-shadow:0 0 40px rgba(255,64,87,.4)}
.big-score .c{color:var(--ink-3);font-size:44px}
.vs{
  font-family:"Archivo",sans-serif;font-weight:700;font-size:12px;
  letter-spacing:.3em;color:var(--ink-3);text-transform:uppercase;
}
.clock{font-size:12px;color:var(--ink-3);font-variant-numeric:tabular-nums;
       letter-spacing:.06em}

/* win probability as the tension meter */
.tension{width:100%;margin-top:6px}
.tension-head{
  display:flex;justify-content:space-between;font-size:10px;
  letter-spacing:.14em;text-transform:uppercase;color:var(--ink-3);
  margin-bottom:6px;font-family:"Archivo",sans-serif;font-weight:700;
}
.tension-bar{
  height:6px;border-radius:3px;display:flex;overflow:hidden;background:var(--enemy-deep);
}
.tension-bar i{display:block;height:100%;background:linear-gradient(90deg,var(--ally-deep),var(--ally))}

/* ---- aggregate strip --------------------------------------------------- */
.aggs{display:grid;grid-template-columns:1fr 1fr 1fr 1fr;border-bottom:1px solid var(--edge)}
.agg{padding:15px 20px;border-inline-end:1px solid var(--edge)}
.agg:last-child{border-inline-end:0}
.agg .k{
  font-family:"Archivo",sans-serif;font-size:10px;font-weight:700;
  letter-spacing:.15em;text-transform:uppercase;color:var(--ink-3);
}
.agg .v{
  font-family:"Archivo",sans-serif;font-size:27px;font-weight:800;
  margin-top:5px;font-variant-numeric:tabular-nums;
}
.agg .v small{font-size:13px;color:var(--ink-3);font-weight:600;margin-inline-start:5px}

/* ---- pre-match / lobby band -------------------------------------------- */
.waiting{
  padding:52px 40px; text-align:center;
  display:flex;flex-direction:column;align-items:center;gap:12px;
}
.waiting .h{
  font-family:"Archivo",sans-serif;font-size:24px;font-weight:800;
  letter-spacing:.02em;
}
.waiting .p{font-size:13.5px;color:var(--ink-3);line-height:1.6;max-width:520px}

/* locked-in list for agent select */
.locked{display:flex;gap:12px;flex-wrap:wrap;justify-content:center;margin-top:6px}
.locked .l{
  display:flex;align-items:center;gap:9px;padding:9px 13px;
  background:#0f161d;border:1px solid var(--edge);border-radius:9px;
}
.locked .l img{width:32px;height:32px;border-radius:7px;object-fit:cover;
  transform:scale(1.5);background:#141c23}
.locked .l .n{font-family:"Archivo",sans-serif;font-weight:700;font-size:13px}
.locked .l .s{font-size:11px;color:var(--ink-3)}
.locked .l.pending{border-style:dashed}
</style>
</head>
<body>
<div class="board" id="board"></div>

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

/* rank tier -> the tier's tier name only (Ascendant, Immortal, ...) */
const rankFamily = t => rankName(t).replace(/ \d$/, "");

function slot(p){
  const r = p.rank || {};
  const icon = RANK_ICON(r.tier);
  return `
  <div class="slot">
    <span class="face">${p.agent && p.agent.portrait
      ? `<img src="${p.agent.portrait}" alt="">`
      : `<span>${esc((p.agent && p.agent.name || "?").slice(0,2))}</span>`}</span>
    <span class="meta">
      <span class="name ${p.isSelf ? "self" : ""}">${esc(p.name)}</span>
      <span class="sub">
        ${p.agent && p.agent.name ? `<span>${esc(p.agent.name)}</span>` : ""}
        ${icon ? `<span class="rk"><img src="${icon}" alt=""></span>` : ""}
        <span>${esc(rankName(r.tier))}</span>
        ${r.rr ? `<span>· ${r.rr} RR</span>` : ""}
        ${p.level ? `<span>· lvl ${p.level}</span>` : ""}
      </span>
    </span>
    ${p.smurf ? `<span class="badge smurf">▲ FLAG</span>` : ""}
    ${p.kd != null ? `<span class="badge ${p.kd >= 1.15 ? "hot" : ""}">${p.kd.toFixed(2)}</span>` : ""}
  </div>`;
}

function ghostSlot(){
  return `
  <div class="slot">
    <span class="face ghost">?</span>
    <span class="meta">
      <span class="name" style="color:var(--ink-3)">Not yet revealed</span>
      <span class="sub"><span>Riot reveals the enemy team at lock-in</span></span>
    </span>
  </div>`;
}

function centre(d){
  const isLive = d.state === "INGAME";
  const s = d.score;
  const wp = d.winProb || {};
  const mine = wp[d.selfTeam] ?? 50;

  let big;
  if (isLive && s){
    big = `<span class="a">${s.ally}</span><span class="c">:</span><span class="b">${s.enemy}</span>`;
  } else if (d.state === "PREGAME"){
    big = `<span class="c">VS</span>`;
  } else {
    big = `<span class="c">—</span>`;
  }

  return `
  <div class="centre">
    <div class="map-name">${esc(NOMATCH(d.state) ? (d.state === "OFFLINE" ? "no client" : "in lobby") : d.mapName)}</div>
    ${NOMATCH(d.state) ? "" : (d.queueLabel ? `<div class="queue">${esc(d.queueLabel)}</div>` : "")}
    <div class="big-score">${big}</div>
    <div class="clock">${new Date().toLocaleTimeString([], {hour:"2-digit",minute:"2-digit",second:"2-digit"})}</div>
    ${isLive && d.winProb ? `
      <div class="tension">
        <div class="tension-head"><span>${esc(rankFamily(d.teamStats?.[d.selfTeam]?.avgRankTier))} ${mine}%</span>
        <span>${100-mine}% ${esc(rankFamily(d.teamStats?.[Object.keys(d.teams||{}).find(t=>t!==d.selfTeam)]?.avgRankTier))}</span></div>
        <div class="tension-bar" style="direction:ltr"><i style="width:${mine}%"></i></div>
      </div>` : ""}
  </div>`;
}

function aggregate(d){
  const ts = d.teamStats || {};
  const mine = ts[d.selfTeam] || {};
  const foeKey = Object.keys(d.teams || {}).find(t => t !== d.selfTeam);
  const foe = ts[foeKey] || {};
  if (d.state !== "INGAME"){
    return `
    <div class="aggs">
      <div class="agg"><div class="k">Players tracked</div><div class="v">${(d.players||[]).length}</div></div>
      <div class="agg"><div class="k">Known history</div><div class="v">${(DATA.encounters.players||[]).length}<small>met before</small></div></div>
      <div class="agg"><div class="k">Matches logged</div><div class="v">${(DATA.performance.points||[]).length}</div></div>
      <div class="agg"><div class="k">Refresh</div><div class="v">${Math.round(d.pollInterval||0)}<small>sec</small></div></div>
    </div>`;
  }
  return `
  <div class="aggs">
    <div class="agg"><div class="k">Avg rank</div>
      <div class="v">${esc(rankFamily(mine.avgRankTier))}<small>vs ${esc(rankFamily(foe.avgRankTier))}</small></div></div>
    <div class="agg"><div class="k">Team K/D</div>
      <div class="v">${mine.avgKd != null ? mine.avgKd.toFixed(2) : "—"}<small>vs ${foe.avgKd != null ? foe.avgKd.toFixed(2) : "—"}</small></div></div>
    <div class="agg"><div class="k">Flagged</div>
      <div class="v">${mine.smurfs||0}<small>vs ${foe.smurfs||0}</small></div></div>
    <div class="agg"><div class="k">Refresh</div>
      <div class="v">${Math.round(d.pollInterval||0)}<small>sec</small></div></div>
  </div>`;
}

function body(d){
  if (d.state === "OFFLINE"){
    return `
    <div class="waiting">
      <div class="h">Waiting for VALORANT</div>
      <div class="p">${esc(d.notice || "The Riot client is not running.")}<br>
      Start the game and this board fills itself in. Nothing to configure.</div>
    </div>${aggregate(d)}`;
  }

  const selfTeam = d.selfTeam || "Blue";
  const allies = (d.teams && d.teams[selfTeam]) || [];
  const foeKey = Object.keys(d.teams || {}).find(t => t !== selfTeam);
  const foes = foeKey ? d.teams[foeKey] : [];

  if (d.state === "PREGAME"){
    const lockedIn = allies.filter(p => p.selection === "locked");
    return `
    <div class="winners">
      <div class="theatre" style="grid-template-columns:1fr 300px 1fr">
        <div class="side ally">
          <div class="side-tag">Your team</div>
          <div class="roster">${allies.map(slot).join("")}</div>
        </div>
        ${centre(d)}
        <div class="side enemy">
          <div class="side-tag">Opponents</div>
          <div class="roster">${[0,1,2,3,4].map(ghostSlot).join("")}</div>
        </div>
      </div>
      <div class="waiting" style="padding:26px 40px">
        <div class="h" style="font-size:17px">${lockedIn.length} of 5 locked in</div>
        <div class="p">The enemy roster stays hidden through agent select. Lock in and the
        live board takes over automatically.</div>
      </div>
    </div>${aggregate(d)}`;
  }

  if (d.state === "INGAME"){
    return `
    <div class="theatre">
      <div class="side ally">
        <div class="side-tag">${esc(selfTeam)} · your team</div>
        <div class="roster">${allies.map(slot).join("")}</div>
      </div>
      ${centre(d)}
      <div class="side enemy">
        <div class="side-tag">${esc(foeKey || "Red")} · opponents</div>
        <div class="roster">${foes.map(slot).join("")}</div>
      </div>
    </div>${aggregate(d)}`;
  }

  // MENUS
  return `
  <div class="waiting">
    <div class="h">In lobby</div>
    <div class="p">${(d.players||[]).length > 1
      ? `Your party is stacked: ${(d.players||[]).length} of 5. The board goes live the moment a match is found.`
      : "You are in the client. Queue up and this board turns into a live scoreboard."}</div>
    <div class="locked">
      ${(d.players||[]).map(p => `
        <div class="l ${p.pending ? "pending" : ""}">
          ${p.agent && p.agent.portrait ? `<img src="${p.agent.portrait}" alt="">` : ""}
          <span><span class="n">${esc(p.name)}</span><br>
          <span class="s">${esc(rankName((p.rank||{}).tier))}${p.level ? " · lvl " + p.level : ""}</span></span>
        </div>`).join("")}
    </div>
  </div>${aggregate(d)}`;
}

const isLive = d.state === "INGAME";
document.getElementById("board").innerHTML = `
  <div class="rail">
    <span class="logo">OPD1 <span>Broadcast</span></span>
    <span class="rail-mid">
      <span class="pill ${isLive ? "live" : ""}">${isLive ? "Live" : esc(d.stateLabel || "")}</span>
      <span class="pill">${esc(d.source === "local" ? "Local client" : d.source || "local")}</span>
      <span class="pill">${Math.round(d.pollInterval || 0)}s</span>
    </span>
  </div>
  ${body(d)}
`;
</script>
</body>
</html>
