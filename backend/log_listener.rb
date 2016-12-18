#!/usr/bin/env ruby
require "socket"

module CSGOLytics; end

class CSGOLytics::LogListener

  REMOTE_LOG_PKT_HEADER = "\xff\xff\xff\xffR"

  def initialize
    @ssock = UDPSocket.new
    @ssock.bind("0.0.0.0", 3764)
    @callbacks = []
  end

  def listen
    while msg = @ssock.recvfrom(0xffff)
      payload, raddr = msg
      payload = payload.force_encoding("utf-8")

      remote_addrs = [
        "#{raddr[2]}:#{raddr[1]}",
        "#{raddr[3]}:#{raddr[1]}"
      ].uniq

      unless payload.start_with?(REMOTE_LOG_PKT_HEADER)
        # FIXME log warning
        next
      end

      logline = payload[REMOTE_LOG_PKT_HEADER.length..-1]
      while ["\0", "\r", "\n"].include?(logline[-1])
        logline = logline[0..-2]
      end

      @callbacks.each do |cb|
        cb[logline, remote_addrs]
      end
    end
  end

  def on_logline(&cb)
    @callbacks << cb
  end

end

l = CSGOLytics::LogListener.new
l.on_logline do |logline, remote_addr|
  puts logline
end
l.listen
