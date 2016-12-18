require "socket"
require "backend/event_dispatch"
require "backend/log_listener"
require "backend/log_parser"
require "backend/feed_upload"
require "backend/http_server"

module CSGOLytics; end

class CSGOLytics::Backend

  def initialize(evql, config)
    @ev_dispatch = CSGOLytics::EventDispatch.new
    @log_parser = CSGOLytics::LogParser.new

    # init schema manager
    @schema_manager = CSGOLytics::SchemaManager.new(
        evql,
        ::File::expand_path("../../db", __FILE__))

    # init feed upload
    @feed_upload = CSGOLytics::FeedUpload.new(evql, @ev_dispatch)

    # init http server
    @http_server = CSGOLytics::HTTPServer.new(self, 3765)

    # wire up loglistener
    #@log_listener = CSGOLytics::LogListener.new(config)
    #@log_listener.on_logline do |logline, server_id|
    #  insert_logline(logline, server_id)
    #end
  end

  def insert_logline(logline, server_id = nil)
    if ev = @log_parser.parse(logline)
      ev[:server_id] = server_id
      @ev_dispatch.publish(ev)
    end
  end

  def start
    # migrate database schemas
    @schema_manager.migrate!

    # start http server
    if @http_server
      @http_server.listen
    end

    # start log listener
    #if @log_listener
    #  @log_listener.listen
    #end
  end

  def shutdown
    if @http_server
      @http_server.shutdown
    end
  end

end
