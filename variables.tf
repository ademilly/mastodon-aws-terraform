# EC2 block
variable "key_name" {
  description = "EC2 Key name"
}

variable "instance_type" {
  description = "Instance type"
}

variable "instance_name" {
  description = "Instance name"
}

# VPC var block
variable "vpc_id" {
  description = "VPC in which to launch the service"
}

variable "subnet_id" {
  description = "Subnet in which to launch the service"
}

# Route53 var block
variable "zone_id" {
  description = "Zone id in which to launch the service"
}

variable "subdomain" {
  description = "Subdomain name for the service"
  default     = "mastodon"
}
