# BulletTrain::Release

An isolated layer for handling Bullet Train package releases in one place.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add bullet_train-release

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install bullet_train-release

## Usage

Navigate to the gem of your choice and run the following to release your gem:
```shell
# ⚠️ Running this command will push your changes to GitHub!
$ rake app:bullet_train:release

# If you just want to test run the logic and build
# the packages without pushing your changes, add `dry-run`
$ rake app:bullet_train:release[dry-run]
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bullet-train-co/bullet_train-release.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
