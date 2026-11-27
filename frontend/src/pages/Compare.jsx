import { useState } from 'react'
import { api } from '../api.js'
import { useData } from '../hooks.js'
import { Loading, MatchRow, StatGrid } from '../components/ui.jsx'

export default function Compare() {
  const teams = useData(() => api.teams(), [])
  const [a, setA] = useState('')
  const [b, setB] = useState('')
  const ready = a && b && a !== b
  const h2h = useData(() => (ready ? api.headToHead(a, b) : Promise.resolve(null)), [a, b])
  const list = teams.data?.teams ?? []
  const pick = (value, set, label) => (
    <label className="field">{label}
      <select value={value} onChange={(e) => set(e.target.value)}>
        <option value="">Choose a team…</option>
        {list.map((t) => <option key={t.team_id} value={t.team_id}>{t.team_name}</option>)}
      </select>
    </label>
  )
  return (
    <>
      <h1>Head to head</h1>
      <div className="pickers">{pick(a, setA, 'Team A')}<span className="vs">vs</span>{pick(b, setB, 'Team B')}</div>
      {a && a === b && <p className="muted">Pick two different teams.</p>}
      {ready && (h2h.loading ? <Loading /> : h2h.data && <>
        <StatGrid items={[[`${h2h.data.team_a.team_name} wins`, h2h.data.a_wins], [`${h2h.data.team_b.team_name} wins`, h2h.data.b_wins]]} />
        <h2>Meetings</h2>
        <div className="list">{h2h.data.matches.map((m) => <MatchRow key={`${m.tournament_id}-${m.match_id}`} m={m} />)}
          {!h2h.data.matches.length && <p className="muted">These teams have not met yet.</p>}</div>
      </>)}
    </>
  )
}
