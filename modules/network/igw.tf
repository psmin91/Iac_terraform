#####################################################################
##	TemplateName:	igw.tf
##	Purpose:		Terraform Template for Internet Gateway
##	---------------------------------------------------------------
##	Version	| Date		    | Developer		    | Update Reason
##	1.0		| 2022.03.11	| Hwang Gyu Yong	| First Version
##  1.1     | 2022.03.18    | Park Soo Min      | Modularization
#####################################################################

#####################################################################
##	Resource List
##	---------------------------------------------------------------
##	aws_internet_gateway
#####################################################################
##	Input Variables
##	------------------------------------------------------------------------------------------------------------------------
##	Variable for Creation		| Meaning								| Type      						| from
##	------------------------------------------------------------------------------------------------------------------------
##  var.vpc_id               	| VPC ID            					| String    						| ~modules/vpc/vpc.tf
##	var.prj_name				| Code of Project Name or Service Name	| String							| ~IaCTCL-dev/main.tf
##	var.env						| Environment of System					| String [dev | stg | prd | qa]		| ~IaCTCL-dev/main.tf
##	var.aws_region				| AWS Region Name						| String [default: ap-northeast-2]	| ~IaCTCL-dev/main.tf
##	var.aws_region_code			| AWS Region Code						| String [default: an2]				| ~IaCTCL-dev/main.tf
##	var.user_code				| Creator Code (Employee No. of Creator)| String [XXXXX]					| ~IaCTCL-dev/main.tf
##	var.tags					| common tags							| Map								| ~IaCTCL-dev/main.tf
#####################################################################
##	Output Variables
##	------------------------------------------------------------------------------------------------------------------------
##	Variable for Output			| Meaning								| Type
##	------------------------------------------------------------------------------------------------------------------------
##  default_igw_id              | -                                     | String 
##	------------------------------------------------------------------------------------------------------------------------

################### Resource Definition ##########################

## Internet Gateway
resource "aws_internet_gateway" "default_igw" {
    vpc_id      = var.vpc_id

	tags	= merge(var.tags, {
		Name	= 	"${var.prj_name}-${var.env}-${var.aws_region_code}-igw"
	})
}

## Outputs of creation resources
locals {
	igw_id = aws_internet_gateway.default_igw.id
}

output "default_igw_id" {
	value = aws_internet_gateway.default_igw.id
}
