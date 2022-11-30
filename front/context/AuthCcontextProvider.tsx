import { useRouter } from 'next/router'
import { createContext, useEffect, useState } from 'react'
import { useUserLazyQuery } from '../graphql/documents/user.generated'
import { UserQuery } from '../graphql/types'

type UserContextType = UserQuery['user'] | undefined
export const UserContext = createContext<UserContextType>(undefined)

export default function AuthContextProvider({ children }: { children: React.ReactNode }) {
  const [getUser, { data, error }] = useUserLazyQuery()
  const [user, setUser] = useState<UserContextType>()
  const router = useRouter()
  useEffect(() => {
    getUser()
  }, [router])

  useEffect(() => {
    if (data) {
      setUser(data.user)
      if (router.pathname === '/') router.push('/my_page')
    }

    if (error) {
      setUser(undefined)
      if (router.pathname !== '/') router.push('/')
    }
  }, [data, error])

  return <UserContext.Provider value={user}>{children}</UserContext.Provider>
}
