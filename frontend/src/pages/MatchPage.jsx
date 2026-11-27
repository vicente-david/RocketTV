import { Link, useParams } from 'react-router-dom'
import { api } from '../api.js'
import { useData } from '../hooks.js'
import { Loading, NotFound, Table } from '../components/ui.jsx'

export default function MatchPage() {
  const { tid, mid } = useParams()
  const { data, loading } = useData(() => api.match(tid, mid), [tid, mid])
  if (loading) return <Loading />
  if (!data) return <NotFound what="match" />
  const { match: m, games, player_stats: stats } = data
  return (
    <>
      <p className="muted"><Link to={`/tournaments/${m.tournament_id}`}>{m.tournament_name}</Link> · Best of {m.best_of}</p>
      <div className="scoreboard">
        <Link to={`/teams/${m.team1_id}`}>{m.team1_name}</Link>
        <strong>{m.team1_score} – {m.team2_score}</strong>
        <Link to={`/teams/${m.team2_id}`}>{m.team2_name}</Link>
      </div>
      <h2>Games</h2>
      <Table>
        <thead><tr><th>Game</th><th>Date</th><th>{m.team1_name}</th><th>{m.team2_name}</th></tr></thead>
        <tbody>{games.map((g) => (
          <tr key={g.game_id}><td>{g.game_id}</td><td>{g.date}</td>
            <td className={g.team1_score > g.team2_score ? 'win' : ''}>{g.team1_score}</td>
            <td className={g.team2_score > g.team1_score ? 'win' : ''}>{g.team2_score}</td></tr>
        ))}</tbody>
      </Table>
      {[m.team1_id, m.team2_id].map((tid2) => (
        <section key={tid2}>
          <h2>{tid2 === m.team1_id ? m.team1_name : m.team2_name} player stats</h2>
          <Table>
            <thead><tr><th>Player</th><th>Goals</th><th>Assists</th><th>Saves</th><th>Shots</th><th>Demos</th><th>Score</th></tr></thead>
            <tbody>{stats.filter((s) => s.team_id === tid2).map((s) => (
              <tr key={s.player_id}><td><Link to={`/players/${s.player_id}`}>{s.username}</Link></td>
                <td>{s.goals}</td><td>{s.assists}</td><td>{s.saves}</td><td>{s.shots}</td><td>{s.demos}</td><td>{s.score}</td></tr>
            ))}</tbody>
          </Table>
        </section>
      ))}
    </>
  )
}
