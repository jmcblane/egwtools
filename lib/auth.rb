#!/usr/bin/ruby

require 'oauth2'

# Go to a.egwwritings.org to register the app and get a CLIENT_ID.
# Make sure you set the authentication to password.

$egwclient = OAuth2::Client.new(
    'CLIENT_ID',
    'CLIENT_SECRET',
    :site => "https://a.egwwritings.org",
    :authorize_url => "https://cpanel.egwwritings.org/o/authorize/",
    :token_url => "https://cpanel.egwwritings.org/o/token/" )

def get_token
    $egw = $egwclient.password.get_token("USERNAME", "PASSWORD")
end

get_token
