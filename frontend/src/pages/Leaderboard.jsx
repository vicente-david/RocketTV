import { useState } from 'react'
import { Link } from 'react-router-dom'
import { api } from '../api.js'
import { useData } from '../hooks.js'
import { Chips, Loading, Table } from '../components/ui.jsx'

const STATS = [['goals', 'Goals'], ['assists', 'Assists'], ['saves', 'Saves'], ['score', 'Score'], ['demos', 'Demos']]

export default function Leaderboard() {
  const [stat, setStat] = useState('goals')
  const [region, setRegion] = useState('ALL')
  const regions = useData(() => api.regions(), [])
  const { data, loading } = useData(() => api.leaderboard(stat, region), [stat, region])
  return (
    <>
      <h1>Leaderboards</h1>
      <Chips options={STATS} value={stat} onChange={setStat} />
      {regions.data && <Chips options={['ALL', ...regions.data.regions]} value={region} onChange={setRegion} />}
      {loading ? <Loading /> : (
        <Table>
          <thead><tr><th>#</th><th>Player</th><th>Team</th><th>Games</th><th>{STATS.find(([k]) => k === stat)[1]}</th></tr></thead>
          <tbody>{data.rows.map((r, i) => (
            <tr key={r.player_id}><td>{i + 1}</td><td><Link to={`/players/${r.player_id}`}>{r.username}</Link></td>
              <td>{r.team_name}</td><td>{r.games}</td><td><b>{r.value}</b></td></tr>
          ))}</tbody>
        </Table>
      )}
    </>
  )
}
