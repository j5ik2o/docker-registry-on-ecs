resource "aws_ecs_task_definition" "docker-registry" {
  family = "docker-registry"
  container_definitions = <<EOF
[
    {
        "name": "docker-registry",
        "image": "registry:2.2",
        "cpu": 10,
        "memory": 1024,
        "essential": true,
        "portMappings": [
            {
                "containerPort": 5000,
                "hostPort": 5000
            }
        ],
        "environment": [
            { "name": "REGISTRY_STORAGE", "value": "s3" },
            { "name": "REGISTRY_STORAGE_S3_REGION", "value": "${var.aws_region}" },
            { "name": "REGISTRY_STORAGE_S3_BUCKET", "value": "${var.s3_bucket_name}" },
            { "name": "REGISTRY_AUTH", "value": "htpasswd" },
            { "name": "REGISTRY_AUTH_HTPASSWD_PATH", "value": "/auth/htpasswd" },
            { "name": "REGISTRY_AUTH_HTPASSWD_REALM", "value": "basic-realm" }
        ],
        "mountPoints": [
            {
                "sourceVolume": "auth",
                "containerPath": "/auth",
                "readOnly": true
            }
        ]
    }
]
EOF

  volume {
    name = "auth"
    host_path = "/auth"
  }
}



resource "aws_ecs_cluster" "docker-registry" {
  name = "docker-registry"
}

resource "aws_ecs_service" "docker-registry" {
  name = "docker-registry"
  cluster = "${aws_ecs_cluster.docker-registry.id}"
  task_definition = "${aws_ecs_task_definition.docker-registry.arn}"
  desired_count = 2
  deployment_maximum_percent = 100
  deployment_minimum_healthy_percent = 0

  iam_role        = "${aws_iam_role.docker-registry.arn}"
  depends_on      = ["aws_iam_role_policy.docker-registry"]

  load_balancer {
    elb_name       = "${aws_elb.docker-registry-elb.id}"
    container_name = "docker-registry"
    container_port = 5000
  }

}

