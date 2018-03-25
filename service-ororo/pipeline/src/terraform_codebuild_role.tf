
resource "aws_iam_role" "simple_stack_terraform_codebuild_role" {
  name = "SimpleStack_TestApply_Terraform_Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "simple_stack_terraform_codebuild_policy" {
  name        = "SimpleStack_TestApply_Terraform_Policy"
  path        = "/service-role/"
  description = "Policies needed by the CodeBuild project for TestApply the SimpleStack project"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:List*",
        "s3:PutObject"
      ]
    }
  ]
}
POLICY
}


resource "aws_iam_policy_attachment" "simple_stack_terraform_codebuild_attachment" {
  name       = "SimpleStack_TestApply_Terraform_Attachment"
  policy_arn = "${aws_iam_policy.simple_stack_terraform_codebuild_policy.arn}"
  roles      = ["${aws_iam_role.simple_stack_terraform_codebuild_role.id}"]
}


resource "aws_iam_role_policy_attachment" "simple_stack_terraform_terraform_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  role      = "${aws_iam_role.simple_stack_terraform_codebuild_role.id}"
}

