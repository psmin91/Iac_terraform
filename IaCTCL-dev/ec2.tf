###########################################
################### EC2 ###################
###########################################
module "security_group" {
  source  = "../modules/security_group"
  
  #enviroment
  prj_name        = local.tags.ServiceName
  env             = local.tags.Environment
  aws_region      = local.region
  aws_region_code = local.aws_region_code
  user_code       = local.tags.Creator
  
  #security group
  name = "ec2-SG"
  description = "Security group for example usage with EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  
  #tags
	tags = local.tags
}

/*
module "ec2_instance" {
  source  = "../modules/ec2_instance"
  
  #enviroment
  prj_name        = local.tags.ServiceName
  env             = local.tags.Environment
  aws_region      = local.region
  aws_region_code = local.aws_region_code
  user_code       = local.tags.Creator

  for_each = toset(["one", "two", "three"])

  name = "instance-${each.key}"

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  #tags
	tags = local.tags
}
*/