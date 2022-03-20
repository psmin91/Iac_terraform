##########################################
############ Common Variable #############
##########################################
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

##########################################
######## Security Group Variable #########
##########################################
variable "name" {
  description = "Name of security group - not required if create_sg is false"
  type        = string
  default     = null
}
variable "description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}
variable "use_name_prefix" {
  description = "Whether to use name_prefix or fixed name. Should be true to able to update security group name after initial creation"
  type        = bool
  default     = true
}
variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}
variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}
variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "egress_rules" {
  description = "List of egress rules to create by name"
  type        = list(string)
  default     = []
}