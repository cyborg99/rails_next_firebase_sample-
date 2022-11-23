# README

## Set Up

Execute `cp .env .env.development`
Set the value in your Set values in `.env.development`

## Rails

See [here](https://guides.rubyonrails.org/index.html) for information on how to start Rails, etc.

## Features

### User Registration

Receive and decode Firebase ID token.
Once decoded, you will be able to retrieve information about the user that the social provider has.
Decoding is secured using public keys published by Google.

### User Authentication

Receive a FIrebase refresh token and use Firebase's publicly available Rest to refresh the token and obtain the user_id.
Refreshing also extends the validity period of the token.
