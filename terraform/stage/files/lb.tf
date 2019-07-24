resource "google_compute_global_forwarding_rule" "app" {
  name       = "app-forwarding-rule"
  target     = "${google_compute_target_tcp_proxy.app.self_link}"
  port_range = "25"
}

resource "google_compute_target_tcp_proxy" "app" {
  name            = "app-tcp-proxy"
  backend_service = "${google_compute_backend_service.app.self_link}"
}

resource "google_compute_backend_service" "app" {
  name      = "app-backend-service"
  port_name = "tcp"
  protocol  = "TCP"

  backend {
    group = "${google_compute_instance_group.app.self_link}"
  }

  health_checks = [
    "${google_compute_health_check.app.self_link}",
  ]
}

resource "google_compute_instance_group" "app" {
  name        = "app-instance-group"
  description = "app instance group"
  
  instances = ["${google_compute_instance.app.*.self_link}"]

  named_port {
    name = "tcp"
    port = "9292"
  }

  zone = "${var.zone}"
}

resource "google_compute_health_check" "app" {
  name               = "app-health-check"
  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "9292"
  }
}