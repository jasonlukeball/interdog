require 'rubygems'
require 'dogapi'
require 'intercom'
require 'dotenv/load'
require_relative 'controllers/datadog'
require_relative 'controllers/intercom'

puts "Getting inbox metrics from Intercom..."
intercom_inbox_metrics = get_inbox_metrics("minutes")

puts "Sending inbox metrics to Datadog..."
send_inbox_metrics(intercom_inbox_metrics)