resource "aws_instance" "docker-registry" {
  ami = "${var.ecs_optimized_ami_id}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${split(",", var.ec2_security_group_ids)}"]
  subnet_id = "${element(split(",", var.subnet_ids), count.index % 2)}"
  iam_instance_profile = "${aws_iam_instance_profile.docker-registry.name}"
  key_name = "${var.ec2_key_pair_name}"
  user_data = <<EOF
#!/bin/bash

echo ECS_CLUSTER=docker-registry >> /etc/ecs/ecs.config
mkdir /auth
echo '${var.htpasswd}' > /auth/htpasswd
EOF

  tags {
    Name = "${var.tag_base_name}-${count.index}"
  }

  count = "${var.num_of_ec2_instances}"
}


