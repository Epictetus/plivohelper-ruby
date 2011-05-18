Plivo Ruby Helper Library
---------------------------

Description
~~~~~~~~~~~

The Plivo Ruby helper simplifies the process of making REST calls and generating RESTXML.

See `Plivo Documentation <http://www.plivo.org/documentation/>`_ for more information.


Installation
~~~~~~~~~~~~~

**Gemcutter:**
    $ sudo gem install plivohelper


Manual Installation
~~~~~~~~~~~~~~~~~~~~

To use the rake command to build the gem and

**Download the source and run:**
    $ sudo gem install /path/to/plivohelper/gem

to finish the installation


Usage
~~~~~

To use the Plivo helper library, As shown in example-call.rb,
you will need to specify the ACCOUNT_ID and ACCOUNT_TOKEN, before you can make REST requests.

Before you run the examples, you should have Plivo Running along with FreeSWITCH Running and a user 1000 logged in.

See `Plivo Documentation <http://www.plivo.org/documentation/>`_ for more information.



Files
~~~~~

**lib/plivohelper.rb:** include this library in your code

**examples/example-call.rb:** example usage of REST Call

**examples/example-bulkcalls.rb:** example usage of REST Bulk Calls

**examples/example-transfercall.rb:** example usage of REST Transfer Live Call

**examples/example-hangupcall.rb:** example usage of REST Hangup Live Call

**examples/example-xml.rb:** example usage of the RESTXML generator

**examples/example-utils.rb:** example usage of utilities


Credits
-------

Plivo Ruby Helper Library is derived from `Twilio Ruby Helper <https://github.com/twilio/twilio-ruby>`_


License
-------

The Plivo Ruby Helper Library is distributed under the MIT License
