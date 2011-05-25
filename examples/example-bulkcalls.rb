require 'plivohelper'

#URL of the Plivo REST service
REST_API_URL = 'http://127.0.0.1:8088'

# Sid and AuthToken
SID = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
AUTH_TOKEN = 'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY'

#Define Channel Variable - http://wiki.freeswitch.org/wiki/Channel_Variables
extra_dial_string = "bridge_early_media=true,hangup_after_bridge=true"

# Create a REST object
plivo = Plivo::Rest.new(REST_API_URL, SID, AUTH_TOKEN)


# Initiate a new outbound call to user/1000 using a HTTP POST
# All parameters for bulk calls shall be separated by a delimeter
call_params = {
    'Delimiter' => '>', # Delimter for the bulk list
    'From'=> '919191919191', # Caller Id
    'To' => '1000>1000', # User Numbers to Call separated by delimeter
    'Gateways' => "user/>user/", # Gateway string for each number separated by delimeter
    'GatewayCodecs' => "'PCMA,PCMU'>'PCMA,PCMU'", # Codec string as needed by FS for each gateway separated by delimeter
    'GatewayTimeouts' => "60>30", # Seconds to timeout in string for each gateway separated by delimeter
    'GatewayRetries' => "2>1", # Retry String for Gateways separated by delimeter, on how many times each gateway should be retried
    'ExtraDialString' => extra_dial_string,
    'AnswerUrl' => "http://127.0.0.1:5000/answered/",
    'HangupUrl' => "http://127.0.0.1:5000/hangup/",
    'RingUrl' => "http://127.0.0.1:5000/ringing/",
#    'TimeLimit' => '10>30',
#    'HangupOnRing' => "0>0",
}

request_uuid = ""

#Perform the Call on the Rest API
begin
    result = plivo.bulk_call(call_params).body
rescue Exception=>e
    print e
end

print result
