output "docker-registry.dns_name" {
  value = "${aws_route53_record.docker-registry.name}"
}
