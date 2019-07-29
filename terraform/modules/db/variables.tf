variable private_key {
  description = "Private key"
}
variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}
variable db_disk_image {
	description = "Disk image for reddit db"
	default = "reddit-base"
}
