variable "aws_access_key" {
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret access key"
}

variable "aws_region" {
  description = "AWS region"
}

variable "vpc_id" {
  description = "The VPC Id"
}

variable "subnet_ids" {
  description = "The subnet Ids in the VPC Id"
}

variable "s3_bucket_name" {
  description = "s3 bucket name"
}

variable "ecs_optimized_ami_id" {
  description = "ecs-optimized ami id"
}

variable "htpasswd" {
  description = "htpasswd -cB htpasswd [username]"
}

variable "ec2_key_pair_name" {
  description = "Key pair name for EC2"
}

variable "docker_registry_host_name" {
  description = "The host name for docker-registry"
}

variable "ec2_security_group_ids" {

}

variable "elb_security_group_ids" {

}

variable "ssl_certificate_id" {

}

variable "route53_hosted_zone_id" {

}

variable "instance_type" {
  default = "t2.medium"
}

variable "tag_base_name" {

}

variable "num_of_ec2_instances" {

}
