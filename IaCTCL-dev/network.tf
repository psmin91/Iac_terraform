module "network" {
  source  = "../modules/network"
  
  #enviroment
  prj_name        = local.tags.ServiceName
  env             = local.tags.Environment
  aws_region      = local.region
  aws_region_code = local.aws_region_code
  user_code       = local.tags.Creator
  
  #Module Output
  vpc_id          = module.vpc.vpc_id
  
  #Network
  vpc_CIDR_default  = "192.168.29.192/26"
  vpc_CIDR_DBZone = "192.168.29.160/27"
  vpc_CIDR_Uniq = "100.64.35.192/26"
  vpc_CIDR_Dup = "100.64.0.0/21"
  azs                 = ["${local.region}b", "${local.region}c"]
  snet_fend_CIDR      = ["192.168.29.192/27","192.168.29.224/27"]
  snet_bend_db_CIDR   = ["192.168.29.160/28","192.168.29.176/28"]
  snet_bend_uniq_CIDR = ["100.64.35.192/27","100.64.35.224/27"]
  snet_bend_dup_CIDR  = ["100.64.0.0/22","100.64.4.0/22"]
  
  #options
  map_public_ip_on_launch = true
  
  #tags
	tags = local.tags
  }
