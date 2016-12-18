require "socket"
require "backend/event_dispatch"
require "backend/log_listener"
require "backend/log_parser"
require "backend/feed_upload"

module CSGOLytics; end

class CSGOLytics::Backend

  def initialize(evql, config)
    @ev_dispatch = CSGOLytics::EventDispatch.new

    # init schema manager
    @schema_manager = CSGOLytics::SchemaManager.new(
        evql,
        ::File::expand_path("../../db", __FILE__))

    # init feed upload
    @feed_upload = CSGOLytics::FeedUpload.new(evql, @ev_dispatch)

    # wire up loglistener
    @log_listener = CSGOLytics::LogListener.new(config)
    @log_parser = CSGOLytics::LogParser.new

    @log_listener.on_logline do |logline, server_id|
      if ev = @log_parser.parse(logline)
        ev[:server_id] = server_id
        @ev_dispatch.publish(ev)
      end
    end
  end

  def start
    # migrate database schemas
    @schema_manager.migrate!

    # start log listener
    @log_listener.listen
  end

end
