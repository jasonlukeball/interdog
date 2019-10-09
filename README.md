# Interdog

This library is intended to help teams working out of multiple inboxes within [Intercom](http://www.intercom.com). 

It allows teams to get a 'birds eye view' of their inboxes by sending metrics to [Datadog](http://datadoghq.com) for realtime dashboards. 

For every team inbox In Intercom, two metrics will be sent to Datadog:
1. `intercom.inboxes.inbox_name.count` - Total count of open conversations in the inbox 
2. `intercom.inboxes.inbox_name.wait_time` - Wait time of the 'oldest conversation' in days/hours or minutes (default)  

### Dependencies

- [Dotenv](https://github.com/bkeepers/dotenv)
- [Intercom Ruby SDK](https://github.com/intercom/intercom-ruby)
- [Datadog Ruby SDK](https://github.com/DataDog/dogapi-rb)
- [Intercom REST API App](https://developers.intercom.com/building-apps/docs) using API Version  `1.4` or later ([changelog](https://developers.intercom.com/building-apps/docs/api-changelog)) 

### Installation

Install the required gems
```
$ cd interdog
$ bundle install 
```

- Create a `.env` file
- Add your Intercom & Datadog API keys

```
INTERCOM_ACCESS_TOKEN=your_access_token
DATADOG_API_KEY=your_api_key
DATADOG_APPLICATION_KEY=your_application_key
```
- Don't forget to add this to your `.gitignore` file!

### Usage

- Run `interdog.rb` as a cron job on your server, as frequently as you need.
- For realtime reporting, set your job to run every minute
``` 
* * * * * /path/to/interdog/interdog.rb 
```

### Contributing
Feel free to help make this better! 

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Added some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request