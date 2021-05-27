terraform {
  backend "gcs" {
    bucket = "gcp-logging-poc"
    prefix = "terraform/state"
  }
}

locals {
  timestamp = formatdate("YYMMDDhhmmss", timestamp())
  root_dir  = abspath("../")
  project   = "gcp-logging-poc-314817"
}

# Compress source code
data "archive_file" "source" {
  type        = "zip"
  source_dir  = local.root_dir
  output_path = "/tmp/function-${local.timestamp}.zip"
}

resource "google_storage_bucket" "bucket" {
  name                        = "${local.project}-functions"
  project                     = local.project
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "archive" {
  name   = "index-${local.timestamp}.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.source.output_path
}

module "logGenerator" {
  source       = "./function/"
  functionName = "logGenerator"
  bucket       = google_storage_bucket.bucket
  archive      = google_storage_bucket_object.archive
  trigger_http = true
}

module "logConsumer" {
  source       = "./function/"
  functionName = "logConsumer"
  bucket       = google_storage_bucket.bucket
  archive      = google_storage_bucket_object.archive
  trigger_http = true
}

module "logSubscriber" {
  source       = "./function/"
  functionName = "logSubscriber"
  bucket       = google_storage_bucket.bucket
  archive      = google_storage_bucket_object.archive
  event_trigger = {
    event_type = "google.pubsub.topic.publish"
    resource   = "function-pubsub"
  }
}

resource "google_pubsub_topic" "pubsub" {
  name    = "function-pubsub"
  project = local.project
}

resource "google_pubsub_subscription" "pubsub" {
  name    = "example-subscription"
  project = local.project
  topic   = google_pubsub_topic.pubsub.name

  ack_deadline_seconds       = 10
  retain_acked_messages      = false
  message_retention_duration = "600s"

  expiration_policy {
    ttl = "300000.5s"
  }
  retry_policy {
    minimum_backoff = "10s"
  }

  enable_message_ordering = false
}
