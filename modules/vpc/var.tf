# Service Meta Data 
variable "vpc_id" {			
	description	=	""
	type		=	string
	default		=	""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "aws_region" {				# Region Code
	description	=	""
	type		=	string
	default		=	""
}

variable "aws_region_code" {
	description	=	""
	type		=	string
	default		=	""
}
variable "prj_name" {
	description	=	""
	type		=	string
	default		=	""
}

variable "env" {
	description	=	""
	type		=	string
	default		= 	""
}
variable "user_code" {			# Creator Code
	description	=	""
	type		=	string
	default		=	""			# user_code
}

### append PSM ###
variable "instance_tenancy" {
	description =	"A tenancy option for instances launched into the VPC"
	type		=	string
	default     =	"default"
}
variable "enable_dns_hostnames" {
	description =	"Should be true to enable DNS hostnames in the VPC"
	type		=	bool
	default     =	true
	#default     = false
}
variable "enable_dns_support" {
	description =	"Should be true to enable DNS support in the VPC"
	type		=	bool
	default     =	true
}
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

# VPC CIDR Data
variable "vpc_CIDR_default" {
	description	=	""
	type		=	string
	default = "0.0.0.0/0"
}