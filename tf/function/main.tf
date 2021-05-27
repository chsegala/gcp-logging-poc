resource "google_cloudfunctions_function" "function" {
  name        = var.functionName
  description = var.functionName
  runtime     = "nodejs14"
  project     = "gcp-logging-poc-314817"
  region      = "us-east1"

  source_archive_bucket = var.bucket.name
  source_archive_object = var.archive.name

  available_memory_mb = 128
  trigger_http        = var.trigger_http

  entry_point      = var.functionName
  ingress_settings = "ALLOW_ALL"

  dynamic "event_trigger" {
    for_each = var.event_trigger != null ? [1] : []
    content {
      event_type = var.event_trigger.event_type
      resource   = var.event_trigger.resource
    }
  }
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
