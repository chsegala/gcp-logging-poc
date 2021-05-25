terraform {
  backend "gcs" {
    bucket = "gcp-logging-poc"
    prefix = "terraform/state"
  }
}

module "logGenerator" {
  source       = "./function/"
  functionName = "logGenerator"
}

# module "logMiddleware" {
#   source       = "./function/"
#   functionName = "logMiddleware"
# }

# module "logConsumer" {
#   source       = "./function/"
#   functionName = "logConsumer"
# }

resource "google_endpoints_service" "externalEndpoint" {
  service_name   = "gcp-logging-poc-314817.appspot.com"
  project        = "gcp-logging-poc-314817"
  openapi_config = file("./openapi_spec.yml")
}
