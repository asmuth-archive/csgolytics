#!/usr/bin/env ruby
$: << ::File::expand_path("../", __FILE__)

require "backend/backend.rb"

backend = CSGOLytics::Backend.new
backend.start


