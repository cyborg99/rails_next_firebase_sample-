export type Maybe<T> = T | null
export type InputMaybe<T> = Maybe<T>
export type Exact<T extends { [key: string]: unknown }> = {
  [K in keyof T]: T[K]
}
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & {
  [SubKey in K]?: Maybe<T[SubKey]>
}
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & {
  [SubKey in K]: Maybe<T[SubKey]>
}
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: string
  String: string
  Boolean: boolean
  Int: number
  Float: number
  ISO8601DateTime: any
}

export type Mutation = {
  __typename?: 'Mutation'
  signUpUser?: Maybe<SignUpUserPayload>
}

export type MutationSignUpUserArgs = {
  input: SignUpUserInput
}

export type Query = {
  __typename?: 'Query'
  user: User
}

/** Autogenerated input type of SignUpUser */
export type SignUpUserInput = {
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: InputMaybe<Scalars['String']>
  token: Scalars['String']
}

/** Autogenerated return type of SignUpUser. */
export type SignUpUserPayload = {
  __typename?: 'SignUpUserPayload'
  /** A unique identifier for the client performing the mutation. */
  clientMutationId?: Maybe<Scalars['String']>
  user: User
}

export type User = {
  __typename?: 'User'
  createdAt: Scalars['ISO8601DateTime']
  email?: Maybe<Scalars['String']>
  id: Scalars['ID']
  updatedAt: Scalars['ISO8601DateTime']
  userName?: Maybe<Scalars['String']>
}

export type SignUpUserMutationVariables = Exact<{
  input: SignUpUserInput
}>

export type SignUpUserMutation = {
  __typename?: 'Mutation'
  signUpUser?: {
    __typename: 'SignUpUserPayload'
    user: { __typename?: 'User'; id: string; email?: string | null }
  } | null
}

export type UserQueryVariables = Exact<{ [key: string]: never }>

export type UserQuery = {
  __typename?: 'Query'
  user: {
    __typename?: 'User'
    id: string
    email?: string | null
    userName?: string | null
  }
}