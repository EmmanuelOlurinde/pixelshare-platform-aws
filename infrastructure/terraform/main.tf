module "network" {
  source       = "./modules/network"
  project_name = var.project_name
}

module "compute" {
  source       = "./modules/compute"
  project_name = var.project_name
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "storage" {
  source       = "./modules/storage"
  project_name = var.project_name
}

module "secrets" {
  source       = "./modules/secrets"
  project_name = var.project_name
}

module "monitoring" {
  source       = "./modules/monitoring"
  project_name = var.project_name
}

module "lambda" {
  source       = "./modules/lambda"
  project_name = var.project_name
}

module "dynamodb" {
  source       = "./modules/dynamodb"
  project_name = var.project_name
}

