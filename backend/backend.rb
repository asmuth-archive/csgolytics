#!/usr/bin/env ruby
require "socket"
require "backend/log_listener"

module CSGOLytics; end

class CSGOLytics::Backend

  def initialize(config)
    @log_listener = CSGOLytics::LogListener.new(config)
    @log_listener.on_logline do |logline, server_id|
      puts "#{server_id} => #{logline}"
    end
  end

  def start
    @log_listener.listen
  end

end
