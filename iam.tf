resource "aws_iam_role" "docker-registry" {
  name = "docker-registry"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ecs.amazonaws.com", "ec2.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "docker-registry" {
  name = "docker-registry"
  role = "${aws_iam_role.docker-registry.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket_name}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket_name}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecs:CreateCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:StartTelemetrySession",
                "ecs:Submit*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
              "elasticloadbalancing:Describe*",
              "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
              "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
              "ec2:Describe*",
              "ec2:AuthorizeSecurityGroupIngress"
            ],
            "Resource": [
              "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "docker-registry" {
  name = "docker-registry"
  roles = [
    "${aws_iam_role.docker-registry.name}"]
}
