resource "google_cloudfunctions_function" "function" {
  name        = var.functionName
  description = var.functionName
  runtime     = "nodejs14"
  project     = "gcp-logging-poc-314817"
  region      = "us-east1"

  source_repository {
      url = "https://source.developers.google.com/projects/gcp-logging-poc-314817/repos/gcp-logging-poc/master/paths/src/${var.functionName}"
  }

  available_memory_mb = 128
  trigger_http        = true
  entry_point         = "main"
  ingress_settings    = "ALLOW_ALL"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
