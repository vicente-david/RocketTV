import { useState } from 'react'
import { Link } from 'react-router-dom'
import { api } from '../api.js'
import { useData } from '../hooks.js'
import { Chips, Loading, RegionBadge } from '../components/ui.jsx'

export default function Tournaments() {
  const [season, setSeason] = useState('ALL')
  const [type, setType] = useState('ALL')
  const { data, loading } = useData(() => api.tournaments(), [])
  if (loading) return <Loading />
  const all = data.tournaments
  const seasons = [...new Set(all.map((t) => t.season_id))].sort((a, b) => b - a).map(String)
  const shown = all.filter((t) => (season === 'ALL' || String(t.season_id) === season) && (type === 'ALL' || t.type === type))
  return (
    <>
      <h1>Tournaments</h1>
      <Chips options={['ALL', ...seasons]} value={season} onChange={setSeason} />
      <Chips options={['ALL', 'Worlds', 'Major', 'Open']} value={type} onChange={setType} />
      <div className="list">
        {shown.map((t) => (
          <Link key={t.tournament_id} to={`/tournaments/${t.tournament_id}`} className="card card-link tour">
            <span><b>{t.name}</b><br /><span className="muted">{t.start_date} → {t.end_date}{t.location ? ` · ${t.location}` : ''}</span></span>
            <span><span className="badge">{t.type}</span> <RegionBadge region={t.region_name} /></span>
          </Link>
        ))}
        {!shown.length && <p className="muted">No tournaments match these filters.</p>}
      </div>
    </>
  )
}
