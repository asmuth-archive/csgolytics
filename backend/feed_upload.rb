require "securerandom"
require "pp"

module CSGOLytics; end

class CSGOLytics::FeedUpload

  PARTITION_SIZE = 3600 * 24

  EVENT_TABLE_MAP = {
    "kill" => "csgo_kills" 
  }

  def initialize(db, dispatch)
    @db = db

    dispatch.subscribe do |ev|
      upload_event(ev)
    end
  end

  def upload_event(ev)
    table = EVENT_TABLE_MAP[ev[:event]]
    return unless table

    ev[:time_key] = (Time.parse(ev[:time]).to_i / PARTITION_SIZE) * PARTITION_SIZE
    ev[:event_id] = SecureRandom.hex[0..8]

    pp ev
    @db.insert!([{ :table => table, :database => @db.get_database, :data => ev }])
  end

end
