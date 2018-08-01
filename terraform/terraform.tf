terraform {
  backend "s3" {
    bucket = "hibicode-beer"
    key    = "beerstore-infra"
    region = "us-east-1"
  }
}
