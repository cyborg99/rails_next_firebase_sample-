import { AuthErrorCodes, AuthProvider, getAdditionalUserInfo, signInWithPopup } from 'firebase/auth'
import { useRouter } from 'next/router'
import { useState } from 'react'
import { auth, githubAuthProvider, googleAuthprovider } from '../features/const/firebase'

type SuccessState = {
  isNewUser?: boolean
  idToken?: string
  refreshToken?: string
}

export default function useFirebaseAuth() {
  const [successState, setSuccessState] = useState<SuccessState>({})
  const snsAuthPopup = (authprovider: AuthProvider) =>
    signInWithPopup(auth, authprovider)
      .then((result) => {
        result.user.getIdToken().then((token) => {
          result.user.displayName
          setSuccessState({
            isNewUser: getAdditionalUserInfo(result)?.isNewUser,
            idToken: token,
            refreshToken: result.user.refreshToken
          })
        })
      })
      .catch((e) => {
        if (e.code === AuthErrorCodes.NEED_CONFIRMATION) {
          console.log('既に他のSNSと連携済みです。')
        }
      })
  const authInfoList = [
    {
      alt: 'Google',
      image: '/asserts/images/sns_auths/google.png',
      method: () => snsAuthPopup(googleAuthprovider)
    },
    {
      name: 'GitHub',
      image: '/asserts/images/sns_auths/git_hub.png',
      method: () => snsAuthPopup(githubAuthProvider)
    }
  ] as {
    name: string
    image: string
    method: () => void
  }[]

  const router = useRouter()
  const successAuth = () => {
    router.push('./my_page')
  }

  return { authInfoList, successState, successAuth }
}
