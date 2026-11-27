import { Link, useParams } from 'react-router-dom'
import { api } from '../api.js'
import { useData } from '../hooks.js'
import { Loading, NotFound, StatGrid } from '../components/ui.jsx'

export default function PlayerPage() {
  const { id } = useParams()
  const { data, loading } = useData(() => api.player(id), [id])
  if (loading) return <Loading />
  if (!data) return <NotFound what="player" />
  const { player: p, totals: t, teams } = data
  return (
    <>
      <h1>{p.username}</h1>
      <p className="muted">{[p.name, p.origin_country].filter(Boolean).join(' · ')}</p>
      <h2>Career totals</h2>
      <StatGrid items={[
        ['Games', t.games], ['Goals', t.goals], ['Assists', t.assists], ['OT goals', t.ot_goals], ['Demos', t.demos],
        ['Shooting %', t.shooting_pct == null ? null : `${t.shooting_pct}%`], ['W / L', `${t.wins} / ${t.losses}`],
        ['Score', t.score], ['Saves', t.saves], ['Shots', t.shots],
      ]} />
      <h2>Team history</h2>
      <div className="list">
        {teams.map((tm) => (
          <Link key={`${tm.team_id}-${tm.start_date}`} to={`/teams/${tm.team_id}`} className="row card-link">
            <b>{tm.team_name}</b><span className="muted">{tm.role} · {tm.start_date} → {tm.end_date ?? 'present'}</span>
          </Link>
        ))}
      </div>
    </>
  )
}
