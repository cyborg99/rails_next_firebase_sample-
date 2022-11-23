import { NextPageContext } from 'next'
import { setCookie, destroyCookie, parseCookies } from 'nookies'

const aYearMaxAge = 365 * 24 * 60 * 60 * 1000

export const setTokenCookie = (token?: string) => {
  if (token) {
    setCookie(null, 'token', token, { maxAge: aYearMaxAge })
  } else {
    destroyCookie(null, 'token')
  }
}

export function getTokenCookie(ctx?: NextPageContext): string | null {
  const cookie = parseCookies(ctx)
  return cookie ? cookie['token'] : null
}

export function destroyTokenCookie() {
  destroyCookie(null, 'token')
}

export function destroyTokenCookieIfTokenError(message: string) {
  if (['TOKEN_EXPIRED', 'USER_DISABLED', 'USER_NOT_FOUND', 'INVALID_REFRESH_TOKEN'].includes(message)) {
    destroyTokenCookie()
  } else {
    throw Error
  }
}
