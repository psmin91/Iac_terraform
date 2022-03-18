#####################################################################
##	TemplateName:	fend_snets.tf
##	Purpose:		Terraform Template for Public Subnet
##	---------------------------------------------------------------
##	Version	| Date		    | Developer		    | Update Reason
##	1.0		  | 2022.03.11	| Hwang Gyu Yong	| First Version
##  1.1     | 2022.03.18  | Park Soo Min    | Modularization
#####################################################################

#####################################################################
##	Resource List
##	---------------------------------------------------------------
##	aws_subnet for Public - snet_fend
##  aws_route_table for Public Subnet - rt_fend
##  aws_route_table_association for Public Subnet & Routetable - aws_rt_snet_fend_asso
#####################################################################
##	Input Variables
##	------------------------------------------------------------------------------------------------------------------------
##	Variable for Creation		    | Meaning								                | Type      						            | from
##	------------------------------------------------------------------------------------------------------------------------
##  var.vpc_id            	    | VPC ID            					          | String    						            | ~modules/vpc/vpc.tf
##  local.igw_id                | Internet Gateway ID                   | String                            | igw.tf
##	var.prj_name				        | Code of Project Name or Service Name	| String							              | ~IaCTCL-dev/main.tf
##	var.env						          | Environment of System					        | String [dev | stg | prd | qa]		  | ~IaCTCL-dev/main.tf
##	var.aws_region				      | AWS Region Name						            | String [default: ap-northeast-2]	| ~IaCTCL-dev/main.tf
##	var.aws_region_code			    | AWS Region Code						            | String [default: an2]				      | ~IaCTCL-dev/main.tf
##	var.user_code				        | Creator Code (Employee No. of Creator)| String [XXXXX]					          | ~IaCTCL-dev/main.tf
##  var.map_public_ip_on_launch | VPC ID            					          | bool      						            | ~modules/vpc/vpc.tf
##  var.azs       				      | AWS Region Name(azs List)	            | List(String)	                    | ~IaCTCL-dev/main.tf
##  var.snet_fend_CIDR          | CIDR for Public Subnet                | List(String)                      | ~IaCTCL-dev/main.tf
##	local.tags					        | common tags							              | Map								                | ~IaCTCL-dev/main.tf
#####################################################################
##	Output Variables
##	------------------------------------------------------------------------------------------------------------------------
##	Variable for Output			| Meaning                                       | Type
##	------------------------------------------------------------------------------------------------------------------------
##  local.snet_fend_ids     | Resource ID of Public Subnet                  | List
##  local.rt_fend_ids       | Resource ID of Routetable for snet_fend_id    | List
##	------------------------------------------------------------------------------------------------------------------------

################### Resource Definition ##########################


locals {
	snet_fend_ids  = aws_subnet.snet_fend[*].id
	rt_fend_ids    = aws_route_table.rt_fend[*].id
}

output "snet_fend_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.snet_fend[*].id
}
output "rt_fend_ids" {
  description = "List of IDs of public route tables"
  value       = aws_route_table.rt_fend[*].id
}


################################################################################
# Publiс subnet & route
################################################################################
## Public Subnet
resource "aws_subnet" "snet_fend" {					# Subnet information for public
  count = (length(var.snet_fend_CIDR) > 0) ? length(var.snet_fend_CIDR)  : 0
    
  
  vpc_id      = var.vpc_id
  #element(a,b)는 list a에서 b번째 값을 리턴 / count.index 현재 for문의 index
    availability_zone	= element(var.azs,count.index)		# Availability Zone Information
    cidr_block	= element(var.snet_fend_CIDR,count.index)			# subnet CIDR
    map_public_ip_on_launch = var.map_public_ip_on_launch                    # Configuration attach Public IP to resource on Public Subnet
    depends_on = [aws_internet_gateway.default_igw]
    
    tags	= merge(var.tags, {
	Name	= 	format("${var.prj_name}-${var.env}-${var.aws_region_code}-snet-fend-%s",
                            substr(element(var.azs, count.index),-1,1),) } )
}

## Public Routetable
resource "aws_route_table" "rt_fend" {
	count = length(var.snet_fend_CIDR) > 0 ? length(var.snet_fend_CIDR) : 0
    vpc_id      = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = local.igw_id      # aws_internet_gateway.example.id
    }

	tags	= merge(var.tags, {
	    Name	= 	format("${var.prj_name}-${var.env}-${var.aws_region_code}-rt-fend-%s",
                            substr(element(var.azs, count.index),-1,1),) } )
	}
## Routetable Association : Public Subnet A & Public Routetable A
resource "aws_route_table_association" "aws_rt_snet_fend_asso" {
  count = length(var.snet_fend_CIDR) > 0 ? length(var.snet_fend_CIDR) : 0
  subnet_id      = aws_subnet.snet_fend[count.index].id
  route_table_id = aws_route_table.rt_fend[count.index].id
	}

