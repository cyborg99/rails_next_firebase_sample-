# README

## Set Up

Execute `cp .env .env.development`
Set the value in your Set values in `.env.development`

## Rails

See [here](https://guides.rubyonrails.org/index.html) for information on how to start Rails, etc.

## Features

### User Registration

Receive FIrebase refresh token and store it in the database.
Receive and decode Firebase ID token.
Once decoded, you will be able to retrieve information about the user that the social provider has.
Decoding is secured using public keys published by Google.
Register users based on the decoded information

### User Authentication

Receives a Firebase identity token and searches for users in the database based on the decoded user_id.
If the FIrebase identity token has expired, use a refresh token to extend the expiration date.
The newly generated ID token and refresh token are returned to the client.
