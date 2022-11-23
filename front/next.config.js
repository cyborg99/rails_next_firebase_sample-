/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true
}

module.exports = {
  ...nextConfig,
  env: { ...require(`./config/env.${process.env.APP_ENV || 'local'}.json`) }
}
