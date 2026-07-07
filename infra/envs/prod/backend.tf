# terraform {

#   backend "s3" {

#     bucket = "terraform-state-bucket"

#     key = "prod/terraform.tfstate"

#     region = "ap-south-1"

#     encrypt = true

#   }

# }

# for local development only otherwise must use above
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}