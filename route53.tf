resource "aws_route53_record" "docker-registry" {
  zone_id = "${var.route53_hosted_zone_id}"
  name = "${var.docker_registry_host_name}"
  type = "A"

  alias {
    name = "${aws_elb.docker-registry-elb.dns_name}"
    zone_id = "${aws_elb.docker-registry-elb.zone_id}"
    evaluate_target_health = true
  }
}