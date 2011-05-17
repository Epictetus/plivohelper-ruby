require 'plivohelper'

=begin
The RESTXML Ruby Response Library makes it easy to write RESTXML without having
to touch XML. Error checking is built in to help preventing invalid markup.

USAGE:
To create RESTXML, you will make RESTXML Grammar.
Convenience methods are provided to simplify RESTXML creation.

SUPPORTED GRAMMAR:
    Response
    Speak
    Play
    Dial
    GetDigits
    Hangup
    Redirect
    Record
    Wait
    Number
    Conference
    PreAnswer
    RecordSession
    ScheduleHangup
=end

# ===========================================================================
# 1. Speak, Dial, and Play
@r = Plivo::Response.new
@r.append(Plivo::Speak.new("Hello World", :voice => "man", :loop => "10"))
@r.append(Plivo::Dial.new("4155551212", :timeLimit => "45"))
@r.append(Plivo::Play.new("http://www.mp3.com"))
puts @r.respond

#<Response>
#  <Speak voice="man" loop="10">Hello World</Speak>
#  <Play>http://www.mp3.com</Play>
#  <Dial timeLimit="45">4155551212</Dial>
#</Response>


# ===========================================================================
# 2. GetDigits, Redirect
@r = Plivo::Response.new;
@g = @r.append(Plivo::GetDigits.new(:numDigits => "10", :playBeep => 'true', :timeout => '25'))
@g.append(Plivo::Speak.new("Press 1"))
@r.append(Plivo::Wait.new(:length => "5"))
@r.append(Plivo::ScheduleHangup.new(:time => "10"))
@r.append(Plivo::Redirect.new())
puts @r.respond


#<Response>
#  <GetDigits numDigits="1">
#    <Speak>Press 1</Speak>
#  </GetDigits>
#  <Redirect/>
#</Response>


# ===========================================================================
# 3. Add a Speak verb multiple times
@r = Plivo::Response.new
@say = Plivo::Speak.new("Press 1")
@r.append(@say);
@r.append(@say);
puts @r.respond

#<Response>
#  <Speak>Press 1</Speak>
#  <Speak>Press 1</Speak>
#</Response>

# ===========================================================================
# 3. Create a Conference Call
@r = Plivo::Response.new
@r.addGetDigits(:numDigits => "10", :playBeep => 'true', :timeout => '25')
@r.addConference("MyRoom", :startConferenceOnEnter => "true")
puts @r.respond

#<Response>
#  <Conference startConferenceOnEnter="true">MyRoom</Conference>
#</Response>

# ===========================================================================
# 4. Set any attribute / value pair

@r = Plivo::Response.new
@rd = Plivo::Redirect.new
@rd.set(:crazy => "delicious")
@r.append(@rd)
puts @r.respond


#<Response>
#  <Redirect crazy="delicious"/>
#<Response>

# ===========================================================================
# 5. Convenience methods
@r = Plivo::Response.new
@r.addSpeak "Hello World", :voice => "man", :language => "fr", :loop => "10"
@r.addConference("MyRoom")
@r.addPlay "http://www.mp3.com"
puts @r.respond

#<Response>
#  <Speak voice="man" language="fr" loop="10">Hello World</Speak>
#  <Conference>MyRoom</Conference>
#  <Play>http://www.mp3.com</Play>
#</Response>
