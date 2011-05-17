require '../lib/plivohelper.rb'

module PlivoExampleHelperMethods

  def bad_append(verb)

    lambda {verb.append(Plivo::Response)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Speak)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Play)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::GetDigits)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Record)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Redirect)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Hangup)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Wait)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Number)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Sms)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Conference)}.should raise_error(ArgumentError)

  end

  def bad_attr(verb)
    lambda {verb.new(:crazy => 'delicious')}.should raise_error(ArgumentError)
  end

end

describe Plivo::Response do
  include PlivoExampleHelperMethods

  it "should be an empty response" do
    @r = Plivo::Response.new
    @r.respond.should == '<Response></Response>'
  end

  it "add attribute" do
    @r = Plivo::Response.new
    @r.set :crazy => 'delicious'
    @r.respond.should == '<Response crazy="delicious"></Response>'
  end

  it "bad attribute" do
    bad_attr(Plivo::Response)
  end

end

describe Plivo::Speak do
  include PlivoExampleHelperMethods

  it "should say hello monkey" do
    @r = Plivo::Response.new
    @r.append(Plivo::Speak.new("Hello Monkey"))
    @r.respond.should == '<Response><Speak>Hello Monkey</Speak></Response>'
  end

  it "should say hello monkey and loop 3 times" do
    @r = Plivo::Response.new
    @r.append(Plivo::Speak.new("Hello Monkey", :loop => 3))
    @r.respond.should == '<Response><Speak loop="3">Hello Monkey</Speak></Response>'
  end

  it "should say have a woman say hello monkey and loop 3 times" do
    @r = Plivo::Response.new
    @r.append(Plivo::Speak.new("Hello Monkey", :voice => 'woman'))
    @r.respond.should == '<Response><Speak voice="woman">Hello Monkey</Speak></Response>'
  end

  it "should say have a woman say hello monkey and loop 3 times and be in french" do
    @r = Plivo::Response.new
    @r.append(Plivo::Speak.new("Hello Monkey", :language => 'fr'))
    @r.respond.should == '<Response><Speak language="fr">Hello Monkey</Speak></Response>'
  end

  it "convenience method: should say have a woman say hello monkey and loop 3 times and be in french" do
    @r = Plivo::Response.new
    @r.addSpeak "Hello Monkey", :language => 'fr'
    @r.respond.should == '<Response><Speak language="fr">Hello Monkey</Speak></Response>'
  end

  it "should raises exceptions for wrong appending" do
    @r = Plivo::Response.new
    @s = @r.append(Plivo::Speak.new("Hello Monkey"))
    bad_append @s
  end

  it "add attribute" do
    @r = Plivo::Speak.new
    @r.set :crazy => 'delicious'
    @r.respond.should == '<Speak crazy="delicious"></Speak>'
  end

end

describe Plivo::Play do
  include PlivoExampleHelperMethods

  it "should play hello monkey" do
    @r = Plivo::Response.new
    @r.append(Plivo::Play.new("Hello Monkey.mp3"))
    @r.respond.should == '<Response><Play>Hello Monkey.mp3</Play></Response>'
  end

  it "should play hello monkey" do
    @r = Plivo::Response.new
    @r.append(Plivo::Play.new("Hello Monkey.mp3", :loop => '3'))
    @r.respond.should == '<Response><Play loop="3">Hello Monkey.mp3</Play></Response>'
  end

  it "convenience method: should play hello monkey" do
    @r = Plivo::Response.new
    @r.addPlay "Hello Monkey.mp3", :loop => '3'
    @r.respond.should == '<Response><Play loop="3">Hello Monkey.mp3</Play></Response>'
  end

  it "should raises exceptions for wrong appending" do
    @r = Plivo::Response.new
    @s = @r.append(Plivo::Play.new("Hello Monkey.mp3", :loop => '3'))
    bad_append @s
  end

  it "add attribute" do
    @r = Plivo::Play.new
    @r.set :crazy => 'delicious'
    @r.respond.should == '<Play crazy="delicious"></Play>'
  end

end

describe Plivo::Record do
  include PlivoExampleHelperMethods

  it "should record" do
    @r = Plivo::Response.new
    @r.append(Plivo::Record.new())
    @r.respond.should == '<Response><Record></Record></Response>'
  end

  it "should record with an action and a get method" do
    r = Plivo::Response.new
    r.append(Plivo::Record.new(:action => "example.com", :method => 'GET'))
    r.respond.should == '<Response><Record method="GET" action="example.com"></Record></Response>'
  end

  it "should record with an maxlength, finishonkey, and timeout" do
    r = Plivo::Response.new
    r.append(Plivo::Record.new(:timeout => "4", :finishOnKey => '#', :maxLength => "30"))
    r.respond.should == '<Response><Record timeout="4" finishOnKey="#" maxLength="30"></Record></Response>'
  end

  it "should record with a transcribe and transcribeCallback" do
    r = Plivo::Response.new
    r.append(Plivo::Record.new(:transcribeCallback => 'example.com'))
    r.respond.should == '<Response><Record transcribeCallback="example.com"></Record></Response>'
  end

  it "convenience methods: should record with a transcribe and transcribeCallback" do
    r = Plivo::Response.new
    r.addRecord :transcribeCallback => 'example.com'
    r.respond.should == '<Response><Record transcribeCallback="example.com"></Record></Response>'
  end

  it "should raise exceptions for wrong appending" do
    @r = Plivo::Response.new
    @s = @r.append(Plivo::Record.new())
    bad_append @s
  end

  it "add attribute" do
    @r = Plivo::Record.new
    @r.set :crazy => 'delicious'
    @r.respond.should == '<Record crazy="delicious"></Record>'
  end

end


describe Plivo::Redirect do
  include PlivoExampleHelperMethods

  it "should redirect" do
    @r = Plivo::Response.new
    @r.append(Plivo::Redirect.new())
    @r.respond.should == '<Response><Redirect></Redirect></Response>'
  end

  it "should redirect to a url via POST" do
    @r = Plivo::Response.new
    @r.append(Plivo::Redirect.new("example.com", :method => "POST"))
    @r.respond.should == '<Response><Redirect method="POST">example.com</Redirect></Response>'
  end

  it "convenience: should redirect to a url via POST" do
    @r = Plivo::Response.new
    @r.addRedirect "example.com", :method => "POST"
    @r.respond.should == '<Response><Redirect method="POST">example.com</Redirect></Response>'
  end

  it "should raises exceptions for wrong appending" do
    @r = Plivo::Response.new
    @s = @r.append(Plivo::Redirect.new())
    bad_append @s
  end

  it "add attribute" do
    @r = Plivo::Redirect.new
    @r.set :crazy => 'delicious'
    @r.respond.should == '<Redirect crazy="delicious"></Redirect>'
  end


end

describe Plivo::Hangup do
  include PlivoExampleHelperMethods

  it "should redirect" do
    @r = Plivo::Response.new
    @r.append(Plivo::Hangup.new())
    @r.respond.should == '<Response><Hangup></Hangup></Response>'
  end

  it "convenience: should Hangup to a url via POST" do
    @r = Plivo::Response.new
    @r.addHangup
    @r.respond.should == '<Response><Hangup></Hangup></Response>'
  end

  it "should raises exceptions for wrong appending" do
    @r = Plivo::Response.new
    @s = @r.append(Plivo::Hangup.new())
    bad_append @s
  end

  it "add attribute" do
    @r = Plivo::Hangup.new
    @r.set :crazy => 'delicious'
    @r.respond.should == '<Hangup crazy="delicious"></Hangup>'
  end

end

describe Plivo::Sms do
  include PlivoExampleHelperMethods

  it "should send a sms message" do
    @r = Plivo::Response.new
    @r.append(Plivo::Sms.new("Hello, World"))
    @r.respond.should == '<Response><Sms>Hello, World</Sms></Response>'
  end

  it "convenience: should send a sms message" do
    @r = Plivo::Response.new
    @r.addSms "Hello, World"
    @r.respond.should == '<Response><Sms>Hello, World</Sms></Response>'
  end

  it "should raises exceptions for wrong appending" do
    @r = Plivo::Response.new
    @s = @r.append(Plivo::Sms.new("Hello World"))
    bad_append @s
  end

  it "should send sms to to and from from with status callback" do
    @r = Plivo::Response.new
    @r.append(Plivo::Sms.new("Hello, World", :to => 1231231234,
      :from => 3453453456, :statusCallback => "example.com?id=34&action=hey"))
    @r.respond.should == '<Response><Sms from="3453453456" to="1231231234" statusCallback="example.com?id=34&amp;action=hey">Hello, World</Sms></Response>'
  end


  it "add attribute" do
    @r = Plivo::Sms.new
    @r.set :foo => 'bar'
    @r.respond.should == '<Sms foo="bar"></Sms>'
  end

end

describe Plivo::Wait do
  include PlivoExampleHelperMethods

  it "should redirect" do
    @r = Plivo::Response.new
    @r.append(Plivo::Wait.new())
    @r.respond.should == '<Response><Wait></Wait></Response>'
  end

  it "convenience: should Wait to a url via POST" do
    @r = Plivo::Response.new
    @r.addWait :length => '4'
    @r.respond.should == '<Response><Wait length="4"></Wait></Response>'
  end

  it "should raises exceptions for wrong appending" do
    @r = Plivo::Response.new
    @s = @r.append(Plivo::Wait.new())
    bad_append @s
  end

  it "add attribute" do
    @r = Plivo::Wait.new
    @r.set :crazy => 'delicious'
    @r.respond.should == '<Wait crazy="delicious"></Wait>'
  end

end

describe Plivo::Dial do
  include PlivoExampleHelperMethods

  it "should redirect" do
    @r = Plivo::Response.new
    @r.append(Plivo::Dial.new("1231231234"))
    @r.respond.should == '<Response><Dial>1231231234</Dial></Response>'
  end

  it "convenience: should Hangup to a url via POST" do
    @r = Plivo::Response.new
    @r.addDial
    @r.respond.should == '<Response><Dial></Dial></Response>'
  end

  it "add a number to a dial" do
    @r = Plivo::Response.new
    @d = @r.append(Plivo::Dial.new())
    @d.append(Plivo::Number.new("1231231234"))
    @r.respond.should == '<Response><Dial><Number>1231231234</Number></Dial></Response>'
  end

  it "convenience: add a number to a dial" do
    @r = Plivo::Response.new
    @d = @r.addDial
    @d.addNumber "1231231234"
    @r.respond.should == '<Response><Dial><Number>1231231234</Number></Dial></Response>'
  end


  it "add a conference to a dial" do
    @r = Plivo::Response.new
    @r.append(Plivo::Conference.new("MyRoom"))
    @r.respond.should == '<Response><Conference>MyRoom</Conference></Response>'
  end


  it "convenience: add a conference to a dial" do
    @r = Plivo::Response.new
    @r.addConference "MyRoom"
    @r.respond.should == '<Response><Conference>MyRoom</Conference></Response>'
  end

  it "add attribute" do
    @r = Plivo::Dial.new
    @r.set :crazy => 'delicious'
    @r.respond.should == '<Dial crazy="delicious"></Dial>'
  end

  it "bad append" do
    verb = Plivo::Dial.new
    lambda {verb.append(Plivo::Response)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Speak)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Play)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::GetDigits)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Record)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Redirect)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Hangup)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Wait)}.should raise_error(ArgumentError)
  end

end

describe Plivo::GetDigits do
  include PlivoExampleHelperMethods

  it "should redirect" do
    @r = Plivo::Response.new
    @r.append(Plivo::GetDigits.new("1231231234"))
    @r.respond.should == '<Response><GetDigits>1231231234</GetDigits></Response>'
  end

  it "convenience: should Hangup to a url via POST" do
    @r = Plivo::Response.new
    @r.addGetDigits
    @r.respond.should == '<Response><GetDigits></GetDigits></Response>'
  end

  it "add a number to a GetDigits" do
    @r = Plivo::Response.new
    @g = @r.append(Plivo::GetDigits.new)
    @g.append(Plivo::Speak.new("Hello World"))
    @g.append(Plivo::Play.new("Hello World.mp3"))
    @g.append(Plivo::Wait.new)
    @r.respond.should == '<Response><GetDigits><Speak>Hello World</Speak><Play>Hello World.mp3</Play><Wait></Wait></GetDigits></Response>'
  end

  it "convenience: add a number to a GetDigits" do
    @r = Plivo::Response.new
    @g = @r.addGetDigits
    @g.addSpeak "Hello World"
    @g.addPlay "Hello World.mp3"
    @g.addWait
    @r.respond.should == '<Response><GetDigits><Speak>Hello World</Speak><Play>Hello World.mp3</Play><Wait></Wait></GetDigits></Response>'
  end

  it "add attribute" do
    @r = Plivo::GetDigits.new
    @r.set :crazy => 'delicious'
    @r.respond.should == '<GetDigits crazy="delicious"></GetDigits>'
  end

  it "bad append" do
    verb = Plivo::GetDigits.new
    lambda {verb.append(Plivo::Response)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::GetDigits)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Record)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Redirect)}.should raise_error(ArgumentError)
    lambda {verb.append(Plivo::Hangup)}.should raise_error(ArgumentError)
  end

end

describe Plivo::Utils do

  it "check a signed sinature" do

    # This is the signature we expect for the key, url, and params below
    expected_sig = 'Ma7fvTryuU51vDGO2IT5/KhivpI='

    # this is the secret key for your account
    AuthToken = 'a1b2c3d4'
    utils = Plivo::Utils.new("34", AuthToken);
    # this is the url that twilio requested
    url = 'http://yourserver.com/twilio/index.php?id=12345&encodedtext=hello+world'

    # these are the post params twilio sent in its request
    params = Hash.new
    params['second_post_param'] = 'world'
    params['first_post_param'] = 'hello'

    # sort the params alphabetically, and append the key and value of each to the url
    signature = utils.validateRequest(expected_sig, url, params)

    # calculate the hmacsha1 signature of the data using the key and return it in base64 format
    signature.should == true

  end

end
