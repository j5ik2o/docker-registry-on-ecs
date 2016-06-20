resource "aws_elb" "docker-registry-elb" {
  name = "docker-registry-elb"
  security_groups = [
    "${split(",", var.elb_security_group_ids)}"]
  subnets = [
    "${split(",", var.subnet_ids)}"]
  instances = ["${aws_instance.docker-registry.*.id}"]

  /*
  listener {
    instance_port = 5000
    instance_protocol = "http"
    lb_port = 5000
    lb_protocol = "http"
  }*/

  listener {
    instance_port = 5000
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.ssl_certificate_id}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:5000/"
    interval = 30
  }

  connection_draining = false

  tags {
    Name = "${var.tag_base_name}"
  }
}