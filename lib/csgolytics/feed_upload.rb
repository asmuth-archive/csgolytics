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


  def insert_logline(logline)
    ev = @log_parser.parse(logline)
    return unless ev

    upload_event(ev)
  end

private

  def upload_event(ev)
    table = EVENT_TABLE_MAP[ev[:event]]
    return unless table

    ev[:time_key] = (Time.parse(ev[:time]).to_i / PARTITION_SIZE) * PARTITION_SIZE
    ev[:event_id] = SecureRandom.hex[0..8]

    @db.insert!([{ :table => table, :database => @db.get_database, :data => ev }])
  end

end
