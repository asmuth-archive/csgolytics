module CSGOLytics; end

class CSGOLytics::HTTPServlet < WEBrick::HTTPServlet::AbstractServlet

  def initialize(server, backend)
    super server
    @backend = backend
  end

  def do_POST (request, response)
    if request.path == "/api/v1/insert_logline"
      @backend.insert_logline request.body.force_encoding("utf-8")
      response.status = 201
      response.body = "ok"
      response.content_type = "text/plan"
      return
     end

    response.status = 404
    response.body = "not found"
    response.content_type = "text/plan"
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
