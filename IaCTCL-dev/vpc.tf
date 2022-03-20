locals {
  region = "us-west-1"
  aws_region_code = "uw2"
	tags	= {
		ServiceName = "IaCTCL"
		Environment	= "dev"
		Creator		= "10059"
		Operator	= "10059"
	  }
  }

module "vpc" {
  #choose vpc module
  source  = "../modules/vpc"

  #enviroment
  prj_name        = local.tags.ServiceName
  env             = local.tags.Environment
  aws_region      = local.region
  aws_region_code = local.aws_region_code
  user_code       = local.tags.Creator
  
  #Network
  vpc_CIDR_default  = "192.168.29.192/26"
  
  #options
  enable_dns_hostnames	= true
	enable_dns_support		= true
	instance_tenancy	  	= "default"
	
	#tags
	tags = local.tags
  }
