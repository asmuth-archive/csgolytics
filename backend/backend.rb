require "socket"
require "backend/event_dispatch"
require "backend/log_listener"
require "backend/log_parser"

module CSGOLytics; end

class CSGOLytics::Backend

  def initialize(config)
    @ev_dispatch = CSGOLytics::EventDispatch.new

    # wire up loglistener
    @log_listener = CSGOLytics::LogListener.new(config)
    @log_parser = CSGOLytics::LogParser.new

    @log_listener.on_logline do |logline, server_id|
      if ev = @log_parser.parse(logline)
	ev[:server_id] = server_id
        @ev_dispatch.publish(ev)
      end
    end

    # print each incoming event
    @ev_dispatch.subscribe do |ev|
      puts ev.inspect
    end
  end

  def start
    @log_listener.listen
  end

end
