# TerminDe

Simple Termin monitoring :eyeglasses:

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
termin_de [options]
    -b, --before=<date>              Trigger only on date earlier than given date
    -c, --execute=<command>          Run given command with %{date} and %{link} replacements
        --dry-run                    Run on saved samples
        --version                    Display the version
```

Basically you can sit down, relax, brew some :hotbeverage: and watch at output.

    $ termin --before 2015-11-20
    $ I, [2015-09-21 00:28:47#45699]  INFO -- : Nothing ...
    $ I, [2015-09-21 00:28:48#46699]  INFO -- : Nothing ...
    $ I, [2015-09-21 00:28:49#47699]  INFO -- : Found new [2015-11-05] → https://service.berlin.de/terminvereinbarung/termin/termin.php?buergerID=&buergername=&OID=52900%2C54489%2C54574%2C50784%2C54637%2C50792%2C54536%2C54538%2C51456%2C54546%2C54540%2C54542%2C54544%2C54641%2C54033%2C49321%2C49309%2C49334%2C49343%2C54566%2C54568%2C54562%2C54560%2C45160%2C54647%2C54570%2C53880%2C54572%2C53908%2C53907%2C53447%2C53448%2C53433%2C53434%2C53765%2C53766%2C54550%2C54552%2C54554%2C54477%2C54479%2C54481%2C54483%2C54485%2C54524%2C54611%2C54526%2C54614%2C51956%2C54607%2C51627%2C54593%2C54520%2C54495%2C54325%2C54634%2C54601%2C54624%2C52093%2C54230%2C54232%2C54234%2C54206%2C54208%2C54210%2C54212%2C54156%2C54158%2C51543%2C51544%2C51545%2C51521%2C51522%2C51523&datum=2015-11-05&behoerde=&slots=&anliegen%5B%5D=120686&herkunft=%2Fterminvereinbarung%2F

Or you can define your own complex handler and maybe logfile. Available variables are `%{date}` and `%{link}`.

    $ export EMAIL_TEMPLATE="From: termin@monitor\nTo: your@gmail.com\nContent-Type: text/html\n\n\n<html><body><a href=\"%{link}\">%{date}</a></body></html>"
    $ termin --before 23-10-2015 -c "echo '$EMAIL_TEMPLATE' | sendmail your@gmail.com > logs/output.log

Use `--dry-run` option for local sandbox. Sample has 2 available dates 2015-11-09 and 2015-11-05.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Strech/termin_de.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

