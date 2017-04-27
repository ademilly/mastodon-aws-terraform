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

variable "smtp_server" {
  description = "SMTP Server ; used by service for mailing"
}

variable "smtp_login" {
  description = "SMTP login ; used by service for mailing"
}

variable "smtp_password" {
  description = "SMTP password ; used by service for mailing"
}

variable "smtp_from_address" {
  description = "SMTP from address for notifications ; used by service for mailing"
}

# VPC var block
variable "subnet_id" {
  description = "Subnet in which to launch the service"
}

# Security Group block
variable "security_group_id" {
  description = "Security group to attach to service"
}

# Route53 var block
variable "zone_id" {
  description = "Zone id in which to launch the service"
}

variable "domain" {
  description = "domain name for the service"
}

variable "subdomain" {
  description = "Subdomain name for the service"
  default     = "mastodon"
}
