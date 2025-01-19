data "aws_region" "current" {}


#variable "vpc_id" {
 # description = "ID of the VPC where the Elastic Beanstalk environment will be deployed"
# default = data.aws_vpc.default.id #Edit it with your VPC ID
#}
variable "region" {
   description = "Please state the region"
default = "us-east-1"
}
variable "instance_type" {
   default = "t2.micro"
  
}

data "aws_vpc" "my-vpc" {                                                                                                                            
  default = true                                                                                                                                      
}   

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.my-vpc.id]
  }
}

variable "subnet" {
    description = "Subnet ID of first zone"
    default = ["subnet-xx",  "subnet-xx"]  
  
}




data "aws_subnet" "default" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}


                                                                                              
                                                                                                                             
    

