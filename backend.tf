terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    region  = "eu-north-1"
    profile = "default"
    key     = "terraformstatefile"
    bucket  = "yh-terraformstatebucket182"
  }
}
