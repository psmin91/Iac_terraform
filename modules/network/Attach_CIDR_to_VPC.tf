#####################################################################
##	TemplateName:	Attach_CIDR_to_VPC.tf
##	Purpose:		Terraform Template for Attachment CIDRs to VPC
##	---------------------------------------------------------------
##	Version	|	Date		    |	Developer		    | Update Reason
##	1.0		  | 2022.03.11	| Hwang Gyu Yong	| First Version
##  1.1     | 2022.03.18  | Park Soo Min    | Modularization
#####################################################################

#####################################################################
##	Resource List
##	---------------------------------------------------------------
##	aws_vpc_ipv4_cidr_block_association
#####################################################################
##	Input Variables
##	--------------------------------------------------------------------------------------
##	Variable for Creation		| Meaning								| Type      | from
##	--------------------------------------------------------------------------------------
##  local.vpc_id            | VPC ID                | String    | ~IaCTCL-dev/main.tf
##	var.vpc_CIDR_DBZone			| CIDR for DB Zone    	| String    | ~IaCTCL-dev/main.tf
##	var.vpc_CIDR_Uniq				| CIDR for Uniq Zone  	| String    | ~IaCTCL-dev/main.tf
##	var.vpc_CIDR_Dup				| CIDR for Dup. Zone  	| String    | ~IaCTCL-dev/main.tf
#####################################################################
##	Output Variables
##	--------------------------------------------------------------------------------------
##	Variable for Output			| Meaning								| Type
##	--------------------------------------------------------------------------------------
##	--------------------------------------------------------------------------------------

################### Resource Definition ##########################

resource "aws_vpc_ipv4_cidr_block_association" "cidr_dbzone" {
  #count 는 for문, ? 는 조건문(bool?True:False)
  #count = length(var.vpc_CIDR_DBZone) > 1 ? length(var.vpc_CIDR_DBZone) : 0
  count = (var.vpc_CIDR_DBZone == "0.0.0.0/0") ? 0 : 1
  vpc_id      = var.vpc_id
  cidr_block = var.vpc_CIDR_DBZone
	}
	
resource "aws_vpc_ipv4_cidr_block_association" "cidr_uniq" {
  count = (var.vpc_CIDR_Uniq  == "0.0.0.0/0") ? 0 : 1
  vpc_id      = var.vpc_id
  cidr_block = var.vpc_CIDR_Uniq
	}

resource "aws_vpc_ipv4_cidr_block_association" "cidr_dup" {
  count = (var.vpc_CIDR_Dup  == "0.0.0.0/0") ? 0 : 1
  vpc_id      = var.vpc_id
  cidr_block = var.vpc_CIDR_Dup
	}