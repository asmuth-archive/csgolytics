module CSGOLytics; end

class CSGOLytics::HTTPServlet < WEBrick::HTTPServlet::AbstractServlet

  def initialize(server, backend)
    super server
    @backend = backend
  end

  def do_POST (request, response)
    if request.path == "/api/v1/insert_logline"
      @backend.insert_logline request.body
      return 200, 'text/plain', 'ok'
    end

    return 404, 'text/plain', 'not found'
  end

end

class CSGOLytics::HTTPServer

  def initialize(backend, port)
    @http = WEBrick::HTTPServer.new(:Port => port)
    @http.mount "/", CSGOLytics::HTTPServlet, backend
  end

  def listen
    @http.start
  end

  def shutdown
    @http.shutdown
  end

end
