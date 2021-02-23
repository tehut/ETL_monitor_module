variable "env" {
  type = string
}
variable "expected_count" {
  type = string
}
variable "job_name" {
  type        = string
  description = "Name of nomad service attached to etl job"
}
variable "log_query" {
  type        = string
  description = <<-DESCRIPTION
    Datadog log query.
    See: https://docs.datadoghq.com/monitors/monitor_types/log/
    DESCRIPTION
}

variable "message" {
  type = string
}

variable "monitor_notification_recipients" {
  type        = list(string)
  description = <<-DESCRIPTION
    List of notification targets for Datadog monitors.
    See: https://docs.datadoghq.com/monitors/notifications/?tab=is_alert#notify-your-team
    DESCRIPTION
}

terraform {
  required_version = ">= 0.13"
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 2.7"

    }
  }
}

resource "datadog_monitor" "ETL_Quiet" {
  query   = var.log_query
  name    = "${var.job_name} ETL job too quiet"
  message = <<-MESSAGE
    ${var.job_name} logging fewer completions than expected. Expected ${var.expected_count} :ohdear:

    Notify: ${join(" ", var.monitor_notification_recipients)}
  MESSAGE
  tags    = ["env:${var.env}", "job_name:${var.job_name}"]

  notify_no_data    = false
  renotify_interval = 60

  notify_audit = false
  timeout_h    = 60
  include_tags = true
  type         = "log alert"
}
