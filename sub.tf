provider "google" {
  credentials = file("/Users/HARI/Desktop/Autozone-coding-challenge/Pub:Sub Terraform/key.json")
  project     = "celtic-hub-403000"
  region      = "us-central1"  
}

resource "google_pubsub_topic" "pubsub_topic" {
  name    = "pubsub-topic"
  project = "celtic-hub-403000"
}

resource "google_pubsub_subscription" "example_subscriber" {
  count    = 10
  name     = "pubsub-subscriber-${count.index}"
  topic    = google_pubsub_topic.pubsub_topic.name
  project  = "celtic-hub-403000"

  # Optional: Define any other configuration settings for the subscribers, such as acknowledgment deadline, etc.
  # acknowledgment_deadline = 30
}

# IAM Binding for Pub/Sub Subscribers (optional)
resource "google_project_iam_binding" "example_subscriber_iam" {
  count   = 10
  project = "celtic-hub-403000"
  role    = "roles/pubsub.subscriber"
  members = ["serviceAccount:pubsub-system@celtic-hub-403000.iam.gserviceaccount.com"]
}

# Service Account for Terraform (optional)
resource "google_service_account" "terraform_sa" {
  account_id   = "111167730891754625259"
  display_name = "pubsub-system"
}

resource "google_project_iam_binding" "terraform_sa_iam" {
  project = "celtic-hub-403000"
  role    = "roles/iam.serviceAccountTokenCreator"
  members = ["serviceAccount:${google_service_account.terraform_sa.email}"]
}

# Enable Google Pub/Sub API (optional)
resource "google_project_service" "pubsub_api" {
  project = "celtic-hub-403000"
  service = "pubsub.googleapis.com"
}
