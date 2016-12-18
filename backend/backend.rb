#!/usr/bin/env ruby
require "socket"
require "backend/log_listener"

module CSGOLytics; end

class CSGOLytics::Backend

  def initialize
    @log_listener = LogListener.new
    @log_listener.on_logline do |logline, remote_addr|
      puts logline
    end
  end

  def start
    @log_listener.listen
  end

end
