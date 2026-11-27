import { useEffect, useState } from 'react'


export default function TeamsByRegion({ region }) {
  const [teams, setTeams] = useState([])
  const [error, setError] = useState(null)

  useEffect(() => {
    // Backticks ` ` make a "template string": ${...} inserts a value.
    fetch(`/api/teams/region/${region}/`)
      .then((res) => res.json())
      .then((data) => setTeams(data.teams))
      .catch((e) => setError(e.message))
  }, [region])   // re-fetch whenever region changes

  return (
    <section>
      <h2>{region} Teams</h2>
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