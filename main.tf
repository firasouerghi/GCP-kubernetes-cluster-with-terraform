

/* network resource that our GKE cluster is going to use */
resource "google_compute_network" "vpc_net" {
  name                    = "${var.project}-vpc"
  auto_create_subnetworks = "false"
}


/* subnet resource definition  */


resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "${var.project}-subnet"
  region        = var.region
  network       = google_compute_network.vpc_net.name
  ip_cidr_range = "10.10.0.0/24"
}


/* Service account resource */


resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}


/* GKE cluster resource */


resource "google_container_cluster" "primary" {
  name                     = "${var.project}-gke"
  location                 = var.zone
  remove_default_node_pool = true
  initial_node_count       = var.gke_num_nodes
  network                  = google_compute_network.vpc_net.name
  subnetwork               = google_compute_subnetwork.vpc_subnet.name
  node_config {
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

}



/* Separately Managed Node Pool */


resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      env     = var.environment
      project = var.project
    }
    service_account = google_service_account.default.email
    machine_type    = var.machine_types[var.environment]
    tags            = ["gke-node", "${var.project}-gke"]

  }
}

