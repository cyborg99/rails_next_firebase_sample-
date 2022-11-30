// Import the functions you need from the SDKs you need
import { ImageList, ImageListItem } from '@mui/material'
import { Stack } from '@mui/system'

import dynamic from 'next/dynamic'
import { useEffect } from 'react'
import { useSignInUserMutation } from '../graphql/documents/signInUser.generated'
import { useSignUpUserMutation } from '../graphql/documents/signUpUser.generated'
import useFirebaseAuth from '../hooks/use_firebase_auth'

function SnsAuthButtons() {
  const { authInfoList, successState, successAuth } = useFirebaseAuth()

  const [signUpUserMutation] = useSignUpUserMutation()
  const [signInUserMutation] = useSignInUserMutation()
  useEffect(() => {
    if (successState.idToken && successState.refreshToken) {
      const variables = {
        variables: {
          input: { idToken: successState.idToken, refreshToken: successState.refreshToken }
        }
      }
      if (successState.isNewUser) {
        signUpUserMutation(variables).then(() => successAuth())
      } else {
        signInUserMutation(variables).then(() => successAuth())
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
