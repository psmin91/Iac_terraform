#####################################################################
##	TemplateName:	bend_ngw.tf
##	Purpose:		Terraform Template for Private NAT Gateway
##	---------------------------------------------------------------
##	Version	| Date		    | Developer		    | Update Reason
##	1.0		| 2022.03.11	| Hwang Gyu Yong	| First Version
##  1.1     | 2022.03.18    | Park Soo Min      | Modularization
#####################################################################

#####################################################################
##	Resource List
##	---------------------------------------------------------------
##  Private NAT Gateway
#####################################################################
##	Input Variables
##	------------------------------------------------------------------------------------------------------------------------
##	Variable for Creation		| Meaning								| Type      						| from
##	------------------------------------------------------------------------------------------------------------------------
##  var.vpc_id            	    | VPC ID            					| String    						| ~modules/vpc/vpc.tf
##  local.igw_id                | Internet Gateway ID                   | String                            | igw.tf
##	var.prj_name				| Code of Project Name or Service Name	| String							| ~IaCTCL-dev/main.tf
##	var.env						| Environment of System					| String [dev | stg | prd | qa]		| ~IaCTCL-dev/main.tf
##	var.aws_region				| AWS Region Name						| String [default: ap-northeast-2]	| ~IaCTCL-dev/main.tf
##	var.aws_region_code			| AWS Region Code						| String [default: an2]				| ~IaCTCL-dev/main.tf
##	var.user_code				| Creator Code (Employee No. of Creator)| String [XXXXX]					| ~IaCTCL-dev/main.tf
##  local.snet_bend_uniq_ids    | Resource ID of Uniq zone Subnet       | List(String)                      | bend_snet_uniq.tf
##  local.snet_bend_db_ids      | Resource ID of Private Subnet         | List(String)                      | bend_snet_db.tf
##  local.snet_bend_dup_ids     | Resource ID of Dup zone Subnet        | List(String)                      | bend_snet_dup.tf
##  local.rt_fend_ids           | Resource ID of Public Subnet          | List(String)                      | fend_snets.tf
##  var.azs       				| AWS Region Name(azs List)	            | List(String)                      | ~IaCTCL-dev/main.tf
##	var.tags					| common tags							| Map								| ~IaCTCL-dev/main.tf
#####################################################################
##	Output Variables
##	------------------------------------------------------------------------------------------------------------------------
##	Variable for Output			| Meaning                                       | Type
##	------------------------------------------------------------------------------------------------------------------------
##  local.ngw_bend_ids          | Resource ID of Private NAT GW                 | List(String)
##	------------------------------------------------------------------------------------------------------------------------

################### Resource Definition ##########################
## Outputs of creation resources
locals {
	ngw_bend_ids    = aws_nat_gateway.ngw_bend[*].id
}
output "ngw_bend_ids" {
    value = aws_nat_gateway.ngw_bend[*].id
}

## Private NAT Gateway 
resource "aws_nat_gateway" "ngw_bend" {
    count = (length(local.snet_bend_uniq_ids) > 0) ? length(local.snet_bend_uniq_ids)  : 0    
    connectivity_type = "private"
    subnet_id     = local.snet_bend_uniq_ids[count.index]
    depends_on = [aws_subnet.snet_bend_uniq]
    
	tags	= merge(var.tags, {
		Name	= 	format("${var.prj_name}-${var.env}-${var.aws_region_code}-ngw-bend-%s",
                            substr(element(var.azs, count.index),-1,1),) } )
}

## Config routetable

## Add route information to routetables - Public Subnet to legacy interface
resource "aws_route" "route_fend_ngw_bend" {
    count = length(local.rt_fend_ids) > 0 ? length(local.rt_fend_ids) : 0
    route_table_id          = local.rt_fend_ids[count.index]
    destination_cidr_block  = "150.0.0.0/16"                 # config legacy interface IPs
    nat_gateway_id          = aws_nat_gateway.ngw_bend[count.index].id
    depends_on              = [aws_route_table.rt_fend]
}

## Add route information to routetables - Private Subnet(DB) to legacy interface
resource "aws_route" "route_bend_db_ngw_bend" {
    count = (length(local.rt_bend_db_ids) > 0) ? length(local.rt_bend_db_ids)  : 0
    route_table_id          = local.rt_bend_db_ids[count.index]
    destination_cidr_block  = "150.0.0.0/16"                     # config legacy interface IPs
    nat_gateway_id          = aws_nat_gateway.ngw_bend[count.index].id
    depends_on              = [aws_route_table.rt_bend_db]
}

## Add route information to routetables - Private Subnet(Dup) to legacy interface
resource "aws_route" "route_bend_dup_ngw_bend" {
    count = (length(local.rt_bend_dup_ids) > 0) ? length(local.rt_bend_dup_ids)  : 0
    route_table_id          = local.rt_bend_dup_ids[count.index]
    destination_cidr_block  = "150.0.0.0/16"                     # config legacy interface IPs
    nat_gateway_id          = aws_nat_gateway.ngw_bend[count.index].id
    depends_on              = [aws_route_table.rt_bend_dup]
}


