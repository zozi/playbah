# Playbah

Easily be able to save output of scripts, or commands and notify your team of actions such as deploys, infrastructure changes, automated jobs.

## Installation

Add this line to your application's Gemfile:

    gem 'playbah'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install playbah

## Usage

```ruby
url = Playbah.capture(file_path, "my outputstring")
gist_url = Playbah.capture("my complete output string")
Playbah.send_message("#{command} - completed with log: #{gist_url}")
```

## Contributing

1. Send a PR on a feature branch with nice tidy commits.
