require "securerandom"
require "csgolytics/log_parser"

module CSGOLytics; end

class CSGOLytics::FeedUpload

  PARTITION_SIZE = 3600 * 24

  EVENT_TABLE_MAP = {
    "frag" => "csgo_frags",
    "assist" => "csgo_assists"
  }

  def initialize(db)
    @db = db
    @log_parser = CSGOLytics::LogParser.new
  end


  def insert_logline(logline, event_id = nil)
    ev = @log_parser.parse(logline)
    unless ev
      return
    end

    if event_id
      ev[:event_id] = event_id
    else
      ev[:event_id] = Digest::SHA1.hexdigest logline
    end

    upload_event(ev)
  end

private

  def upload_event(ev)
    table = EVENT_TABLE_MAP[ev[:event]]
    unless table
      return
    end

    ev[:time_key] = (Time.parse(ev[:time]).to_i / PARTITION_SIZE) * PARTITION_SIZE

    @db.insert!([{ :table => table, :database => @db.get_database, :data => ev }])
  end

end
