require "socket"

module CSGOLytics; end

class CSGOLytics::SchemaManager

  def initialize(db, schema_path)
    @db = db
    @schema_path = schema_path

    @tables = []
    Dir.entries(schema_path).each do |tbl|
      next if tbl.start_with?(".")

      if tbl =~ /(\w+)\.sql/
        @tables << $1
      else
        $stderr.puts "ERROR: invalid table schema file #{tbl}"
        exit 1
      end
    end
  end

  def migrate!
    $stderr.puts "Migrating database schemas, this may take a second"
    list_tables_qry = @db.query("show tables;")
    list_tables_res = list_tables_qry.execute!

    actual_tables = list_tables_res[0]["rows"].map(&:first)
    (@tables - actual_tables).each do |tbl|
      create_table!(tbl)
    end
  end

private

  def create_table!(tbl)
    $stderr.puts "Creating table: #{tbl}"
    create_table_sql = IO.read(File::join(@schema_path, tbl + ".sql"))
    create_table_qry = @db.query(create_table_sql)
    create_table_qry.execute!
  end

end
