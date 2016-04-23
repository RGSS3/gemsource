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
  r = `gem list -r y`
  r.strip != '' 
end

def get(uri)
  url = URI(uri)
   http = Net::HTTP.new(url.host, url.port)
   http.use_ssl = true
   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
   request = Net::HTTP::Get.new(url.request_uri)
   response = http.request(request)
   response.body
end
if work?
  puts "it seemed that it already works"
else
  puts "reset source list"
  clear
  puts "repairing"
  u = get("https://raw.githubusercontent.com/RGSS3/gemsource/master/source.lst")
  u.split("\n").each{|x|
     puts "* try adding #{x}"
     system "gem source -a #{x}"
  }
  if work?
    puts "done"
  else
    puts "problem unsolved"
  end
end


