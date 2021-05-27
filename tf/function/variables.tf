variable "functionName" {
  type = string
}

variable "bucket" {

}

variable "archive" {

}

variable "event_trigger" {
  type = object({
    event_type = string
    resource   = string
  })
  default = null
}

variable "trigger_http" {
  type    = bool
  default = null
}
