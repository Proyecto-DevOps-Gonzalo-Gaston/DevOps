vpc_name     = "be-devops-gg-vpc"
cluster_name = "fargate-cluster-be-gg2" //Los nombres que terminan en 2, significa que tiene que ser unico y ya tenemos el tuyo creado ;)
services_name = ["be-orders-svc",
  "be-payments-svc",
  "be-products-svc",
"be-shipping-svc"]
tasks_definitions = ["be-taskdef-orders2",
  "be-taskdef-payments2",
  "be-taskdef-products2",
"be-taskdef-shipping2"]
ecr_names = ["proyecto-devops-gg-orders2",
  "proyecto-devops-gg-payments2",
  "proyecto-devops-gg-products2",
"proyecto-devops-gg-shipping2"]
target_group = ["be-payments-tg2",
  "be-shipping-tg2",
  "be-products-tg2",
"be-orders-tg2"]
load_balancers = ["be-payments-lb2",
  "be-shipping-lb2",
  "be-products-lb2",
"be-orders-lb2"]
container_definitions = ["be-payments",
  "be-shipping",
  "be-products",
"be-orders"]
 container_images = [
  "333417458425.dkr.ecr.us-east-1.amazonaws.com/proyecto-devops-gg-payments",
  "333417458425.dkr.ecr.us-east-1.amazonaws.com/proyecto-devops-gg-shipping",
  "333417458425.dkr.ecr.us-east-1.amazonaws.com/proyecto-devops-gg-products",
  "333417458425.dkr.ecr.us-east-1.amazonaws.com/proyecto-devops-gg-orders"
]