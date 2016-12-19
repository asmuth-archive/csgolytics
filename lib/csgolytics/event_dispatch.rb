require "socket"

module CSGOLytics; end

class CSGOLytics::EventDispatch

  def initialize
    @subscriptions = []
  end

  def subscribe(&cb)
    @subscriptions << cb
  end

  def publish(ev)
    @subscriptions.each do |cb|
      cb[ev]
    end
  end

end
