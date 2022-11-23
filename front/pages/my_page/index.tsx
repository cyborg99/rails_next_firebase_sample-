import { Button, Typography } from '@mui/material'
import { Stack } from '@mui/system'
import dynamic from 'next/dynamic'
import { useRouter } from 'next/router'
import { destroyTokenCookie, destroyTokenCookieIfTokenError } from '../../cookie'
import { useUserQuery } from '../../graphql/documents/user.generated'

function MyPage() {
  const router = useRouter()
  const { data, error } = useUserQuery({ defaultOptions: { fetchPolicy: 'cache-and-network' } })

  const handleLogout = () => {
    destroyTokenCookie()
    router.push('/')
  }

  if (error) {
    destroyTokenCookieIfTokenError(error.message)
    router.push('/')
  }

  if (!data) return <></>

  return (
    <Stack spacing={2} alignItems="center" textAlign="center" justifyContent="center" mt={5}>
      <Typography>{`Hello ${data.user.userName || data.user.id}`}</Typography>
      <Button variant="contained" color="error" onClick={handleLogout}>
        ログアウト
      </Button>
    </Stack>
  )
}

export default dynamic(async () => MyPage, { ssr: false })
