import { Link } from 'react-router-dom'
import { api } from '../api.js'
import { useData } from '../hooks.js'
import { Loading, MatchRow } from '../components/ui.jsx'

export default function Home() {
  const recent = useData(() => api.recentMatches(), [])
  const tours = useData(() => api.tournaments(), [])
  return (
    <>
      <section className="hero">
        <h1>Rocket League esports, tracked.</h1>
        <p>Browse tournaments, teams, players and stats. No typing needed, just tap.</p>
        <div className="cta">
          <Link className="btn" to="/tournaments">Tournaments</Link>
          <Link className="btn ghost" to="/leaderboard">Leaderboards</Link>
        </div>
      </section>
      <h2>Latest results</h2>
      {recent.loading ? <Loading /> : <div className="list">{recent.data.matches.map((m) => <MatchRow key={`${m.tournament_id}-${m.match_id}`} m={m} />)}</div>}
      <h2>Tournaments</h2>
      {tours.loading ? <Loading /> : (
        <div className="list">
          {tours.data.tournaments.slice(0, 4).map((t) => (
            <Link key={t.tournament_id} to={`/tournaments/${t.tournament_id}`} className="row card-link">
              <b>{t.name}</b><span className="muted">{t.start_date}</span>
            </Link>
          ))}
        </div>
      )}
    </>
  )
}
