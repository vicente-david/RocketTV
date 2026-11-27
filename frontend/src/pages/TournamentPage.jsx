import { Link, useParams } from 'react-router-dom'
import { api } from '../api.js'
import { useData } from '../hooks.js'
import { Loading, MatchRow, NotFound, Table } from '../components/ui.jsx'

export default function TournamentPage() {
  const { id } = useParams()
  const { data, loading } = useData(() => api.tournament(id), [id])
  if (loading) return <Loading />
  if (!data?.tournament) return <NotFound what="tournament" />
  const { tournament: t, standings, matches } = data
  return (
    <>
      <h1>{t.name}</h1>
      <p className="muted">{t.start_date} → {t.end_date}{t.location ? ` · ${t.location}` : ''}</p>
      <h2>Standings</h2>
      <Table>
        <thead><tr><th>#</th><th>Team</th><th>Seed</th><th>Points</th></tr></thead>
        <tbody>
          {standings.map((s) => (
            <tr key={s.team_id}>
              <td>{s.placement ?? '–'}</td>
              <td><Link to={`/teams/${s.team_id}`}>{s.team_name}</Link></td>
              <td>{s.seed}</td><td>{s.points}</td>
            </tr>
          ))}
        </tbody>
      </Table>
      <h2>Matches</h2>
      <div className="list">{matches.map((m) => <MatchRow key={m.match_id} m={m} />)}
        {!matches.length && <p className="muted">No matches recorded yet.</p>}</div>
    </>
  )
}
