terraform {
  # Версия terraform
  required_version = "0.12.5"
}

provider "google" {
  # Версия провайдера
  version = "~> 2.5"
  # ID проекта
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source         = "../modules/app"
  private_key    = "${var.private_key}"
  zone           = "${var.zone}"
  app_disk_image = "${var.disk_image}"
}
module "db" {
  source        = "../modules/db"
  private_key   = "${var.private_key}"
  zone          = "${var.zone}"
  db_disk_image = "${var.disk_image}"
}
module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["0.0.0.0/0"]
}
