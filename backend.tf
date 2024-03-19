terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    region  = "<YOUR_REGION>"
    profile = "default"
    key     = "terraformstatefile"
    bucket  = "<YOUR_BUCKET_NAME>"
  }
}
