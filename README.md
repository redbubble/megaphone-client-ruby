Megaphone::Client
=================

[![Build Status](https://badge.buildkite.com/9f4fdb370f5f295ee6bf3d68937b1be2d7cf9bf65b2c7b4213.svg?branch=master)](https://buildkite.com/redbubble/megaphone-client-ruby)

Send events to Megaphone.

Getting Started
---------------

Add the gem to your `Gemfile`:

```ruby
# Gemfile

gem 'megaphone-client', '~> 0.3.0'
```

Usage
-----

In order to be as unobstrusive as possible, this client will append events to local files (e.g. `./work-updates.stream`) unless:

- the `MEGAPHONE_FLUENT_HOST` and `MEGAPHONE_FLUENT_PORT` environment variables are set.
- **or** the Fluentd host and port values are passed as arguments to the client's constructor

That behaviour ensures that unless you want to send events to the Megaphone [streams][stream], you do not need to [start Fluentd][megaphone-fluentd] at all.

  [stream]: https://github.com/redbubble/com/megaphone#stream
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
```

Credits
-------

[![](doc/redbubble.png)][redbubble]

Megaphone::Client is maintained and funded by [Redbubble][redbubble].

  [redbubble]: https://www.redbubble.com

License
-------

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
