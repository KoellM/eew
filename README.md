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
password = "" # 需要MD5
tid = ""

eew = EEW::Client.new(email, password, tid)

eew.connect do |headers, telegram|
  if headers.data? # Telegram
    puts "Header: #{telegram.header}"
    puts "Body\n#{telegram.body}"
  else
    puts headers.data # Keep-Alive
  end
end
```