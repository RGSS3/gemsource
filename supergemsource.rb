require 'net/http'
require 'OpenSSL'
def srclist
  `gem source list`.scan(/^http.*/).to_a
end
def remove x
  system "gem source -r #{x}"
end

def clear
  srclist.each{|x|
    remove x
  }    
end



def work?
  r = `gem spec -r rails 2>&1`
  !r[/No gem/] 
end



def gethttps(uri)
  url = URI(uri)
   http = Net::HTTP.new(url.host, url.port)
   http.use_ssl = true
   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
   request = Net::HTTP::Get.new(url.request_uri)
   response = http.request(request)
   response.body
end



def get(uri)
  url = URI(uri)
   http = Net::HTTP.new(url.host, url.port)
   request = Net::HTTP::Get.new(url.request_uri)
   response = http.request(request)
   response.body
end



def sanitize(a)
  a.gsub(/<[^>]*?>/, "").gsub("&#39", "'")
end



def pputs(a)
   puts "\e[1;31m* #{a}\e[0m"
end



def tryadd(a)
     pputs "try adding #{a}"
     system "gem source -a #{a}"
end



if work? && (!ARGV.include?("--force") && !ENV.include?("FORCE_SOURCE"))
  pputs "it seemed that it already works"
else
  pputs "reset source list"
  clear
  pputs "repairing"
  u = get("http://www.baidu.com/s?wd=ruby%20%E5%9B%BD%E5%86%85%E6%BA%90")
  visit = {}
  sanitize(u).scan(/https?:\/\/[^'" ]*/).each{|x|
    next if x[/baidu/] || x[/bdstatic\.com/] || x[/bdimg\.com/] || (!x[/ruby/] && !x[/gem/]) || x[/[&?]/]
    next if visit[x]
    visit[x] = 1
    tryadd (y=x.sub(/http[s]?/, "http"))
    if work?
       pputs "setting BUNDLER global mirror"
       system "bundler config --global mirror.https://rubygems.org " + y
       pputs "problem solved"
       pputs "#{y} is the source for you"
       exit!
   else
       remove y
   end
    tryadd (y=x.sub(/http[s]?/, "https"))
    if work?
       pputs "setting BUNDLER global mirror"
       system "bundler config --global mirror.https://rubygems.org " + y
       pputs "problem solved"
       pputs "#{y} is the source for you"
       exit!
   else
       remove y
   end

  }
 puts "problem unsolved"
end
