#####################################################################
##	TemplateName:	vpc.tf
##	Purpose:		Terraform Template for Creation VPC
##	---------------------------------------------------------------
##	Version	|	Date		    |	Developer		    | Update Reason
##	1.0		  | 2022.03.11	| Hwang Gyu Yong	| First Version
##  1.1     | 2022.03.18  | Park Soo Min    | Modularization
#####################################################################

#####################################################################
##	Resource List
##	---------------------------------------------------------------
##	aws_vpc
#####################################################################
##	Input Variables
##	------------------------------------------------------------------------------------------------------------------------
##	Variable for Creation		| Meaning								                | Type								            | from
##	------------------------------------------------------------------------------------------------------------------------
##	var.prj_name				    | Code of Project Name or Service Name	| String							            | ~IaCTCL-dev/main.tf
##	var.env						      | Environment of System					        | String [dev | stg | prd | qa]		| ~IaCTCL-dev/main.tf
##	var.aws_region				  | AWS Region Name						            | String [default: ap-northeast-2]| ~IaCTCL-dev/main.tf
##	var.aws_region_code	    | AWS Region Code						            | String [default: an2]				    | ~IaCTCL-dev/main.tf
##	var.user_code			 	    | Creator Code (Employee No. of Creator)| String [XXXXX]					        | ~IaCTCL-dev/main.tf
##	var.vpc_CIDR_default    | Default CIDR for VPC					        | String [XXX.XXX.XXX.XXX/XX]		  | ~IaCTCL-dev/main.tf
##  var.instance_tenancy.   | -                                     | String							            | ~IaCTCL-dev/main.tf
##  var.enable_dns_hostnames| -                                     | bool								            | ~IaCTCL-dev/main.tf
##  var.enable_dns_support. | -                                     | bool								            | ~IaCTCL-dev/main.tf
##	var.tags					      | common tags							              | Map								              | ~IaCTCL-dev/main.tf
#####################################################################
##	Output Variables
##	------------------------------------------------------------------------------------------------------------------------
##	Variable for Output			  | Meaning								              | Type
##	------------------------------------------------------------------------------------------------------------------------
##	default_vpc_id				    | ID of VPC created by terraform code	| String
##	default_route_table_id		| ID of default route table id			  | String
##	default_network_acl_id		| ID of default ACL id					      | String
##	default_security_group_id	| ID of default Security Group id		  | String
##	------------------------------------------------------------------------------------------------------------------------

################### Resource Definition ##########################


locals {
	vpc_id = aws_vpc.this.id
	default_rt_id = "${aws_vpc.this.default_route_table_id}"
}
output "vpc_id" {
	value = aws_vpc.this.id
}

output "default_route_table_id" {
	value = aws_vpc.this.default_route_table_id
}

output "default_network_acl_id" {
	value = aws_vpc.this.default_network_acl_id
}

output "default_security_group_id" {
	value = aws_vpc.this.default_security_group_id
}


################################################################################
# VPC
################################################################################
resource "aws_vpc" "this" {

  cidr_block                       = var.vpc_CIDR_default
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  
  tags	= merge(var.tags, {
		Name	= 	"${var.prj_name}-${var.env}-${var.aws_region_code}-vpc"
	})
}


