# TerminDe

Simple Termin cancelation monitoring for the Berliner offices :eyeglasses:

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'termin_de'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install termin_de

## Usage

```
Usage: termin [options]
    -b, --before=<date>              Trigger only on date earlier than given date
    -c, --execute=<command>          Run given command with %{date} and %{link} replacements
    -s, --service=<id>               Id of the requested service
    -u, --burgeramt=<id>             Id of the burgeramt
        --dry-run                    Run on saved examples
        --version                    Display the version
```

## Examples

Basically you can sit down, relax, brew some :coffee: and watch at output.

    $ termin_de --before 2020-09-29
    $ I, [2020-09-01 20:24:52#30369]  INFO -- : Looking for available slots before 2020-09-29
    $ I, [2020-09-01 20:24:53#30369]  INFO -- : Nothing ...
    $ I, [2020-09-01 20:25:53#30369]  INFO -- : Looking for available slots before 2020-09-29
    $ I, [2020-09-01 20:25:53#30369]  INFO -- : Found new [2020-09-01] → https://service.berlin.de/terminvereinbarung/termin/tag.php?termin=1&dienstleisterlist=122243,122238,122260,122262&anliegen[]=120703&herkunft=http%3A%2F%2Fservice.berlin.de%2Fdienstleistung%2F120703%2F

It is also possible to specify the service you are looking for. Maybe you want to perform a business registration.

Be aware that not all offices can process all services.

    $ termin_de --before 2020-09-29 --service 121921

Or you can define your own complex handler and maybe logfile.

Available variables are `%{date}` and `%{link}`.

    $ export EMAIL_TEMPLATE="From: termin@monitor\nTo: your@gmail.com\nContent-Type: text/html\n\n\n<html><body><a href=\"%{link}\">%{date}</a></body></html>"
    $ termin_de --before 2015-10-23 -c "echo '$EMAIL_TEMPLATE' | sendmail your@gmail.com" > logs/output.log

Use `--dry-run` option for local sandbox. Sample has 2 available dates `2015-11-09` and `2015-11-05`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Strech/termin_de.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
