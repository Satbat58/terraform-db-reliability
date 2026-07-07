terraform {

  backend "s3" {

    bucket = "terraform-state-bucket"

    key = "prod/terraform.tfstate"

    region = "ap-south-1"

    encrypt = true

  }

}