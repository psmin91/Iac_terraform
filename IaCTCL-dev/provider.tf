terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {						## Create Cloud Provider Object
	region	= local.region	## Declear default region
	shared_credentials_files = ["/home/ec2-user/.aws/credentials"]	## Configure Credential Inform
#	version = "~> 4.0"
}