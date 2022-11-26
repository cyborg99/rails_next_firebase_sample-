import { ApolloClient, InMemoryCache, createHttpLink, NormalizedCacheObject, ApolloLink } from '@apollo/client'
import { getTokenCookie } from '../cookie'

const createLink = (token: string): ApolloLink => {
  return createHttpLink({
    uri: `${process.env.SERVICE_URL}/graphql`,
    headers: {
      'content-Type': 'application/json',
      Authorization: `Bearer ${token}`
    }
  })
}

const createCrient = (token: string): ApolloClient<NormalizedCacheObject> => {
  const cache = new InMemoryCache()
  return new ApolloClient({
    ssrMode: typeof window === 'undefined',
    link: createLink(token),
    cache
  })
}

export const setClientHeaders = (token?: string): void => {
  client.setLink(createLink(token || ''))
}

const client = createCrient(getTokenCookie() || '')

export default client
