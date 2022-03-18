#####################################################################
##	TemplateName:	bend_snet_dup.tf
##	Purpose:		Terraform Template for Private Subnet (Dup Zone) 
##	---------------------------------------------------------------
##	Version	| Date		    | Developer		    | Update Reason
##	1.0		  | 2022.03.11	| Hwang Gyu Yong	| First Version
##  1.1     | 2022.03.18  | Park Soo Min    | Modularization
#####################################################################

#####################################################################
##	Resource List
##	---------------------------------------------------------------
##	aws_subnet for Private Dup Zone	- snet_bend_dup
##  aws_route_table for Private Dup Subnet  - rt_bend_dup
##  aws_route_table_association for Private Subnet & Routetable - aws_rt_snet_bend_dup_asso
#####################################################################
##	Input Variables
##	------------------------------------------------------------------------------------------------------------------------
##	Variable for Creation		  | Meaning								                | Type      						            | from
##	------------------------------------------------------------------------------------------------------------------------
##  var.vpc_id            	  | VPC ID            					          | String    						            | ~modules/vpc/vpc.tf
###  local.nat_fend_id         | Public NAT Gateway ID                 | String                            | ???.tf
###  local.nat_bend_id         | Public NAT Gateway ID                 | String                            | ???.tf
##	var.prj_name				      | Code of Project Name or Service Name	| String							              | ~IaCTCL-dev/main.tf
##	var.env						        | Environment of System					        | String [dev | stg | prd | qa]		  | ~IaCTCL-dev/main.tf
##	var.aws_region				    | AWS Region Name						            | String [default: ap-northeast-2]	| ~IaCTCL-dev/main.tf
##	var.aws_region_code			  | AWS Region Code						            | String [default: an2]				      | ~IaCTCL-dev/main.tf
##	var.user_code				      | Creator Code (Employee No. of Creator)| String [XXXXX]					          | ~IaCTCL-dev/main.tf
##  var.snet_bend_dup_CIDR    | CIDR for dup zone Subnet.             | List(String)                      | ~IaCTCL-dev/main.tf
##  var.azs       				    | AWS Region Name(azs List)	            | List(String)                      | ~IaCTCL-dev/main.tf
##	var.tags					        | common tags							              | Map								                | ~IaCTCL-dev/main.tf
#####################################################################
##	Output Variables
##	------------------------------------------------------------------------------------------------------------------------
##	Variable for Output			  | Meaning									               | Type
##	------------------------------------------------------------------------------------------------------------------------
##  local.snet_bend_dup_id	  | Resource ID of Private Subnet dup      | List(String)
##  local.rt_bend_dup_id		  | Resource ID of Private Routetable dup  | List(String)
##	------------------------------------------------------------------------------------------------------------------------



locals {
	snet_bend_dup_ids  = aws_subnet.snet_bend_dup[*].id
	rt_bend_dup_ids    = aws_route_table.rt_bend_dup[*].id
}

output "snet_bend_dup_ids" {
  description = "List of IDs of private subnets"
    value = aws_subnet.snet_bend_dup[*].id
}
output "rt_bend_dup_ids" {
  description = "List of IDs of private route tables"
    value = aws_route_table.rt_bend_dup[*].id
}


################################################################################
# Dup subnet & route
################################################################################


resource "aws_subnet" "snet_bend_dup" {					# Subnet information for public
  count = (length(var.snet_bend_dup_CIDR) > 0) ? length(var.snet_bend_dup_CIDR)  : 0
    
  vpc_id      = var.vpc_id
	availability_zone	= element(var.azs,count.index)		# Availability Zone Information
	cidr_block	= element(var.snet_bend_dup_CIDR,count.index)			# subnet CIDR
  depends_on        = [aws_vpc_ipv4_cidr_block_association.cidr_dup]
  
	tags	= merge(var.tags, {
		Name	= 	format("${var.prj_name}-${var.env}-${var.aws_region_code}-snet-bend-dup-%s",
                            substr(element(var.azs, count.index),-1,1),) } )
	}
resource "aws_route_table" "rt_bend_dup" {
  count = (length(var.snet_bend_dup_CIDR) > 0) ? length(var.snet_bend_dup_CIDR)  : 0
  vpc_id      = var.vpc_id
/*	추후 추가해야 하는 라인 - 외부 통신을 위한 Public NAT Gateway로 routetable 설정 잡기
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${local.igw_id}"      # Public NAT Gateway ID
    }
*/
  tags	= merge(var.tags, {
	Name	= 	format("${var.prj_name}-${var.env}-${var.aws_region_code}-rt-bend-dup-%s",
                            substr(element(var.azs, count.index),-1,1),) } )
}
## Routetable Association : Private Subnet & Private Routetable
resource "aws_route_table_association" "aws_rt_snet_bend_dup_asso" {
  count = (length(var.snet_bend_dup_CIDR) > 0) ? length(var.snet_bend_dup_CIDR)  : 0
  subnet_id      = aws_subnet.snet_bend_dup[count.index].id
  route_table_id = aws_route_table.rt_bend_dup[count.index].id
}	