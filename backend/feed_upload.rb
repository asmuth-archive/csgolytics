module CSGOLytics; end

class CSGOLytics::FeedUpload

  def initialize(evql, dispatch)
    dispatch.subscribe(&:upload_event)
  end

  def upload_event(ev)
    puts "UPLOAD EVENT: #{ev.inspect}"
  end

end
