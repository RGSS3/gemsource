# gemsource

automatically looking and checking for gem source(especially for those behind GFW), type:

```shell
ruby -ropen-uri -e"puts open('http://codepad.org/CPe9wJuo/raw.rb', &:read)" | ruby
```

now it also sets bundler's mirror
so you can type(including windows) without interrupting:
```shell
ruby -ropen-uri -e"puts open('http://codepad.org/CPe9wJuo/raw.rb', &:read)" | ruby
gem install rails
rails new app
cd app
rails s
```

