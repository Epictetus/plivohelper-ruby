#!/usr/bin/env ruby

require 'plivohelper'


# This is the signature we expect for the key, url, and params below
expected_sig = 'Ma7fvTryuU51vDGO2IT5/KhivpI='

# Plivo AccountSid and AuthToken
ACCOUNT_SID = 'ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
ACCOUNT_TOKEN = 'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY'

# ===========================================================================
# 1. Validate a Plivo request

# the URL and POST parameters would typically be provided by the web
# framework that is recieving the request from Plivo (e.g. Django)
url = "http://UUUUUUUUUUUUUUUUUU"
postvars = {}

# the request from Plivo also includes the HTTP header: X-Plivo-Signature
# containing the expected signature
signature = "SSSSSSSSSSSSSSSSSSSSSSSSSSSS"

# Create a new Utils Object
utils = Plivo::Utils.new(ACCOUNT_SID, ACCOUNT_TOKEN);

# Check if the signature matches the expected signature
result = utils.validateRequest(signature, url, postvars);

if result
  puts "The signature is valid!"
else
  puts "The signature was NOT VALID.  It might have been spoofed!"
end
