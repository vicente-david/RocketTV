import { useEffect, useState } from 'react'

export default function Teams() {
  const [teams, setTeams] = useState([])
  const [error, setError] = useState(null)

  useEffect(() => {
    fetch('/api/team/')
      .then((res) => res.json())
      .then((data) => setTeams(data.teams))
      .catch((e) => setError(e.message))
  }, [])

  
  return (
    <section>
      <h2>Teams</h2>
      {error && <p>Couldn't load teams: {error}</p>}
      <ul>
        {teams.map((team) => (
          <li key={team.TeamID}>
            {team.TeamName} ({team.RegionName})
          </li>
        ))}
      </ul>
    </section>
  )
}