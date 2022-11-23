// Import the functions you need from the SDKs you need
import { ImageList, ImageListItem } from '@mui/material'
import { Stack } from '@mui/system'

import dynamic from 'next/dynamic'
import { useRouter } from 'next/router'
import { useEffect } from 'react'
import { setTokenCookie } from '../cookie'
import { setClientHeaders } from '../graphql/client'
import { useSignUpUserMutation } from '../graphql/documents/signUpUser.generated'
import useFirebaseAuth from '../hooks/use_firebase_auth'

function SnsAuthButtons() {
  const { authInfoList, successState } = useFirebaseAuth()
  const router = useRouter()

  const [signUpUserMutation, { loading }] = useSignUpUserMutation()
  const successAuth = () => {
    setClientHeaders(successState.refreshToken)
    setTokenCookie(successState.refreshToken)
    router.push('./my_page')
  }
  useEffect(() => {
    if (successState.idToken) {
      if (successState.isNewUser) {
        signUpUserMutation({
          variables: {
            input: { token: successState.idToken }
          }
        }).then(() => {
          successAuth()
        })
      } else {
        successAuth()
      }
    }
  }, [successState])

  return (
    <Stack width={300}>
      <ImageList cols={1} rowHeight={70} gap={25}>
        {authInfoList.map((authInfo, i) => (
          <ImageListItem key={`${i}-auth-image`}>
            <input
              onClick={authInfo.method}
              type="image"
              alt={authInfo.name}
              src={authInfo.image}
              style={{ objectFit: 'contain', height: '100%', width: '100%' }}
            />
          </ImageListItem>
        ))}
      </ImageList>
    </Stack>
  )
}
export default dynamic(async () => SnsAuthButtons, { ssr: false })
