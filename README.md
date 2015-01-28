# Pivo

## Usage

Add [Pivotal Trackert](http://www.pivotaltracker.com/) API token to $HOME/.pivo.yml

```yaml
token: aaaaaaaaaaaaaaaa
```

### Listing projects

```shell
$ pivo projects
```

### Listing stories

```shell
$ pivo stories PROJECT_NAME
```

#### with peco

```zsh
function pivo-open() {
  local url="$(pivo stories $1 | peco --query "$LBUFFER" | awk '{print $NF}')"
  open ${url}
}
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pivo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pivo

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/pivo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
