require "socket"

module CSGOLytics; end

class CSGOLytics::LogParser

  def parse(line)
    ev = nil
    return ev if ev = parse_kill(line)
    return ev	  
  end

private

  def parse_kill(line)
    return { :raw => line }
  end

end
