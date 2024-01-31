terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  # Credentials only needs to be set if you do not have the GOOGLE_APPLICATION_CREDENTIALS set
  credentials = "/workspaces/data-engineering-zoomcamp/01-docker-terraform/1_terraform_gcp/terraform/keys/my_google_credentials.json"
  project = "galvanic-crow-412709"
  region  = "us-central1"
}



resource "google_storage_bucket" "data-lake-bucket" {
  name     = "galvanic-crow-412709-bucket"
  location = "US"

  # Optional, but recommended settings:
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 3 // days
    }
  }

  force_destroy = true
}


resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id = "example_dataset"
  project    = "galvanic-crow-412709"
  location   = "US"
}