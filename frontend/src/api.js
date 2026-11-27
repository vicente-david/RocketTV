// Data layer (see API_CONTRACT.md)
import { mock } from './mock.js'

let listeners = new Set()
let mockPaths = new Set()
export const onMockChange = (fn) => { listeners.add(fn); return () => listeners.delete(fn) }
export const getMockPaths = () => [...mockPaths]
const notify = () => listeners.forEach((fn) => fn([...mockPaths]))

async function get(path, fallback) {
  try {
    const res = await fetch(path)
    const isJson = (res.headers.get('content-type') || '').includes('json')
    if (res.ok && isJson) {
      if (mockPaths.delete(path)) notify()
      return await res.json()
    }
    if (res.status === 404 && isJson) return null // endpoint exists, row doesn't
  } catch { /* backend unreachable: fall through to sample data */ }
  if (!mockPaths.has(path)) { mockPaths.add(path); notify() }
  return fallback()
}

const q = encodeURIComponent
export const api = {
  teams: () => get('/api/team/', mock.teams),
  teamsByRegion: (region) => get(`/api/teams/region/${q(region)}/`, () => ({ teams: mock.teams().teams.filter((t) => t.region_name === region) })),
  // proposed placeholder (not built yet, see API_CONTRACT.md)
  regions: () => get('/api/regions/', mock.regions),
  tournaments: () => get('/api/tournaments/', mock.tournaments),
  tournament: (id) => get(`/api/tournaments/${id}/`, () => mock.tournament(+id)),
  recentMatches: () => get('/api/matches/recent/', mock.recentMatches),
  match: (tid, mid) => get(`/api/matches/${tid}/${mid}/`, () => mock.match(+tid, +mid)),
  team: (id) => get(`/api/teams/${id}/`, () => mock.team(+id)),
  player: (id) => get(`/api/players/${id}/`, () => mock.player(+id)),
  leaderboard: (stat, region) => get(`/api/leaderboard/${q(stat)}/${q(region)}/`, () => mock.leaderboard(stat, region)),
  headToHead: (a, b) => get(`/api/head-to-head/${a}/${b}/`, () => mock.headToHead(+a, +b)),
  search: (text) => get(`/api/search/?q=${q(text)}`, () => mock.search(text)),
}
