def datadog
  Dogapi::Client.new(ENV['DATADOG_API_KEY'], ENV['DATADOG_APPLICATION_KEY'])
end

def send_inbox_metrics(metrics)
  metrics.each do |inbox|
    datadog.emit_point("intercom.inboxes.#{inbox[:name]}.count", inbox[:convo_count])
    datadog.emit_point("intercom.inboxes.#{inbox[:name]}.wait_time", inbox[:wait_time])
    puts "--> Metrics sent for the #{inbox[:name]} inbox"
  end
end