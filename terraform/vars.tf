variable "AWS_ACCESS_KEY_ID" {
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
}

variable "AWS_SESSION_TOKEN" {
  type = string
}

variable "aws_policy_attachments" {
  type    = list(string)
  default = ["arn:aws-us-gov:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy", "arn:aws-us-gov:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"]
}

variable "aws_iam_role_name" {
  description = "Name of the IAM role to create"
  type        = string
}

variable "github_owner" {
  description = "GitHub organization or user name"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository names"
  type        = list(string)
}
