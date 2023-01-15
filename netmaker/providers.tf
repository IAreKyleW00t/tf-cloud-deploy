provider "aws" {
  region = "us-east-2" # Ohio
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
