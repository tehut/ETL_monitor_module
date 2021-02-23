# ETL_monitor_module

Module to create a single datadog monitor to monitor ETL job logs and alert if the job goes unexpectedly quiet.
## Datadog Provider requirements
* The Datadog provider requires both `app_key` and `api_key` parameters 

## Required Variables
* `env` string 
* `expected_count` string 
* `job_name` string
* `log_query` string
* `monitor_notification_recipients` list of strings
  * to use a slack channel from a linked account just prepend the channel name with `slack-`

These variables are combined to create the following message in your alert:

``` 
    ${var.job_name} logging fewer completions than expected. Expected ${var.expected_count} :ohdear:

    Notify: ${join(" ", var.monitor_notification_recipients)}
```

