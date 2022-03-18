#####################################################################
##	TemplateName:	bend_snet_uniq.tf
##	Purpose:		Terraform Template for Private Subnet (uniq Zone) 
##	---------------------------------------------------------------
##	Version	| Date		    | Developer		    | Update Reason
##	1.0		  | 2022.03.11	| Hwang Gyu Yong	| First Version
##  1.1     | 2022.03.18  | Park Soo Min    | Modularization
#####################################################################

#####################################################################
##	Resource List
##	---------------------------------------------------------------
##	aws_subnet for Private uniq Zone	- snet_bend_uniq
##  aws_route_table for Private uniq Subnet  - rt_bend_uniq
##  aws_route_table_association for Private Subnet & Routetable - aws_rt_snet_bend_uniq_asso
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
##  var.snet_bend_uniq_CIDR   | CIDR for uniq zone Subnet.            | List(String)                      | ~IaCTCL-dev/main.tf
##  var.azs       				    | AWS Region Name(azs List)	            | List(String)                      | ~IaCTCL-dev/main.tf
##	var.tags					        | common tags							              | Map								                | ~IaCTCL-dev/main.tf
#####################################################################
##	Output Variables
##	------------------------------------------------------------------------------------------------------------------------
##	Variable for Output			  | Meaning									                | Type
##	------------------------------------------------------------------------------------------------------------------------
##  local.snet_bend_uniq_id	  | Resource ID of Private Subnet Uniq      | List(String)
##  local.rt_bend_uniq_id		  | Resource ID of Private Routetable Uniq  | List(String)
##	------------------------------------------------------------------------------------------------------------------------




locals {
	snet_bend_uniq_ids  = aws_subnet.snet_bend_uniq[*].id
	rt_bend_uniq_ids    = aws_route_table.rt_bend_uniq[*].id
}

output "snet_bend_uniq_ids" {
  description = "List of IDs of private subnets"
    value = aws_subnet.snet_bend_uniq[*].id
}
output "rt_bend_uniq_ids" {
  description = "List of IDs of private route tables"
    value = aws_route_table.rt_bend_uniq[*].id
}

################################################################################
# Uniq subnet & route
################################################################################


resource "aws_subnet" "snet_bend_uniq" {					# Subnet information for public
  count = (length(var.snet_bend_uniq_CIDR) > 0) ? length(var.snet_bend_uniq_CIDR)  : 0
    
  vpc_id      = var.vpc_id
	availability_zone	= element(var.azs,count.index)		# Availability Zone Information
	cidr_block	= element(var.snet_bend_uniq_CIDR,count.index)			# subnet CIDR
	depends_on        = [aws_vpc_ipv4_cidr_block_association.cidr_uniq]
	
	tags	= merge(var.tags, {
		Name	= 	format("${var.prj_name}-${var.env}-${var.aws_region_code}-snet-bend-uniq-%s",
                            substr(element(var.azs, count.index),-1,1),) } )
	}
	
resource "aws_route_table" "rt_bend_uniq" {
  count = (length(var.snet_bend_uniq_CIDR) > 0) ? length(var.snet_bend_uniq_CIDR)  : 0
  vpc_id      = var.vpc_id
/*	추후 추가해야 하는 라인 - 외부 통신을 위한 Public NAT Gateway로 routetable 설정 잡기
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${local.igw_id}"      # Public NAT Gateway ID
    }
*/
  tags	= merge(var.tags, {
	Name	= 	format("${var.prj_name}-${var.env}-${var.aws_region_code}-rt-bend-uniq-%s",
                            substr(element(var.azs, count.index),-1,1),) } )
}
## Routetable Association : Private Subnet & Private Routetable
resource "aws_route_table_association" "aws_rt_snet_bend_uniq_asso" {
  count = (length(var.snet_bend_uniq_CIDR) > 0) ? length(var.snet_bend_uniq_CIDR)  : 0
  subnet_id      = aws_subnet.snet_bend_uniq[count.index].id
  route_table_id = aws_route_table.rt_bend_uniq[count.index].id
}	