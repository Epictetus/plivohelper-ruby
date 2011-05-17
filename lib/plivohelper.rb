
# @author Plivo
module Plivo
  require 'net/http'
  require 'net/https'
  require 'uri'
  require 'cgi'
  require 'rubygems'
  require 'builder'
  require 'openssl'
  require 'base64'


  # Plivo REST Helpers
  class Rest

    #@param [String, String] Your Plivo SID/ID and Auth Token
    #@return [Object] Rest object
    def initialize(url, id, token)
      @id = id
      @token = token
      @url = url
    end

    #sends a request and gets a response from the Plivo REST API
    #
    #@param [String, String, Hash]
    #path, the URL (relative to the endpoint URL, after the /v1
    #method, the HTTP method to use, defaults to POST
    #vars, for POST or PUT, a dict of data to send
    #
    #@return Plivo response XML
    #@raises [ArgumentError] Invalid path parameter
    #@raises [NotImplementedError] Method given is not implemented
    def request(path, method=nil, vars={})
      if !path || path.length < 1
          raise ArgumentError, 'Invalid path parameter'
        end
        if method && !['GET', 'POST', 'DELETE', 'PUT'].include?(method)
          raise NotImplementedError, 'HTTP %s not implemented' % method
        end

        if path[0, 1] == '/'
          uri = @url + path
        else
          uri = @url + '/' + path
      end

      return fetch(uri, vars, method)
    end

    #enocde the parameters into a URL friendly string
    #
    #@param [Hash] URL key / values
    #@return [String] Encoded URL
    protected
    def urlencode(params)
      params.to_a.collect! \
        { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join("&")
    end

    # Create the uri for the REST call
    #
    #@param [String, Hash] Base URL and URL parameters
    #@return [String] URI for the REST call
    def build_get_uri(uri, params)
      if params && params.length > 0
        if uri.include?('?')
          if uri[-1, 1] != '&'
            uri += '&'
          end
            uri += urlencode(params)
          else
            uri += '?' + urlencode(params)
        end
      end
      return uri
    end

    # Returns a http request for the given url and parameters
    #
    #@param [String, Hash, String] Base URL, URL parameters, optional METHOD
    #@return [String] URI for the REST call
    def fetch(url, params, method=nil)
      if method && method == 'GET'
        url = build_get_uri(url, params)
      end
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      if method && method == 'GET'
        req = Net::HTTP::Get.new(uri.request_uri)
      elsif method && method == 'DELETE'
        req = Net::HTTP::Delete.new(uri.request_uri)
      elsif method && method == 'PUT'
        req = Net::HTTP::Put.new(uri.request_uri)
        req.set_form_data(params)
      else
        req = Net::HTTP::Post.new(uri.request_uri)
        req.set_form_data(params)
      end
      req.basic_auth(@id, @token)

      return http.request(req)
    end

    # REST Call Helper
    def call(call_params)
      path = '/v0.1/Call/'
      method = 'POST'
      return request(path, method, call_params)
    end

    # REST Bulk Call Helper
    def bulk_call(call_params)
      path = '/v0.1/BulkCalls/'
      method = 'POST'
      return request(path, method, call_params)
    end

    # REST Transfer Live Call Helper
    def transfer_call(call_params)
      path = '/v0.1/TransferCall/'
      method = 'POST'
      return request(path, method, call_params)
    end

    # REST Hangup Live Call Helper
    def hangup_call(call_params)
      path = '/v0.1/HangupCall/'
      method = 'POST'
      return request(path, method, call_params)
    end

    # REST Hangup All Live Calls Helper
    def hangup_all_calls()
      path = '/v0.1/HangupAllCalls/'
      method = 'POST'
      return request(path, method)
    end

    # REST Schedule Hangup Helper
    def schedule_hangup(call_params)
      path = '/v0.1/ScheduleHangup/'
      method = 'POST'
      return request(path, method, call_params)
    end

    # REST Cancel a Scheduled Hangup Helper
    def cancel_scheduled_hangup(call_params)
      path = '/v0.1/CancelScheduledHangup/'
      method = 'POST'
      return request(path, method, call_params)
    end
  end

  # RESTXML Response Helpers
  module Grammar
    module ClassMethods
      @attributes = []
      @allowed_grammar = []
      attr_accessor :attributes

      def allowed_grammar(*grammar)
        return @allowed_grammar if grammar == []
        @allowed_grammar = [] if @allowed_grammar.nil?
        grammar.each do |grammar_element|
          cleaned_grammar_element = grammar_element.to_s.slice(0,1).capitalize + grammar_element.to_s.slice(1..-1)
          @allowed_grammar << cleaned_grammar_element
        end
        @allowed_grammar = @allowed_grammar.uniq
      end

      def attributes(*attrs)
        return @attributes if attrs == []
        @attributes = [] if @attributes.nil?
        @attributes = (@attributes + attrs).uniq
        attr_accessor(*@attributes)
        @attributes
      end
    end

    def attributes
      self.class.attributes
    end

    #test if a given grammar element is allowed to be nested
      #
      #@param [Object] Grammar to be appended
      #@return [true, false]
    def allowed?(grammar_element)
      self.class.allowed_grammar.nil? ? false : self.class.allowed_grammar.include?(grammar_element.class.name.split('::')[1])
    end

    #initialize a plivo response object
      #
      #@param [String, Hash] Body of the grammar, and a hash of the attributes
      #@return [Object] Plivo grammar object
      #
      #@raises [ArgumentError] Invalid Argument
    def initialize(body = nil, params = {})
      @children = []
      if body.class == String
        @body = body
      else
        @body = nil
        params = body || {}
      end
      params.each do |k,v|
        if !self.class.attributes.nil? && self.class.attributes.include?(k)
          send(k.to_s+"=",v)
        else
          raise ArgumentError, "Attribute Not Supported"
        end
      end
    end

    #set an attribute key / value
      #no error checking
      #
      #@param [Hash] Hash of options
      #@return void
    def set(params = {})
      params.each do |k,v|
        self.class.attributes k.to_s
        send(k.to_s+"=",v)
      end
    end

    #output valid Plivo markup
      #
      #@param [Hash] Hash of options
      #@return [String] Plivo Markup (in XML)
    def respond(opts = {})
      opts[:builder]  ||= Builder::XmlMarkup.new(:indent => opts[:indent])
      b = opts[:builder]
      attrs = {}
      attributes.each {|a| attrs[a] = send(a) unless send(a).nil? } unless attributes.nil?

      if @children and @body.nil?
        b.__send__(self.class.to_s.split(/::/)[-1], attrs) do
          @children.each {|e|e.respond( opts.merge(:skip_instruct => true) )}
        end
      elsif @body and @children == []
        b.__send__(self.class.to_s.split(/::/)[-1], @body, attrs)
      else
        raise ArgumentError, "Cannot have children and a body at the same time"
      end
    end

    #output valid Plivo markup encoded for inclusion in a URL
      #
      #@param []
      #@return [String] URL encoded Plivo Markup (XML)
    def asURL()
      CGI::escape(self.respond)
    end

    def append(grammar_element)
      if(allowed?(grammar_element))
        @children << grammar_element
        @children[-1]
      else
        raise ArgumentError, "Grammar Not Supported"
      end
    end

    # Grammar Convenience Methods
    def addSpeak(string_to_speak = nil, opts = {})
      append Plivo::Speak.new(string_to_speak, opts)
    end

    def addPlay(file_to_play = nil, opts = {})
      append Plivo::Play.new(file_to_play, opts)
    end

    def addGetDigits(opts = {})
      append Plivo::GetDigits.new(opts)
    end

    def addRecord(opts = {})
      append Plivo::Record.new(opts)
    end

    def addDial(number = nil, opts = {})
      append Plivo::Dial.new(number, opts)
    end

    def addRedirect(url = nil, opts = {})
      append Plivo::Redirect.new(url, opts)
    end

    def addWait(opts = {})
      append Plivo::Wait.new(opts)
    end

    def addHangup
      append Plivo::Hangup.new
    end

    def addNumber(number, opts = {})
      append Plivo::Number.new(number, opts)
    end

    def addConference(room, opts = {})
      append Plivo::Conference.new(room, opts)
    end

    def addSms(msg, opts = {})
      append Plivo::Sms.new(msg, opts)
    end

    def addRecordSession(opts = {})
      append Plivo::RecordSession.new(opts)
    end

    def addPreAnswer(opts = {})
      append Plivo::PreAnswer.new(opts)
    end

    def addScheduleHangup(opts = {})
      append Plivo::ScheduleHangup.new(opts)
    end

    def addReject(opts = {})
      append Plivo::Reject.new(opts)
    end

  end

  class Speak
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    attributes :voice, :language, :loop
  end

  class Play
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    attributes :loop
  end

  class GetDigits
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    attributes :action, :method, :timeout, :finishOnKey, :numDigits, :tries, :playBeep, :validDigits, :invalidDigitsSound
    allowed_grammar :play, :speak, :wait
  end

  class Record
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    attributes :action, :method, :timeout, :finishOnKey, :maxLength, :transcribe, :transcribeCallback, :playBeep, :format, :prefix, :filePath
  end

  class Dial
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    attributes :action, :method, :timeout, :hangupOnStar, :timeLimit, :callerId, :confirmSound, :confirmKey, :dialMusic
    allowed_grammar :number
  end

  class Redirect
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    attributes :method
  end

  class Wait
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    attributes :length
  end

  class Hangup
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
  end

  class Number
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    attributes :sendDigits, :url, :gateways, :gatewayCodecs, :gatewayTimeouts, :gatewayRetries, :extraDialString
  end

  class Conference
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    attributes :muted, :beep, :startConferenceOnEnter, :endConferenceOnExit, :waitUrl, :waitMethod
  end

  class Sms
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    attributes :to, :from, :statusCallback, :action, :method
  end

  class RecordSession
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    attributes :format, :prefix, :filePath
  end

  class ScheduleHangup
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    attributes :time
  end

  class PreAnswer
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    allowed_grammar :speak, :play, :getDigits
  end

  class Reject
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    attributes :reason
  end

  class Response
    extend Plivo::Grammar::ClassMethods
    include Plivo::Grammar
    allowed_grammar :speak, :play, :getDigits, :record, :dial, :redirect, :wait, :hangup, :sms, :recordSession, :preAnswer, :scheduleHangup, :conference
  end

  # Plivo Utility function and Request Validation class
  class Utils

    #initialize a plivo utils abject
    #
    #@param [String, String] Your Plivo SID/ID and Auth Token
    #@return [Object] Utils object
    def initialize(id, token)
      @id = id
      @token = token
    end

    def validateRequest(signature, url, params = {})
      sorted_post_params = params.sort
      data = url
      sorted_post_params.each do |pkey|
        data = data + pkey[0]+pkey[1]
      end
      digest = OpenSSL::Digest::Digest.new('sha1')
      expected = Base64.encode64(OpenSSL::HMAC.digest(digest, @token, data)).strip
      return expected == signature
    end
  end

end
