import '../styles/globals.css'
import { ApolloProvider } from '@apollo/client'
import type { AppProps } from 'next/app'
import client from '../graphql/client'

export default function App({ Component, pageProps }: AppProps) {
  Component.contextTypes
  return (
    <ApolloProvider client={client}>
      <Component {...pageProps} />
    </ApolloProvider>
  )
}
