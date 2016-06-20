resource "aws_instance" "docker-registry" {
  ami = "${var.ecs_optimized_ami_id}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${split(",", var.ec2_security_group_ids)}"]
  subnet_id = "${element(split(",", var.subnet_ids), count.index % 2)}"
  iam_instance_profile = "${aws_iam_instance_profile.docker-registry.name}"
  key_name = "${var.key_name}"
  user_data = <<EOF
#!/bin/bash

echo ECS_CLUSTER=docker-registry >> /etc/ecs/ecs.config
mkdir /auth
echo '${var.htpasswd}' > /auth/htpasswd
EOF

  tags {
    Name = "${var.ec2_base_name}-${count.index}"
  }

  count = 2
}

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
    Name = "${var.ec2_base_name}"
  }
}
