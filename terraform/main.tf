terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = "us-gov-west-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  token      = var.AWS_SESSION_TOKEN
}

data "aws_caller_identity" "current" {}

import {
  to = aws_iam_openid_connect_provider.github_actions
  id = "arn:aws-us-gov:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

# Assume role policy
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for repo in var.github_repo : "repo:${var.github_owner}/${repo}:*"]
    }
  }
}

# Create IAM role
resource "aws_iam_role" "iam_role" {
  name               = var.aws_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Define GitHub Actions inline policy
data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "ecs:RegisterTaskDefinition",
      "ecs:DescribeTaskDefinition",
      "ecs:TagResource",
      "ecs:UntagResource",
      "iam:PassRole",
      "ecr:DescribeImages"
    ]
    resources = ["*"]
  }
}

# Attach GitHub Actions inline policy
resource "aws_iam_role_policy" "policy" {
  name   = "gh-actions"
  role   = aws_iam_role.iam_role.id
  policy = data.aws_iam_policy_document.policy.json
}

# Attach AWS-managed policies
resource "aws_iam_role_policy_attachment" "aws_policies" {
  role       = aws_iam_role.iam_role.name
  count      = length(var.aws_policy_attachments)
  policy_arn = element(var.aws_policy_attachments, count.index)
}
