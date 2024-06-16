# Create an IAM role for App Runner to access the ECR repository
resource "aws_iam_role" "access_role" {
  name               = "apprunner-access-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "build.apprunner.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

# Create an IAM role policy that grants permissions to access ECR
resource "aws_iam_role_policy" "ecr_permissions" {
  # Name of the IAM role policy
  name = "ecr-permissions"
  # The role to which this policy will be attached
  role = aws_iam_role.access_role.id
  # The policy document that defines the permissions
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken"
        ],     
        # The resources this policy applies to; in this case, all ECR repositories   
        "Resource" : "*"
      }
    ]
  })
}

resource "null_resource" "wait_for_resources" {
  provisioner "local-exec" {
    command = "sleep 30" # Sleep for 30 seconds # https://github.com/pulumi/pulumi-aws/issues/1697
  }
}

# Create an AWS App Runner service
resource "aws_apprunner_service" "apprunner" {
  # The name of the App Runner service
  service_name = "apprunner"

  source_configuration {
    # Configuration for the authentication needed to access the ECR repository
    authentication_configuration {
      access_role_arn = aws_iam_role.access_role.arn
    }
    # Configuration for the image repository where the container image is stored
    image_repository {
      image_configuration {
        # Port on which the application listens
        port = "3000"
      }
      # The identifier for the image in ECR
      image_identifier = "058264229940.dkr.ecr.ap-south-1.amazonaws.com/whiteboard:latest"
      # Type of the image repository; change to "ECR_PUBLIC" if the image is in a public repository
      image_repository_type = "ECR"
    }
    # Whether auto deployments are enabled for the source repository
    auto_deployments_enabled = false
  }

  # Tags to apply to the App Runner service
  tags = {
    Name = "apprunner-service"
  }
  # Ensure App Runner depends on the null resource
  depends_on = [
   null_resource.wait_for_resources,
   aws_iam_role_policy.ecr_permissions,
   aws_iam_role.access_role 
  ]
}
