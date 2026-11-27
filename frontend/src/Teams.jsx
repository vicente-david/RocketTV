import { useEffect, useState } from 'react'

export default function Teams() {
  // A place to keep the teams. Starts as an empty list [] so that
  // teams.map() works before the data actually arrives
  const [teams, setTeams] = useState([])
  const [error, setError] = useState(null)

  // fetch once, when this component first appears
  useEffect(() => {
    fetch('/api/team/')
      .then((res) => res.json())             // response → JS object: { teams: [{team_id, team_name,..},..] }
      .then((data) => setTeams(data.teams))  // keep just the list inside it, not the whole object
      .catch((e) => setError(e.message))     // if anything fails, keep the message
  }, [])

  
  return (
    <section>
      <h2>Teams</h2>
      {error && <p>Couldn't load teams: {error}</p>}
      <ul>
        {teams.map((team) => (
          <li key={team.team_id}>
            {team.team_name} ({team.region_name})
          </li>
        ))}
      </ul>
    </section>
  )
}