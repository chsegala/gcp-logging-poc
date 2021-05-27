output "function" {
  value = google_cloudfunctions_function.function
}

output "trigger_url" {
  value = google_cloudfunctions_function.function.https_trigger_url
}