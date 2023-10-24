provider "google" {
  credentials = file("/Users/HARI/Desktop/Autozone-coding-challenge/Pub:Sub Terraform/key.json")
  project     = "celtic-hub-403000"
  region      = "us-central1" 
} 
# This section configures the Google Cloud provider for Terraform.
#The credentials attribute should point to your Google Cloud service account key file.
#project specifies the Google Cloud project where these resources will be created.
#region can be modified to your desired region.

resource "google_pubsub_topic" "example_topic" {
  count = 10000
  name  = "pubsub-topic-${count.index}"
  project = "celtic-hub-403000"

  labels = {
    "custom-label-1" = "value-1"
    "custom-label-2" = "value-2"
  }

  schema_settings {
    encoding = "JSON"
  }

# if you publish a message to this topic, it should be a JSON object. 
#Subscribers to the topic can then expect messages to be in JSON format and can parse and process the messages accordingly

  message_storage_policy {
    allowed_persistence_regions = ["us-central1"]
  }

  message_retention_duration = "7d"
}
#This block defines a Pub/Sub topic named "pubsub-topic-" followed by an index number from 0 to 9999. The count attribute specifies how many topics should be created.
#It sets custom labels for the topics, schema encoding to JSON, message storage policy, and message retention duration to 7 days.

# IAM Binding for Pub/Sub Topic 
resource "google_project_iam_binding" "pubsub-system@celtic-hub-403000.iam.gserviceaccount.com" {
  count   = 10000
  project = "celtic-hub-403000"
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:pubsub-system@celtic-hub-403000.iam.gserviceaccount.com"]
}
# This section assigns the "roles/pubsub.publisher" role to a service account for each of the 10,000 Pub/Sub topics.

# Service Account for Terraform
resource "google_service_account" "terraform_sa" {
  account_id   = "111167730891754625259"
  display_name = "pubsub-system"
}
# This block creates a service account named "Tpubsub-system" with the specified account ID "111167730891754625259"

resource "google_project_iam_binding" "terraform_sa_iam" {
  project = "celtic-hub-403000"
  role    = "roles/iam.serviceAccountTokenCreator"
  members = ["serviceAccount:${"pubsub-system@celtic-hub-403000.iam.gserviceaccount.com"}"]
}
# This section assigns the "roles/iam.serviceAccountTokenCreator" role to the Terraform service account. It allows the service account to create access tokens.

# Enable Google Pub/Sub API
resource "google_project_service" "pubsub_api" {
  project = "celtic-hub-403000"
  service = "pubsub.googleapis.com"
}
# This resource enables the Google Pub/Sub API in your the project.
