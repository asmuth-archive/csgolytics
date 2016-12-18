#!/usr/bin/env ruby
require "yaml"
$: << ::File::expand_path("../", __FILE__)

require "backend/backend.rb"

config = YAML.load_file(::File::expand_path("../config/config.yml", __FILE__))

backend = CSGOLytics::Backend.new(config)
backend.start


