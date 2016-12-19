require "securerandom"
require "csgolytics/log_parser"

module CSGOLytics; end

class CSGOLytics::FeedUpload

  PARTITION_SIZE = 3600 * 24

  EVENT_TABLE_MAP = {
    "frag" => "csgo_frags",
    "assist" => "csgo_assists"
  }

  def initialize(db, server_id = nil)
    @db = db
    @server_id = server_id
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

    if @server_id
      ev[:server_id] = @server_id
    end

    upload_event(ev)
  end

private

  def upload_event(ev)
    table = EVENT_TABLE_MAP[ev[:event]]
    unless table
      return
    end

    @db.insert!([{ :table => table, :database => @db.get_database, :data => ev }])
  end

end
