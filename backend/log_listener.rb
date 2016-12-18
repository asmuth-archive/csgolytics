require "socket"

module CSGOLytics; end

class CSGOLytics::LogListener

  REMOTE_LOG_PKT_HEADER = "\xff\xff\xff\xffR"

  def initialize(config)
    @ssock = UDPSocket.new
    @ssock.bind("0.0.0.0", 3764)
    @callbacks = []

    @remotes_map = {}
    config["servers"].each do |server|
      server["remote_addrs"].each do |remote_addr|
        @remotes_map[remote_addr] = server["server_id"]
      end
    end
  end

  def listen
    while msg = @ssock.recvfrom(0xffff)
      payload, raddr = msg
      payload = payload.force_encoding("utf-8")

      remote_addrs = [
        "#{raddr[2]}:#{raddr[1]}",
        "#{raddr[3]}:#{raddr[1]}"
      ].uniq

      remote_server_id = nil
      remote_addrs.each do |r|
	remote_server_id ||= @remotes_map[r]
      end
     
      unless remote_server_id
        $stderr.puts "WARNING: unknown server: #{remote_addrs.inspect}"
	next
      end

      unless payload.start_with?(REMOTE_LOG_PKT_HEADER)
        $stderr.puts "WARNING: received invalid log packet"
        next
      end

      logline = payload[REMOTE_LOG_PKT_HEADER.length..-1]
      while ["\0", "\r", "\n"].include?(logline[-1])
        logline = logline[0..-2]
      end

      @callbacks.each do |cb|
        cb[logline, remote_server_id]
      end
    end
  end

  def on_logline(&cb)
    @callbacks << cb
  end

end
