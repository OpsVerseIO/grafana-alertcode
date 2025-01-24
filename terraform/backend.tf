# backend.tf

terraform {
  backend "s3" {
    bucket         = "<>"     # Your S3 bucket name
    key            = "<>"  # Path within the bucket (folder + state file name)
    region         = "<>"                   # AWS region where your S3 bucket is located
    encrypt        = true                          # Enable encryption for the state file
  }
}
