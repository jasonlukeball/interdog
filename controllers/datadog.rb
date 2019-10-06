def datadog
  Dogapi::Client.new("<your_api_key>", "<your_application_key>")
end

def send_inbox_metrics(metrics)
  metrics.each do |inbox|
    datadog.emit_point("intercom.inboxes.#{inbox[:name]}.count", inbox[:convo_count])
    datadog.emit_point("intercom.inboxes.#{inbox[:name]}.wait_time", inbox[:wait_time])
    puts "--> Metrics sent for the #{inbox[:name]} inbox"
  end
end