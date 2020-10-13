# Deprecated

This is no longer needed: https://github.com/redis/redis-rb/issues/550#issuecomment-703248932

## redis-elasticache

Adds support for Elasticache failover to the Ruby driver of the redis-rb gem. Elasticache replication groups can transparently promote a new node to master, but TCP connections are persistent. This patch makes READONLY error messages from Redis get handled like a connection error instead of a command error so redis-rb will self heal the connection and run the command against the new master node.


## Installation

Add this line to your application's Gemfile:

In your gemfile

```ruby
gem 'redis-elasticache'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis-elasticache

## Usage

In an environment that is backed by an Elasticache Replication Group.

```ruby
require 'redis/elasticache/failover'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/craigmcnamara/redis-elasticache. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
