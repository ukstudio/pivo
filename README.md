# Pivo

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
$ pivo stories all PROJECT_NAME
$ pivo stories all PROJECT_NAME --status unstarted # filtering by status
```

### Listing mywork


```shell
$ pivo stories all PROJECT_NAME --mywork ukstudio
$ pivo stories all PROJECT_NAME --mywork ukstudio --status unstarted # filtering by status
```

##### with peco

```zsh
function pivo-open() {
  local url="$(pivo stories all PROJECT_NAME --mywork ukstudio $1 | peco --query "$LBUFFER" | awk '{print $NF}')"
  open ${url}
}
```

### Create new story

```shell
$ pivo stories add PROJECT_NAME --name 'new story name' --description 'new story description'
```

## Contributing

1. Fork it ( https://github.com/ukstudio/pivo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
