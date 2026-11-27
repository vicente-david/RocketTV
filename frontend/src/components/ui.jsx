import { Link } from 'react-router-dom'

export const Loading = () => <p className="muted">Loading…</p>
export const NotFound = ({ what = 'page' }) => <p className="muted">That {what} was not found.</p>

export function Chips({ options, value, onChange }) {
  return (
    <div className="chips" role="tablist">
      {options.map((o) => {
        const [v, label] = Array.isArray(o) ? o : [o, o]
        return (
          <button key={v} role="tab" aria-selected={value === v} className={value === v ? 'chip on' : 'chip'} onClick={() => onChange(v)}>
            {label}
          </button>
        )
      })}
    </div>
  )
}

export const RegionBadge = ({ region }) => region ? <span className={`badge r-${region}`}>{region}</span> : null

export function MatchRow({ m }) {
  const t1Win = m.team1_score > m.team2_score
  return (
    <Link to={`/matches/${m.tournament_id}/${m.match_id}`} className="match card-link">
      <span className="match-meta">{m.tournament_name} · {m.date ?? ''}</span>
      <span className="match-line">
        <span className={t1Win ? 'team win' : 'team'}>{m.team1_name}</span>
        <span className="score">{m.team1_score} – {m.team2_score}</span>
        <span className={!t1Win ? 'team win right' : 'team right'}>{m.team2_name}</span>
      </span>
    </Link>
  )
}

export function StatGrid({ items }) {
  return (
    <dl className="stat-grid">
      {items.map(([label, value]) => (
        <div key={label}><dt>{label}</dt><dd>{value ?? '–'}</dd></div>
      ))}
    </dl>
  )
}

export const Table = ({ children }) => <div className="table-wrap"><table>{children}</table></div>
