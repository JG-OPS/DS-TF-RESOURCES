############### VPC variables

variable "region" {
  type        = string
  default     = "us-west-1"
  description = "Region where this stack will be deployed."
}
variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR block for the VPC."
}
variable "availability_zones" {
  default     = "us-west-1b,us-west-1c"
  description = "The availability zones to create subnets in"
}

variable "az_counts" {
  default = 2
}

variable "vpc_public_prefix" {
   type = map
   default = {
      sub-1 = {
         az = "usw1-az1"
         cidr = "10.0.198.0/24"
      }
      sub-2 = {
         az = "usw1-az3"
         cidr = "10.0.199.0/24"
      }
   }
}
variable "vpc_private_prefix" {
   type = map
   default = {
      sub-1 = {
         az = "usw1-az1"
         cidr = "10.0.200.0/24"
      }
      sub-2 = {
         az = "usw1-az3"
         cidr = "10.0.201.0/24"
      }
   }
}