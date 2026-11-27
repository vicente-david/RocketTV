// sample data only (from db/seed.sql) since backend endpoint doesnt exist
// (see api.js), dlete an entry from here once the real endpoint is live
const teams = [
  { team_id: 1, team_name: 'Gentle Mates', region_name: 'EU' },
  { team_id: 2, team_name: 'Karmine Corp', region_name: 'EU' },
  { team_id: 3, team_name: 'NRG', region_name: 'NA' },
  { team_id: 4, team_name: 'Shopify Rebellion', region_name: 'NA' },
  { team_id: 5, team_name: 'Team Falcons', region_name: 'MENA' },
  { team_id: 6, team_name: 'Twisted Minds', region_name: 'MENA' },
  { team_id: 7, team_name: 'Vitality', region_name: 'EU' },
  { team_id: 8, team_name: 'Team BDS', region_name: 'EU' },
]
const players = [
  [1, 'zen', 'Alex Bernier', 'France', 1], [2, 'Atow', 'Tristan Soyez', 'Belgium', 1], [3, 'Vatira', 'Axel Touret', 'France', 1],
  [4, 'MOnkey MOOn', 'Evan Rogez', 'France', 2], [5, 'bibbaba', 'Attila Eötvös', 'Hungary', 2], [6, 'reyyn', null, 'France', 2],
  [7, 'frosty', 'Kenneth Walz', 'United States', 3], [8, '2Piece', 'Jayden Horton', 'United States', 3], [9, 'Wahvey', 'Dylan Thanus', 'United States', 3],
  [10, 'Atomic', 'Massimo Franceschi', 'United States', 4], [11, 'Daniel', 'Daniel Piecenski', 'United States', 4],
  [12, 'Sample SR3', null, 'United States', 4],
  [13, 'Sample TF1', null, 'Saudi Arabia', 5], [14, 'Sample TF2', null, 'Saudi Arabia', 5], [15, 'Sample TF3', null, 'Jordan', 5],
  [16, 'Sample TM1', null, 'Saudi Arabia', 6], [17, 'Sample TM2', null, 'Egypt', 6], [18, 'Sample TM3', null, 'Kuwait', 6],
].map(([player_id, username, name, origin_country, team_id]) => ({ player_id, username, name, origin_country, team_id }))

const tournaments = [
  { tournament_id: 5, type: 'Major', season_id: 2025, split_num: 1, region_name: null, name: '2025 Split 1 Major', location: 'Birmingham, UK', start_date: '2025-03-27', end_date: '2025-03-30' },
  { tournament_id: 1, type: 'Worlds', season_id: 2025, split_num: null, region_name: null, name: '2025 Worlds', location: 'Lyon, France', start_date: '2025-09-10', end_date: '2025-09-14' },
  { tournament_id: 4, type: 'Open', season_id: 2025, split_num: 1, region_name: 'MENA', name: '2025 Split 1 MENA Open 3', location: null, start_date: '2025-01-07', end_date: '2025-01-16' },
  { tournament_id: 3, type: 'Open', season_id: 2025, split_num: 1, region_name: 'NA', name: '2025 Split 1 NA Open 2', location: null, start_date: '2025-01-05', end_date: '2025-01-14' },
  { tournament_id: 2, type: 'Open', season_id: 2025, split_num: 1, region_name: 'EU', name: '2025 Split 1 EU Open 1', location: null, start_date: '2025-01-03', end_date: '2025-01-12' },
].sort((a, b) => b.start_date.localeCompare(a.start_date))

// [tournament, team, seed, placement, points]
const standings = [
  [1, 1, 10, 8, 5], [1, 2, 1, 2, 20], [1, 3, 2, 1, 40],
  [2, 1, 3, 4, 10], [2, 2, 1, 1, 40], [3, 3, 1, 1, 40], [3, 4, 3, 7, 8],
  [4, 5, 1, 1, 40], [4, 6, 2, 2, 20], [5, 5, 1, 2, 20], [5, 3, 3, 1, 40], [5, 2, 2, 3, 15],
].map(([tournament_id, team_id, seed, placement, points]) => ({ tournament_id, team_id, seed, placement, points }))

const matches = [
  { tournament_id: 1, match_id: 1, team1_id: 3, team2_id: 2, team1_score: 4, team2_score: 2, best_of: 7, date: '2025-09-14',
    games: [[3, 2], [7, 5], [2, 4], [1, 0], [3, 4], [6, 5]] },
  { tournament_id: 2, match_id: 1, team1_id: 1, team2_id: 2, team1_score: 0, team2_score: 3, best_of: 5, date: '2025-01-10',
    games: [[1, 3], [0, 3], [2, 3]] },
]

const tname = (id) => teams.find((t) => t.team_id === id)?.team_name
const tour = (id) => tournaments.find((t) => t.tournament_id === id)
const rosterOf = (id) => players.filter((p) => p.team_id === id)
const rnd = (seed) => { const x = Math.sin(seed * 9301 + 49297) * 233280; return x - Math.floor(x) }

function playerStatsFor(m) {
  const rows = []
  for (const teamId of [m.team1_id, m.team2_id]) {
    for (const p of rosterOf(teamId)) {
      const g = m.games.length
      const k = p.player_id + m.match_id * 3 + m.tournament_id
      const goals = Math.round(g * (0.6 + rnd(k) * 1.2)), shots = goals + Math.round(g * (0.8 + rnd(k + 1) * 1.5))
      rows.push({ player_id: p.player_id, username: p.username, team_id: teamId, team_name: tname(teamId), games: g,
        goals, assists: Math.round(g * rnd(k + 2) * 1.2), saves: Math.round(g * (1 + rnd(k + 3) * 2)), shots,
        demos: Math.round(g * rnd(k + 4) * 1.5), score: Math.round(g * (350 + rnd(k + 5) * 300)), ot_goals: 0 })
    }
  }
  return rows
}

const matchSummary = (m) => ({
  tournament_id: m.tournament_id, tournament_name: tour(m.tournament_id)?.name, match_id: m.match_id,
  team1_id: m.team1_id, team1_name: tname(m.team1_id), team2_id: m.team2_id, team2_name: tname(m.team2_id),
  team1_score: m.team1_score, team2_score: m.team2_score, best_of: m.best_of, date: m.date,
})
const allMatches = matches.map(matchSummary).sort((a, b) => b.date.localeCompare(a.date))
const matchesOf = (id) => allMatches.filter((m) => m.team1_id === id || m.team2_id === id)

function totals(playerId) {
  const mine = matches.flatMap((m) => playerStatsFor(m).filter((s) => s.player_id === playerId).map((s) => ({ s, m })))
  const sum = (k) => mine.reduce((a, { s }) => a + s[k], 0)
  let wins = 0, losses = 0
  for (const { s, m } of mine) for (const [a, b] of m.games) {
    const mineScore = s.team_id === m.team1_id ? a : b, other = s.team_id === m.team1_id ? b : a
    if (mineScore > other) wins++; else if (mineScore < other) losses++
  }
  const shots = sum('shots')
  return { games: sum('games'), goals: sum('goals'), assists: sum('assists'), ot_goals: sum('ot_goals'), demos: sum('demos'),
    shooting_pct: shots ? Math.round((1000 * sum('goals')) / shots) / 10 : null, wins, losses, score: sum('score'), saves: sum('saves'), shots }
}

export const mock = {
  regions: () => ({ regions: ['NA', 'EU', 'MENA'] }),
  teams: () => ({ teams }),
  tournaments: () => ({ tournaments }),
  tournament: (id) => ({
    tournament: tour(id),
    standings: standings.filter((s) => s.tournament_id === id).map((s) => ({ ...s, team_name: tname(s.team_id), region_name: teams.find((t) => t.team_id === s.team_id).region_name }))
      .sort((a, b) => (a.placement ?? 99) - (b.placement ?? 99)),
    matches: allMatches.filter((m) => m.tournament_id === id),
  }),
  recentMatches: () => ({ matches: allMatches.slice(0, 5) }),
  match: (tid, mid) => {
    const m = matches.find((x) => x.tournament_id === tid && x.match_id === mid)
    return m && {
      match: matchSummary(m),
      games: m.games.map(([a, b], i) => ({ game_id: i + 1, date: m.date, team1_score: a, team2_score: b })),
      player_stats: playerStatsFor(m),
    }
  },
  team: (id) => {
    const team = teams.find((t) => t.team_id === id)
    if (!team) return null
    const ms = matchesOf(id)
    const won = (m) => (m.team1_id === id ? m.team1_score > m.team2_score : m.team2_score > m.team1_score)
    return {
      team, record: { match_wins: ms.filter(won).length, match_losses: ms.filter((m) => !won(m)).length },
      roster: rosterOf(id).map((p, i) => ({ ...p, role: i === 0 ? 'captain' : 'starter', start_date: '2024-08-01', end_date: null })),
      matches: ms,
    }
  },
  player: (id) => {
    const p = players.find((x) => x.player_id === id)
    if (!p) return null
    return { player: { ...p, date_of_birth: null }, totals: totals(id),
      teams: [{ team_id: p.team_id, team_name: tname(p.team_id), role: 'starter', start_date: '2024-08-01', end_date: null }] }
  },
  leaderboard: (stat, region) => ({
    stat, region,
    rows: players.filter((p) => region === 'ALL' || teams.find((t) => t.team_id === p.team_id).region_name === region)
      .map((p) => ({ player_id: p.player_id, username: p.username, team_name: tname(p.team_id), games: totals(p.player_id).games, value: totals(p.player_id)[stat === 'otgoals' ? 'ot_goals' : stat] ?? 0 }))
      .filter((r) => r.games > 0).sort((a, b) => b.value - a.value).slice(0, 25),
  }),
  headToHead: (a, b) => {
    const ms = allMatches.filter((m) => (m.team1_id === a && m.team2_id === b) || (m.team1_id === b && m.team2_id === a))
    const aWon = (m) => (m.team1_id === a ? m.team1_score > m.team2_score : m.team2_score > m.team1_score)
    return { team_a: teams.find((t) => t.team_id === a), team_b: teams.find((t) => t.team_id === b),
      a_wins: ms.filter(aWon).length, b_wins: ms.filter((m) => !aWon(m)).length, matches: ms }
  },
  search: (q) => {
    const s = q.toLowerCase()
    return { results: [
      ...teams.filter((t) => t.team_name.toLowerCase().includes(s)).map((t) => ({ kind: 'Team', id: t.team_id, name: t.team_name, detail: t.region_name })),
      ...players.filter((p) => p.username.toLowerCase().includes(s) || (p.name || '').toLowerCase().includes(s)).map((p) => ({ kind: 'Player', id: p.player_id, name: p.username, detail: p.origin_country })),
    ] }
  },
}
