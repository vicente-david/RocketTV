import { useEffect, useState } from 'react'
import { BrowserRouter, NavLink, Link, Route, Routes, useNavigate } from 'react-router-dom'
import { getMockPaths, onMockChange } from './api.js'
import Home from './pages/Home.jsx'
import Teams from './pages/Teams.jsx'
import TeamPage from './pages/TeamPage.jsx'
import Tournaments from './pages/Tournaments.jsx'
import TournamentPage from './pages/TournamentPage.jsx'
import MatchPage from './pages/MatchPage.jsx'
import PlayerPage from './pages/PlayerPage.jsx'
import Leaderboard from './pages/Leaderboard.jsx'
import Compare from './pages/Compare.jsx'
import SearchPage from './pages/SearchPage.jsx'
import Login from './pages/Login.jsx'

function SearchBox() {
  const navigate = useNavigate()
  const [text, setText] = useState('')
  return (
    <form className="searchbox" role="search" onSubmit={(e) => { e.preventDefault(); if (text.trim()) navigate(`/search?q=${encodeURIComponent(text.trim())}`) }}>
      <input value={text} onChange={(e) => setText(e.target.value)} placeholder="Search teams & players" aria-label="Search" />
    </form>
  )
}

function MockBanner() {
  const [paths, setPaths] = useState(getMockPaths())
  useEffect(() => onMockChange(setPaths), [])
  if (!paths.length) return null
  return <div className="banner">Showing sample data for endpoints not built yet: {paths.map((p) => <code key={p}>{p}</code>)}</div>
}

export default function App() {
  return (
    <BrowserRouter>
      <header className="top">
        <Link to="/" className="logo">Rocket<span>.tv</span></Link>
        <SearchBox />
        <Link to="/login" className="login-link">Log in</Link>
      </header>
      <nav className="tabs">
        {[['/', 'Home'], ['/tournaments', 'Tournaments'], ['/teams', 'Teams'], ['/leaderboard', 'Leaders'], ['/compare', 'Compare']].map(([to, label]) => (
          <NavLink key={to} to={to} end={to === '/'}>{label}</NavLink>
        ))}
      </nav>
      <main>
        <MockBanner />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/tournaments" element={<Tournaments />} />
          <Route path="/tournaments/:id" element={<TournamentPage />} />
          <Route path="/matches/:tid/:mid" element={<MatchPage />} />
          <Route path="/teams" element={<Teams />} />
          <Route path="/teams/:id" element={<TeamPage />} />
          <Route path="/players/:id" element={<PlayerPage />} />
          <Route path="/leaderboard" element={<Leaderboard />} />
          <Route path="/compare" element={<Compare />} />
          <Route path="/search" element={<SearchPage />} />
          <Route path="/login" element={<Login />} />
          <Route path="*" element={<p className="muted">Page not found.</p>} />
        </Routes>
      </main>
    </BrowserRouter>
  )
}
