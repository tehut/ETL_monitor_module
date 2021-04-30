variable "http-url" {
  type = string
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


resource "datadog_synthetics_test" "releases-http-only-dev" {
  type = "browser"

  request_definition {
    method = "GET"
    url    = var.http-url
  }

  device_ids = ["chrome.laptop_large", "firefox.laptop_large"]
  locations  = ["aws:us-west-2"]

  options_list {
    tick_every           = 86400
    follow_redirects     = true
    min_failure_duration = "0"
    min_location_failed  = "1"
    monitor_options {
      renotify_interval = "30"
    }


  }

  name    = "A Browser test on ${var.http-url}"
  message = "Testing terraform to replicate existing monitor.\n\n  @slack-test-ops-eng-serv-ops"
  tags    = []

  status = "live"

  browser_step {
    name = "HTTP healthcheck"
    type = "runApiTest"
    params {
      request = "{\"config\":{\"assertions\":[],\"request\":{\"method\":\"GET\",\"url\":\"http://fastly-releases-tghun.s3-website-us-west-2.amazonaws.com.global.prod.fastly.net/\"}},\"options\":{\"follow_redirects\": true},\"subtype\":\"http\"}"

    }

  }

}
