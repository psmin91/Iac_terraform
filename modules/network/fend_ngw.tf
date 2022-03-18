#####################################################################
##	TemplateName:	fend_ngw.tf
##	Purpose:		Terraform Template for Public NAT Gateway
##	---------------------------------------------------------------
##	Version	| Date		    | Developer		    | Update Reason
##	1.0		| 2022.03.11	| Hwang Gyu Yong	| First Version
##  1.1     | 2022.03.18    | Park Soo Min      | Modularization
#####################################################################

#####################################################################
##	Resource List
##	---------------------------------------------------------------
##  EIP for Public NAT Gateway 
##  NAT Gateway 
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
##  local.snet_fend_a_id        | Resource ID of Public Subnet          | List(String)                      | fend_snets.tf
##  var.azs       				| AWS Region Name(azs List)	            | List(String)                      | ~IaCTCL-dev/main.tf
##	local.tags					| common tags							| Map								| ~IaCTCL-dev/main.tf
#####################################################################
##	Output Variables
##	------------------------------------------------------------------------------------------------------------------------
##	Variable for Output		    | Meaning                                   | Type
##	------------------------------------------------------------------------------------------------------------------------
##  local.eip_ngw_ids           | EIP for Public NAT Gateway                | List(String)
##  local.ngw_fend_ids          | Resource ID of Public NAT GW              | List(String)
##	------------------------------------------------------------------------------------------------------------------------

################### Resource Definition ##########################

## EIP for NAT gateway
resource "aws_eip" "eip_ngw" {
    count = length(var.snet_fend_CIDR) > 0 ? length(var.snet_fend_CIDR) : 0
    vpc = true
    
    tags	= merge(var.tags, {
		Name	= 	format("${var.prj_name}-${var.env}-${var.aws_region_code}-eip-ngw-%s",
                            substr(element(var.azs, count.index),-1,1),) } )	
}

## Public NAT Gateway
resource "aws_nat_gateway" "ngw_fend" {
    count = length(var.snet_fend_CIDR) > 0 ? length(var.snet_fend_CIDR) : 0
    allocation_id = aws_eip.eip_ngw[count.index].id
    subnet_id     = local.snet_fend_ids[count.index]
    
    depends_on = [aws_internet_gateway.default_igw]

    tags	= merge(var.tags, {
	    Name	= 	format("${var.prj_name}-${var.env}-${var.aws_region_code}-ngw-fend-%s",
                            substr(element(var.azs, count.index),-1,1),) } )
}
## Add route information to routetables
resource "aws_route" "route_bend_db_ngw" {
    count = (length(var.snet_bend_db_CIDR) > 0) ? length(var.snet_bend_db_CIDR)  : 0
    route_table_id          = local.rt_bend_db_ids[count.index]
    destination_cidr_block  = "0.0.0.0/0"
    nat_gateway_id          = aws_nat_gateway.ngw_fend[count.index].id
    depends_on              = [aws_route_table.rt_bend_db]
}
resource "aws_route" "route_bend_uniq_ngw" {
    count = (length(var.snet_bend_uniq_CIDR) > 0) ? length(var.snet_bend_uniq_CIDR)  : 0
    route_table_id          = local.rt_bend_uniq_ids[count.index]
    destination_cidr_block  = "0.0.0.0/0"
    nat_gateway_id          = aws_nat_gateway.ngw_fend[count.index].id
    depends_on              = [aws_route_table.rt_bend_uniq]
}

resource "aws_route" "route_bend_dup_ngw" {
    count = (length(var.snet_bend_dup_CIDR) > 0) ? length(var.snet_bend_dup_CIDR)  : 0
    route_table_id          = local.rt_bend_dup_ids[count.index]
    destination_cidr_block  = "0.0.0.0/0"
    nat_gateway_id          = aws_nat_gateway.ngw_fend[count.index].id
    depends_on              = [aws_route_table.rt_bend_dup]
}

## Outputs of creation resources
locals {
	eip_ngw_ids  = aws_eip.eip_ngw[*].id
	ngw_fend_ids    = aws_nat_gateway.ngw_fend[*].id
}

output "eip_ngw_ids" {
    value = aws_eip.eip_ngw[*].id
}

output "ngw_fend_ids" {
    value = aws_nat_gateway.ngw_fend[*].id
}