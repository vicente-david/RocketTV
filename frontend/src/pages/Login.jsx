import { useState } from 'react'
import { Chips } from '../components/ui.jsx'

// UI only for now: submitting does nothing until auth endpoints exist
export default function Login() {
  const [role, setRole] = useState('viewer')
  const [mode, setMode] = useState('login')
  const [sent, setSent] = useState(false)
  const register = role === 'viewer' && mode === 'register'
  return (
    <>
      <h1>{register ? 'Create account' : 'Log in'}</h1>
      <Chips options={[['viewer', 'Viewer'], ['admin', 'Admin']]} value={role} onChange={(r) => { setRole(r); setMode('login'); setSent(false) }} />
      <form className="form" onSubmit={(e) => { e.preventDefault(); setSent(true) }}>
        <label className="field">Username<input required autoComplete="username" /></label>
        {register && <label className="field">Email<input type="email" required autoComplete="email" /></label>}
        <label className="field">Password<input type="password" required autoComplete={register ? 'new-password' : 'current-password'} /></label>
        <button className="btn" type="submit">{register ? 'Register' : 'Log in'}</button>
        {sent && <p className="muted">Login is not connected to the backend yet.</p>}
      </form>
      {role === 'viewer' && (
        <p className="muted">{register ? 'Have an account?' : 'New here?'}{' '}
          <button className="link" onClick={() => { setMode(register ? 'login' : 'register'); setSent(false) }}>{register ? 'Log in' : 'Create an account'}</button>
          {' '}or just keep browsing as a guest.</p>
      )}
    </>
  )
}
