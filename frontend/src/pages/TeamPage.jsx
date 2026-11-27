import { Link, useParams } from 'react-router-dom'
import { api } from '../api.js'
import { useData } from '../hooks.js'
import { Loading, MatchRow, NotFound, RegionBadge, StatGrid } from '../components/ui.jsx'

export default function TeamPage() {
  const { id } = useParams()
  const { data, loading } = useData(() => api.team(id), [id])
  if (loading) return <Loading />
  if (!data) return <NotFound what="team" />
  const { team, record, roster, matches } = data
  const current = roster.filter((p) => !p.end_date)
  const former = roster.filter((p) => p.end_date)
  return (
    <>
      <h1>{team.team_name} <RegionBadge region={team.region_name} /></h1>
      <StatGrid items={[['Series won', record.match_wins], ['Series lost', record.match_losses]]} />
      <h2>Current roster</h2>
      <div className="list">
        {current.map((p) => (
          <Link key={`${p.player_id}-${p.start_date}`} to={`/players/${p.player_id}`} className="row card-link">
            <b>{p.username}</b><span className="muted">{p.role} · {p.origin_country}</span>
          </Link>
        ))}
      </div>
      {!!former.length && <>
        <h2>Former players</h2>
        <div className="list">
          {former.map((p) => (
            <Link key={`${p.player_id}-${p.start_date}`} to={`/players/${p.player_id}`} className="row card-link">
              <b>{p.username}</b><span className="muted">{p.start_date} → {p.end_date}</span>
            </Link>
          ))}
        </div>
      </>}
      <h2>Results</h2>
      <div className="list">{matches.map((m) => <MatchRow key={`${m.tournament_id}-${m.match_id}`} m={m} />)}
        {!matches.length && <p className="muted">No matches played yet.</p>}</div>
    </>
  )
}
