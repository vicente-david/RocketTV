import { useEffect, useState } from 'react'

export function useData(fetcher, deps) {
  const key = JSON.stringify(deps)
  const [state, setState] = useState({ key: null, data: null })
  useEffect(() => {
    let live = true
    fetcher().then((data) => live && setState({ key, data }))
    return () => { live = false }
  }, [key])
  return { data: state.key === key ? state.data : null, loading: state.key !== key }
}
