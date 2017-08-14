Megaphone::Client
=================

[![Build Status](https://badge.buildkite.com/9f4fdb370f5f295ee6bf3d68937b1be2d7cf9bf65b2c7b4213.svg?branch=master)](https://buildkite.com/redbubble/megaphone-client-ruby)

Send events to Megaphone.

Getting Started
---------------

Add the gem to your `Gemfile`:

```ruby
# Gemfile

gem 'megaphone-client', '~> 0.2.0'
```

Usage
-----
The client will append events to local files unless a `MEGAPHONE_FLUENT_HOST` and `MEGAPHONE_FLUENT_PORT` environment variables are set.

To publish an event on Megaphone
```ruby
event_bus = Megaphone::Client.new({ origin: 'my-awesome-service' })

topic = :page_changes
subtopic = :product_pages
schema = 'http://www.github.com/redbuble/megaphone-event-type-registry/topics/cats'
partition_key = '1357924680'
payload = { url: 'https://www.redbubble.com/people/wytrab8/works/26039653-toadally-rad?grid_pos=1&p=mens-graphic-t-shirt&rbs=29c497ad-a976-42b8-aa40-0e218903c558&ref=shop_grid&style=mens' }

event_bus.publish!(topic, subtopic, schema, partition_key, payload)
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
