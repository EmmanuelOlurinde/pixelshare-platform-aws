output "s3_images_bucket_name" {
  value = module.storage.bucket_name
}

output "db_secret_name" {
  value = module.secrets.db_secret_name
}


output "image_bucket" {
  value = module.storage.bucket_name
}

output "dynamodb_table" {
  value = module.dynamodb.table_name
}
