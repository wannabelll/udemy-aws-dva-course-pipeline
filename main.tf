provider "aws" {
    region = var.region
  
}





resource "aws_iam_role" "role-elb-2026" {
  name = "role-elb-role-2026"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "tf-ellb" {
  name = "aws-elasticbeanstalk-ec2-role" # use the same name as the default instance profile

  role = aws_iam_role.role-elb-2026.name
}



resource "aws_elastic_beanstalk_application" "tf-test" {
  name                = "test-nodejs-app"
  description = "Testing tf-elb"
  
}

resource "aws_elastic_beanstalk_environment" "tf-test-env" {
  name                = "my-demo-env"
  application = aws_elastic_beanstalk_application.tf-test.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.4.1 running Node.js 22"
  tier = "WebServer"
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.tf-ellb.name
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCID"
    value = data.aws_vpc.my-vpc.id

  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.subnet)
  }
  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = var.instance_type
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }
}

output "url" {
  value = aws_elastic_beanstalk_environment.tf-test-env.endpoint_url
}