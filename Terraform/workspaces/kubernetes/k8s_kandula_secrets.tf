##################################################################################
# Creating User For Kandula App
# Add User Secrets To K8s as secret 
##################################################################################


resource "aws_iam_user" "kandula_app_user" {
  name = "kandula-app-user"
}

resource "aws_iam_user_policy" "kandula_app_user_policy" {
  name = "kandula-app-user-policy"
  user = aws_iam_user.kandula_app_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "ec2:DescribeInstances",
              "ec2:TerminateInstances",
              "ec2:StartInstances",
              "ec2:StopInstances"
          ],
          "Resource": "*"
      }
  ]
}
EOF
}

resource "aws_iam_access_key" "kandula_app_user_access_key" {
  user = aws_iam_user.kandula_app_user.name
}

resource "kubernetes_secret_v1" "k8s_aws_secrets" {
  metadata {
    name = "aws-secrets"
  }

  data = {
    aws_access_key_id     = aws_iam_access_key.kandula_app_user_access_key.id
    aws_secret_access_key = aws_iam_access_key.kandula_app_user_access_key.secret
    aws_default_region    = "${var.aws_region}"
    db_password           = "${var.db_password}"
  }
}
