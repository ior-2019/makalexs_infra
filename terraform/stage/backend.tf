terraform {
  backend "gcs" {
    bucket = "starry-aegis-244806"
    prefix = "stage"
  }
}