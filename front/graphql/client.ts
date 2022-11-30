import { ApolloClient, InMemoryCache, createHttpLink, NormalizedCacheObject, ApolloLink } from '@apollo/client'

const createLink = (): ApolloLink => {
  return createHttpLink({
    uri: `${process.env.SERVICE_URL}/graphql`,
    headers: {
      'content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest'
    },
    credentials: 'include'
  })
}

const createCrient = (): ApolloClient<NormalizedCacheObject> => {
  const cache = new InMemoryCache()
  return new ApolloClient({
    ssrMode: typeof window === 'undefined',
    link: createLink(),
    cache
  })
}

const client = createCrient()

export default client
