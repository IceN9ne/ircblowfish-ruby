# IrcBlowfish

A Ruby module for encrypting and decrypting IRC Blowfish ECB/CBC messages.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ircblowfish'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ircblowfish

## Usage

```ruby
message = '+OK '
key = 'ecb:AWeakKey'
plaintext = IrcBlowfish.decrypt message, key

text = 'This is a test string'
key = 'cbc:ABetter?Key'
message = IrcBlowfish.encrypt text, key
```

To define an ECB key, prefix it with either `ecb:` or `old:`. CBC keys can be prefixed with `cbc:` or are assumed to be CBC with no prefix.

You can explicitly call `encrypt_ecb` or `encrypt_cbc`, but just calling `encrypt` will automatically figure out which to use based on the key passed.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/IceN9ne/ircblowfish.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

