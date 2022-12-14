import { initializeApp } from 'firebase/app'
import { getAuth, GithubAuthProvider, GoogleAuthProvider } from 'firebase/auth'

const firebaseConfig = {
  apiKey: process.env.FIREBASE_APIKEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  projectId: process.env.FIREBASE_PROJECT_ID,
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.FIREBASE_APP_ID,
  measurementId: process.env.FIREBASE_MEASUREMENT_ID
}
export const app = initializeApp(firebaseConfig)

export const googleAuthprovider = new GoogleAuthProvider()
export const githubAuthProvider = new GithubAuthProvider()
// export const analytics = getAnalytics(app);
export const auth = getAuth(app)
