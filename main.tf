provider "google" {
  version = "3.10.0"
  credentials = file(var.credentials_file)
  project = var.project
  region = var.region
  zone = var.zone
}
resource "random_id" "db_name_suffix" {
  byte_length = 4
}
resource "google_sql_database_instance" "mysql" {
  name = "mysql-instance-${random_id.db_name_suffix.hex}"
  database_version = "MYSQL_5_7"
  settings{
    tier = "db-f1-micro"
     user_labels = {
      "environment" = "development"
    }
    maintenance_window {
      day  = "1"
      hour = "4"
    }
    backup_configuration {
      enabled = true
      start_time = "04:00"
    } 
  }
}
resource "google_sql_user" "users" {
  name     = "maxwellcawfield"
  instance = google_sql_database_instance.mysql.name
  password = "ultrasecret"
}
resource "google_sql_database" "database" {
  name     = "my-db"
  instance = google_sql_database_instance.mysql.name
}