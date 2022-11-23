import { Stack } from '@mui/material'
import { useRouter } from 'next/router'
import { useEffect } from 'react'
import SnsAuthButtons from '../components/provider_auth'
import { destroyTokenCookieIfTokenError, getTokenCookie } from '../cookie'
import { useUserLazyQuery } from '../graphql/documents/user.generated'

export default function Home() {
  const router = useRouter()
  const [getUser] = useUserLazyQuery()
  useEffect(() => {
    if (getTokenCookie()) {
      getUser()
        .then(() => router.push('/my_page'))
        .catch((error) => destroyTokenCookieIfTokenError(error.message))
    }
  }, [])

  return (
    <Stack alignItems="center">
      <SnsAuthButtons />
    </Stack>
  )
}
