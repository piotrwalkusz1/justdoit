provider "google" {
  project = "metal-mariner-231915"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}

data "google_client_config" "current" {}

resource "google_container_cluster" "default" {
  name               = "todo-app-kubernetes"
  initial_node_count = 1

  // Use legacy ABAC until these issues are resolved: 
  //   https://github.com/mcuadros/terraform-provider-helm/issues/56
  //   https://github.com/terraform-providers/terraform-provider-kubernetes/pull/73
  enable_legacy_abac = true

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
  }

  node_config {
    disk_size_gb = "10"
    machine_type = "n1-standard-2"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_storage_bucket" "storage" {
  name          = "piotrwalkusz1-storage"
  location      = "EU"
  force_destroy = "true"
}

resource "google_storage_bucket_iam_member" "storage-all" {
  bucket = "${google_storage_bucket.storage.name}"
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

provider "helm" {
  kubernetes {
    host                   = "${google_container_cluster.default.endpoint}"
    token                  = "${data.google_client_config.current.access_token}"
    client_certificate     = "${base64decode(google_container_cluster.default.master_auth.0.client_certificate)}"
    client_key             = "${base64decode(google_container_cluster.default.master_auth.0.client_key)}"
    cluster_ca_certificate = "${base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)}"
  }
}

resource "helm_release" "postgresql" {
  name      = "postgresql"
  chart     = "stable/postgresql"
  namespace = "todo-app"
}