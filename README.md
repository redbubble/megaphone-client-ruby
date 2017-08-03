Megaphone::Client
=================

[![Build Status](https://badge.buildkite.com/9f4fdb370f5f295ee6bf3d68937b1be2d7cf9bf65b2c7b4213.svg?branch=master)](https://buildkite.com/redbubble/megaphone-client-ruby)

Send events to Megaphone.

Getting Started
---------------

Add the gem to your `Gemfile`:

```ruby
# Gemfile

gem 'megaphone-client', '~> 0.1.0'
```

Usage
-----

To publish an event on Megaphone
```ruby
event_bus = Megaphone::Client.new({ origin: 'my-awesome-service' })

topic = :page_changes
subtopic = :product_pages
payload = { url: 'https://www.redbubble.com/people/wytrab8/works/26039653-toadally-rad?grid_pos=1&p=mens-graphic-t-shirt&rbs=29c497ad-a976-42b8-aa40-0e218903c558&ref=shop_grid&style=mens' }

event_bus.publish!(topic, subtopic, payload)
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

    All rights reserved.
