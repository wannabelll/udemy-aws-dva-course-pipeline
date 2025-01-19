output "vpc-id" {
    value =  data.aws_vpc.my-vpc.id  
}

output "aws_subnet_ids" {
  value = [for s in data.aws_subnet.default: s.id]
}

output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.default: s.cidr_block]
  }

output "region-name" {
  value = data.aws_region.current
}
