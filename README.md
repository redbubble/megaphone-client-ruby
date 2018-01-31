# Megaphone::Client

[![Build Status](https://badge.buildkite.com/9f4fdb370f5f295ee6bf3d68937b1be2d7cf9bf65b2c7b4213.svg?branch=master)](https://buildkite.com/redbubble/megaphone-client-ruby)
[![Build Status](https://travis-ci.org/redbubble/megaphone-client-ruby.svg?branch=master)](https://travis-ci.org/redbubble/megaphone-client-ruby)
[![Gem Version](https://badge.fury.io/rb/megaphone-client.svg)](https://badge.fury.io/rb/megaphone-client)
![Megaphone](https://img.shields.io/badge/Megaphone-2.0.0-blue.svg)

Send events to [Megaphone (private)](https://github.com/redbubble/Megaphone).

> **DISCLAIMER**: This is part of a currently private event broadcasting system called Megaphone. Please be aware that some links may lead to private repositories. Questions are welcome, though, and we're happy to help if you find a use for this gem, or get inspired by it!
>
> More of Megaphone could become public in the future, but there is currently no clear roadmap for it. -- [GB](https://github.com/gonzalo-bulnes)

## Getting Started

Add the gem to your `Gemfile`:

```ruby
# Gemfile

gem 'megaphone-client', '~> 1.0' # see semver.org
```

## Usage

In order to be as unobstrusive as possible, this client will append events to local files (e.g. `./work-updates.stream`) unless:

* the `MEGAPHONE_FLUENT_HOST` and `MEGAPHONE_FLUENT_PORT` environment variables are set.
* **or** the Fluentd host and port values are passed as arguments to the client's constructor

That behaviour ensures that unless you want to send events to the Megaphone [streams][stream], you do not need to [start Fluentd][megaphone-fluentd] at all.

[stream]: https://github.com/redbubble/megaphone#stream
[megaphone-fluentd]: https://github.com/redbubble/megaphone-fluentd-container

### Publishing events

1. Start Fluentd, the easiest way to do so is using a [`redbubble/megaphone-fluentd`][megaphone-fluentd] container

1. Create your event and publish it:

```ruby
# Configure a Megaphone client for your awesome service
client = Megaphone::Client.new({
  origin: 'my-awesome-service',
  host: 'localhost',
  port: '24224'
})

# Create an event
topic = 'work-updates'
subtopic = 'work-metadata-updated'
schema = 'https://github.com/redbubble/megaphone-event-type-registry/blob/master/streams/work-updates-schema-1.0.0.json'
partition_key = '1357924680' # the Work ID in this case
payload = { url: 'https://www.redbubble.com/people/wytrab8/works/26039653-toadally-rad' }

# Publish your event
client.publish!(topic, subtopic, schema, partition_key, payload)

# Note: the client will close the connection to Fluentd on exit, if you need to do it before that (unlikely), you can use Megaphone::Client#close method.

# See below for error handling instructions and examples.
```

## Error Handling

### Exceptions the client will raise

`publish!` can raise two exceptions if the underlying Fluentd
client library throws an error.

The most common is `MegaphoneMessageDelayWarning` which indicates
a transient failure occurred, but the message will probably be resent
later. See section on _[Internal buffering](#internal-buffering-upon-error)_ below for more details.

The second exception is `MegaphoneUnavailableError`, which is thrown
for all other errors. Note that these _may or may not_ also buffer
the message for later transmission. Unfortunately the underlying
client library does not make the distinction.

### Internal buffering upon error

Note that, in some cases, the client library will buffer failed messages
and attempt to resend them later. It will resend buffered messages in
the following cases:

* another message is sent
* the `close` method is called
* at exit (via an `at_exit` handler)

Applications that require fast handling of events should read the section
below on handling time-sensitive events and errors.

Because of this buffering, users of the library should not treat exceptions
as a definite reason to resend a message, as this may result in multiple
messages being eventually dispatched. However without in-depth knowledge
it can be hard to tell which exceptions are recoverable, and which indicate
some kind of catastrophic failure.

This author has confirmed that both connection failure and `ECONNRESET`
errors will result in buffering of messages.

If the internal buffer fills up, the buffer overflow handler will be called.

At exit, or when `client.close` is called, the buffer will be flushed.
If it cannot be flushed to the daemon, then the buffer overflow
handler will be called.

### Buffer overflow callback handler

Passing a lambda to the `:overflow_handler` will enable your application
to receive notifications of messages being lost. They can be lost in at
least two ways:

* Fluentd daemon has gone away, and internal client-side buffer exceeded
* process is shutting down, and fluent client library was unable to flush buffers
  to the daemon.

Production applications [MUST][rfc2119] handle this case, and raise an alert, if their
messages are considered important.

[rfc2119]: https://tools.ietf.org/html/rfc2119

```ruby
# Example usage:
my_handler = -> (*) {
  Rollbar.error("Megaphone/fluent messages lost due to buffer overflow")
}

logger = Megaphone::Client.new({
  origin: "my-app",
  overflow_handler: my_handler
})

begin
  logger.publish!(... event ...)
rescue Megaphone::Client::MegaphoneUnavailableError => e
  Rollbar.warning("Megaphone client error", e)
rescue Megaphone::Client::MegaphoneMessageDelayWarning => e
  Rollbar.info("Megaphone transient message delay", e)
end
```

### Handling time-sensitive events and errors

As long as an application is either short lived, or frequently sending messages,
then it will probably be fine with the usual behaviour, which is to flush
buffers at next send, or flush at exit.

Applications with time-sensitive, infrequent events, will need to find a
different strategy if errors have been raised during previous message publishing.

Unfortunately there is no means to do this with the underlying Ruby client
for Fluentd. It would require patches to the upstream code to expose a flush
method.

## Development

### Testing

```bash
# Run the entire test suite
rake

# Otherwise...
rake spec
```

## Credits

[![](doc/redbubble.png)][redbubble]

Megaphone::Client is maintained and funded by [Redbubble][redbubble].

[redbubble]: https://www.redbubble.com

## License

    Megaphone::Client
    Copyright (C) 2017 Redbubble

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
