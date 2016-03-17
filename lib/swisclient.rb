require "uri"
require "json"
require "openssl"
require "net/http"

class Swisclient

  def initialize(username, password, host, port="17778")
    swispath    = "/SolarWinds/InformationService/v3/Json"
    @host       = host
    @port       = port
    @username   = username
    @password   = password
    @querypath  = "#{swispath}" + "/Query"
    @addpath    = "#{swispath}" + "/Create/Orion.Nodes"
    @usessl     = true
    @sslverify  = OpenSSL::SSL::VERIFY_NONE
  end

  # This is a raw query function, no syntactical sugar
  # The query should be a ruby hash similar to:
  # {"query" => "SELECT NodeID FROM Orion.Nodes WHERE NodeName=@name", "parameters" => {"name" => "myhost.mydomain.com"}}
  # returns a ruby hash
  def query(query)
    do_http_request(@querypath, query)
  end
 
  # Search for a node by the NodeName attribute
  # returns a ruby hash
  def query_by_nodename(nodename)
    query = {"query" => "SELECT NodeName, NodeID FROM Orion.Nodes WHERE NodeName=@name", "parameters" => {"name" => "#{nodename}"}}
    do_http_request(@querypath, query)
  end

  # Search for a node by the NodeID attribute
  # returns a ruby hash
  def query_by_nodeid(nodeid)
    query = {"query" => "SELECT NodeName, NodeID FROM Orion.Nodes WHERE NodeID=@id", "parameters" => {"id" => "#{nodeid}"}}
    do_http_request(@querypath, query)
  end
  
  # Search for a node by the IPAddress attribute
  # returns a ruby hash
  def query_by_ipaddress(ipaddress)
    query = {"query" => "SELECT NodeName, NodeID FROM Orion.Nodes WHERE IPAddress=@ipaddr", "parameters" => {"ipaddr" => "#{ipaddress}"}}
    do_http_request(@querypath, query)
  end

  # This is a raw add method.  
  # node should be a ruby hash similar to:
  #
  # {"EntityType" => "Orion.Nodes", "IPAddress" => "192.168.1.2", "Caption"=> "oh hai", "DynamicIP" => "False",  
  #  "Status" => 1, "UnManaged" => "False", "Allow64BitCounters" => "True", "EngineID" => "1",
  #  "ObjectSubType" => "SNMP", "SNMPVersion" => 2, "Community" => "public"}
  #
  # Required: IPAddress, EngineID, ObjectSubType, and SNMPVersion
  #
  # returns a ruby hash
  def add_node(node)
    do_http_request(@addpath, node)
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

    return JSON.parse(http.request(request).body)
  end

  private :do_http_request

end
