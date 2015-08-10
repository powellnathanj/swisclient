require "uri"
require "yaml"
require "json"
require "net/http"

class Swisclient

  def initialize(host, port, username, password)
    @host = host
    @port = port
    @username = username
    @password = password
  end

  def query(query)
  end

  def query_by_nodename(name)
  end

  def query_by_nodeid(nodeid)
  end

  def query_by_ipaddress(ipaddress)
  end

  def build_http_request()
    
  end

end
