require "uri"
require "json"
require "openssl"
require "net/http"

class Swisclient

  def initialize(host, port, username, password)
    @host = host
    @port = port
    @username = username
    @password = password
    @querypath = "/SolarWinds/InformationService/v3/Json/Query"
    @crudpath = ""
    @initheader = {'Content-Type' =>'application/json'}
    @usessl = true
  end

  # This is a raw query function, no syntactical sugar
  # The query should be a ruby hash similar to:
  # {"query" => "SELECT NodeID FROM Orion.Nodes WHERE NodeName=@name", "parameters" => {"name" => "myhost.mydomain.com"}}
  def query(query)
    http_client, uri = build_http_request(@querypath)
    request = Net::HTTP::Post.new(uri.request_uri, initheader = @initheader)
    request.body = query.to_json
    request.basic_auth(@username.to_s, @password.to_s)
    http_client.request(request).body.to_s
  end

  def build_http_request(path)
    uri = URI.parse(@host + ":" + @port + "#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = @usessl
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    return http, uri
  end

  # Methods for typical operations
  def query_by_nodename(name)
  end

  def query_by_nodeid(nodeid)
  end
  
  def query_by_ipaddress(ipaddress)
  end

end
