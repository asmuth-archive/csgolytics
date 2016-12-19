require "fileutils"
require 'optparse'
require 'uri'
require 'net/http'
require 'digest/sha1'

module CSGOLytics; end

class CSGOLytics::LogReader

  POLL_INTERVAL = 1

  def initialize(logdir)
    @logdir = logdir
    @callbacks = []
  end

  def on_logline(&cb)
    @callbacks << cb
  end

  def start
    # tail the logfiles
    loop do
      begin
        # list all logfiles
        @logfiles = {}
        @logfiles_completed = {}
        Dir.entries(@logdir).each do |f|
          if f.end_with?(".log")
            @logfiles[f] = true
          end

          if f =~ /^\.(.*\.log)\.csgolytics_complete$/
            @logfiles_completed[$1] = true
          end
        end

        @logfiles = (@logfiles.keys - @logfiles_completed.keys).sort

        # read each logfile from the last offset and upload new lines
        @logfiles.each_with_index do |fname, logfile_index|
          fpath = File.join(@logdir, fname)
          offset_file_path = File.join(@logdir, ".#{fname}.csgolytics_offset")
          offset = 0
          if File.exists?(offset_file_path)
            offset = IO.read(offset_file_path).to_i
          end

          puts "Reading #{fpath} from #{offset}"

          f = File.open(fpath)
          f.seek(offset)
          while l = (f.readline rescue nil)
            l.encode!('UTF-8', 'UTF-8', :invalid => :replace)
            l.chomp!

            @callbacks.each do |cb|
              cb[l]
            end

            File.write(offset_file_path + "~", f.tell)
            FileUtils.mv(offset_file_path + "~", offset_file_path)
          end

          if logfile_index < @logfiles.length - 1
            FileUtils.touch(File.join(@logdir, ".#{fname}.csgolytics_complete"))
          end
        end
      rescue Exception => e
        $stderr.puts "ERROR: #{e.to_s}"
        $stderr.puts e.backtrace
      end

      sleep POLL_INTERVAL
    end
  end

end
