def intercom
  Intercom::Client.new(token: ENV['INTERCOM_ACCESS_TOKEN'])
end

# gets a list of team inboxes used to collect metrics
def get_team_inboxes
  intercom.teams.all.map {|team| {id: team.id, name: team.name}}
end

# gets open conversations in the specified team inbox and returns timestamps used to determine wait time
def get_open_convos_for_team_inbox(team_id)
  intercom.conversations.find_all(type: 'admin', id: team_id, open: true).map do |convo|
    { id: convo.id, created_at: convo.created_at.to_i, updated_at: convo.updated_at.to_i, waiting_since: convo.waiting_since.to_i}
  end
end

# sorts list of conversations from team inbox by 'waiting longest'
# calculates the wait time for the 'oldest conversation'
def get_inbox_wait_time(conversations, time_unit)
  conversations_sorted = conversations.sort_by {|hsh| hsh[:waiting_since]}
  oldest_conversation = conversations_sorted[0]
  current_time = Time.now.utc.to_f

  if conversations_sorted.count == 0
    0
  elsif current_time > oldest_conversation[:waiting_since]
    get_inbox_wait_time_by_unit(current_time.to_f - oldest_conversation[:waiting_since].to_f, time_unit)
  elsif current_time < oldest_conversation[:waiting_since]
    get_inbox_wait_time_by_unit(current_time.to_f - oldest_conversation[:updated_at].to_f, time_unit)
  end
end

# calculates wait time in minutes, hours or days
def get_inbox_wait_time_by_unit(seconds, time_unit)
  if time_unit == "minutes"
    (seconds/60).round(0)
  elsif time_unit == "hours"
    (seconds/60/60).round(0)
  elsif time_unit == "days"
    (seconds/60/60/24).round(2)
  end
end

# generates inbox metrics to send to datadog
def get_inbox_metrics(time_unit)
  data = []
  inboxes = get_team_inboxes
  inboxes.each do |inbox|
    conversations = get_open_convos_for_team_inbox(inbox[:id])
    wait_time = get_inbox_wait_time(conversations, time_unit)
    metric = {name: inbox[:name].downcase.tr(" ", "_"), convo_count: conversations.count, wait_time: wait_time }
    data << metric
    puts "--> Metrics for the #{inbox[:name]} inbox #{metric}"
  end
  data
end