module CSGOLytics; end

class CSGOLytics::FeedUpload

  def initialize(evql, dispatch)
    dispatch.subscribe do |ev|
      upload_event(ev)
    end
  end

  def upload_event(ev)
    puts "UPLOAD EVENT: #{ev.inspect}"
  end

end
