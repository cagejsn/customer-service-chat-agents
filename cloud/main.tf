terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }
    openai = {
      source  = "registry.terraform.io/nventive/openai"
      version = "1.0.0-pre.1"
    }
  }

  required_version = ">= 1.7.1"
}

provider "aws" {
  region = "us-east-2"
}

provider "openai" {
  # api_key = "your api key or use the environment variable OPENAI_API_KEY"
}


// TODO figure out how to get it from the tf state
// TODO: config and secrets

// log group for ec2
resource "aws_cloudwatch_log_group" "logs" {
  name              = "logs"
  retention_in_days = 14

  tags = {
    app = "customer-support-chat"
  }
}


// ec2 role
resource "aws_iam_instance_profile" "server-role" {
  name = "server-role"
  role = aws_iam_role.server-role.name
}

resource "aws_iam_role" "server-role" {
  name = "server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    app = "customer-support-chat"
  }
}

resource "aws_iam_policy" "server-policy" {
  name        = "server-policy"
  path        = "/"
  description = "policy for interacting"

  policy = file("${path.module}/policy/ec2-policy.template.json")
}

resource "aws_iam_role_policy_attachment" "attach-cloud-watch-agent-needs" {
  role       = aws_iam_role.server-role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "attach-other-needs" {
  role       = aws_iam_role.server-role.name
  policy_arn = aws_iam_policy.server-policy.arn
}






