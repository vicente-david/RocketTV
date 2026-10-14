import { useEffect, useState } from 'react'

export default function App() {
  const [health, setHealth] = useState(null)
  const [error, setError] = useState(null)

  useEffect(() => {
    fetch('/api/health/')
      .then((res) => res.json())
      .then(setHealth)
      .catch((e) => setError(e.message))
  }, [])

  return (
    <main>
      <h1>Rocket.tv</h1>
      {error && <p>Backend unreachable: {error}</p>}
      {health && <p>Django is connected to MySQL {health.mysql_version}</p>}
      {!error && !health && <p>Checking…</p>}
    </main>
  )
}
