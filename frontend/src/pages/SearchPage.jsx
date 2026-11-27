import { Link, useSearchParams } from 'react-router-dom'
import { api } from '../api.js'
import { useData } from '../hooks.js'
import { Loading } from '../components/ui.jsx'

export default function SearchPage() {
  const [params] = useSearchParams()
  const text = params.get('q') ?? ''
  const { data, loading } = useData(() => api.search(text), [text])
  return (
    <>
      <h1>Results for “{text}”</h1>
      {loading ? <Loading /> : (
        <div className="list">
          {data.results.map((r) => (
            <Link key={`${r.kind}-${r.id}`} to={`/${r.kind === 'Team' ? 'teams' : 'players'}/${r.id}`} className="row card-link">
              <b>{r.name}</b><span className="muted">{r.kind} · {r.detail}</span>
            </Link>
          ))}
          {!data.results.length && <p className="muted">Nothing found.</p>}
        </div>
      )}
    </>
  )
}
