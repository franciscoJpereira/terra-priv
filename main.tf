module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = var.vpc_id
}

module "endpoints" {
  source = "./modules/endpoints"
  subnets_ids = var.subnets_ids
  vpc_id = var.vpc_id 
  s3_endpoint_sg_id = module.security_groups.s3_vpce_sg_id
  api_gw_sg_id = module.security_groups.api_gw_sg_id
}

module "api_gw" {
  source = "./modules/back/api"
  api_doc = "/home/franciscopereira/Documents/Pae/plataforma-tf/endpoints/api_body.json"
  api_name = "fran-rest-api-prueba"
  vpce_id = module.endpoints.api_gw_endpoint_id
}

/*
module "back_ingress" {
  source = "./modules/back/ingress_infra"
  vpc_id = var.vpc_id
  subnets_ids = var.subnets_ids
  alb_sg_id = module.security_groups.api_gw_lb_sg_id
  vpce_network_ips = module.endpoints.api_gw_endpoint_ips
  dev_env = var.dev_env
}

module "proxy_lambda" {
    count = var.dev_env ? 1 : 0
    source = "./modules/proxy_lambda"
    subnet_ids = var.subnets_ids
    bucket_name = var.s3_bucket_name 
    vpc_id = var.vpc_id
    proxy_lambda_sg_id = module.security_groups.lambda_proxy_sg_id
}

module "front_infra" {
  source = "./modules/front_infra"
  subnet_ids = var.subnets_ids
  dev_env = var.dev_env
  front_s3_bucket_name = var.s3_bucket_name
  vpc_id = var.vpc_id
  alb_sg_id = module.security_groups.fron_alb_sg_id
}
*/