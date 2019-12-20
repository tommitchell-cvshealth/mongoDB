# credentials set by setting GOOGLE_CLOUD_KEYFILE in setenv.sh
provider "google" {
  project = "1095834490097"
  region  = "us-central1"
  zone    = "us-central1-b"
}
resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_compute_instance" "default" {
  name         = "vm-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-east1-b"
  project      = "healthcloud-architects"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  
  network_interface {
    network = "vpc-gke-01"
    subnetwork = "gke-nodes-kafka"
    subnetwork_project = "healthcloud-architects"

  }

  // Apply the firewall rule to allow external IPs to access this instance
  tags = ["mitchell", "mongo"]
}


output "ip" {
  value = ""
}
