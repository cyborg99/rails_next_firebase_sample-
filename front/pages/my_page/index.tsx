import { Button, Typography } from '@mui/material'
import { Stack } from '@mui/system'
import dynamic from 'next/dynamic'
import { useRouter } from 'next/router'
import { useContext } from 'react'
import { UserContext } from '../../context/AuthCcontextProvider'
import { destroyTokenCookie } from '../../cookie'

function MyPage() {
  const user = useContext(UserContext)
  const router = useRouter()
  const handleLogout = () => {
    destroyTokenCookie()
    router.push('/')
  }
  if (!user) return <></>
  return (
    <Stack spacing={2} alignItems="center" textAlign="center" justifyContent="center" mt={5}>
      <Typography>{`Hello ${user.userName || user.id}`}</Typography>
      <Button variant="contained" color="error" onClick={handleLogout}>
        ログアウト
      </Button>
    </Stack>
  )
}

export default dynamic(async () => MyPage, { ssr: false })
