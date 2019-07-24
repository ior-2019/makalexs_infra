variable private_key {
  description = "Private key"
}
variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}
variable app_disk_image {
  description = "Disk image for reddit db"
  default = "reddit-base"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}