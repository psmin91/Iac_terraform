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
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}
variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type        = bool
  default     = true
}
##################################
##	Network Configurations 
##################################

# VPC CIDR Data
variable "vpc_CIDR_default" {
	description	=	""
	type		=	string
	default = "0.0.0.0/0"
}

variable "vpc_CIDR_DBZone" {
	description	=	""
	type		=	string
	default = "0.0.0.0/0"
}

variable "vpc_CIDR_Uniq" {
	description	=	""
	type		=	string
	default = "0.0.0.0/0"
}

variable "vpc_CIDR_Dup" {
	description	=	""
	type		=	string
	default = "0.0.0.0/0"
}


# Subnets CIDR Data
variable "snet_fend_CIDR" {
	description	=	""
	type		=	list(string)
	default 	=	[]
}
variable "snet_bend_db_CIDR" {
	description	=	""
	type		=	list(string)
	default 	=	[]
}
variable "snet_bend_uniq_CIDR" {
	description	=	""
	type		=	list(string)
	default 	=	[]
}
variable "snet_bend_dup_CIDR" {
	description	=	""
	type		=	list(string)
	default 	=	[]
}
