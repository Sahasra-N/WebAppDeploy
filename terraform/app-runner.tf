resource "aws_apprunner_service" "apprunner" {
  service_name = "apprunner"

  source_configuration {
    # authentication_configuration {
    #   access_role_arn = aws_iam_role.access_role.arn
    # }
    image_repository {
      image_configuration {
        port = "8000"
      }
      image_identifier = "058264229940.dkr.ecr.ap-south-1.amazonaws.com/whiteboard:latest"
      # image_identifier      = "058264229940.dkr.ecr.ap-south-1.amazonaws.com/sahasra:latest"
      image_repository_type = "ECR" #"ECR_PUBLIC"
    }
    auto_deployments_enabled = false
  }

  tags = {
    Name = "apprunner-service"
  }
}


# resource "aws_iam_role" "access_role" {
#   name               = "apprunner-access-role"
#   assume_role_policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [{
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "tasks.apprunner.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy" "ecr_permissions" {
#   name   = "ecr-permissions"
#   role   = aws_iam_role.access_role.id
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [{
#       "Effect": "Allow",
#       "Action": [
#         "ecr:GetDownloadUrlForLayer",
#         "ecr:BatchCheckLayerAvailability",
#         "ecr:BatchGetImage",
#         "ecr:DescribeImages",
#         "ecr:GetAuthorizationToken"
#       ],
#       "Resource": "*"
#     }]
#   })
# }
