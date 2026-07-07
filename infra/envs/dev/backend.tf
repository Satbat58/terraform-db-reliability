# terraform {

#   backend "s3" {

#     bucket = "terraform-state-bucket"

#     key = "dev/terraform.tfstate"

#     region = "ap-south-1"

#     encrypt = true

#   }

# }

# For local development only otherwise must use above
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}