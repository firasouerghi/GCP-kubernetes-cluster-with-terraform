
variable "project" {
  type        = string
  description = "project id"
}

variable "region" {
  type        = string
  description = "project region"
}

variable "zone" {
  type        = string
  description = "project zone"
}

variable "credentials_file" {
  type        = string
  description = "json GCP credential file"

}
variable "environment" {
  type        = string
  description = "environment type"

}
variable "machine_types" {
  type = map(any)
  default = {
    dev  = "e2-micro"
    test = "n1-standard-1"
    prod = "n1-highcpu-32"
  }
  description = "type of GCP machine to use "
}

variable "gke_num_nodes" {

  type        = number
  description = "The number of nodes per cluster"

}