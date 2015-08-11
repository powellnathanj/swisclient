require "uri"
require "json"
require "openssl"
require "net/http"

class Swisclient

  def initialize(host, port, username, password)
    @host       = host
    @port       = port
    @username   = username
    @password   = password
    @querypath  = "/SolarWinds/InformationService/v3/Json/Query"
    @crudpath   = ""
    @usessl     = true
    @sslverify  = OpenSSL::SSL::VERIFY_NONE
  end

  # This is a raw query function, no syntactical sugar
  # The query should be a ruby hash similar to:
  # {"query" => "SELECT NodeID FROM Orion.Nodes WHERE NodeName=@name", "parameters" => {"name" => "myhost.mydomain.com"}}
  def query(query)
    do_http_request(@querypath, query).body.to_s
  end
 
  # Private method for creating http objects and executing requests against the API
  def do_http_request(path, payload)
    uri = URI.parse(@host + ":" + @port + "#{path}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = @usessl
    http.verify_mode = @sslverify

    request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
    request.body = payload.to_json
    request.basic_auth(@username.to_s, @password.to_s)

    return http.request(request)
  end

  # Methods for typical operations
  def query_by_nodename(name)
  end

  def query_by_nodeid(nodeid)
  end
  
  def query_by_ipaddress(ipaddress)
  end

  private :build_http_request

end
