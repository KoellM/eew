# EEW

## Installation
```sh
$ git clone 
$ rake install
```
## Usage
```ruby
require "eew"

email = ""
password = ""
terminal_id = ""

eew = EEW::Client.new(email, password, terminal_id)

eew.connect do |telegram, headers|
  if telegram # Telegram
    puts "Header: #{telegram.header}"
    puts "Body\n#{telegram.body}"
  else
    puts headers.data # Keep-Alive
  end
end
```