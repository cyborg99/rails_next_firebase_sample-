import { useRouter } from 'next/router'
import { createContext, useEffect, useState } from 'react'
import { destroyTokenCookieIfTokenError, getTokenCookie, setTokenCookie } from '../cookie'
import { useUserLazyQuery } from '../graphql/documents/user.generated'
import { UserQuery } from '../graphql/types'

type UserContextType = UserQuery['user'] | undefined
export const UserContext = createContext<UserContextType>(undefined)

export default function AuthContextProvider({ children }: { children: React.ReactNode }) {
  const [getUser, { data, error }] = useUserLazyQuery()
  const [user, setUser] = useState<UserContextType>()
  const router = useRouter()
  useEffect(() => {
    if (getTokenCookie()) {
      getUser()
    } else if (router.pathname !== '/') {
      router.push('/')
    }
  }, [router])

  useEffect(() => {
    if (data) {
      setTokenCookie(data.user.idToken)
      setUser(data.user)
      if (router.pathname == '/') router.push('/my_page')
    }
    if (error) {
      setUser(undefined)
      destroyTokenCookieIfTokenError(error.message)
    }
  }, [data, error])

  return <UserContext.Provider value={user}>{children}</UserContext.Provider>
}
