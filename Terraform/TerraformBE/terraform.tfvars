vpc_name     = "be-devops-gg-vpc"
cluster_name = "fargate-cluster-be-gg"
services_name = ["be-payments-svc",
  "be-products-svc",
  "be-shipping-svc",
"be-orders-svc"]
tasks_definitions = ["be-taskdef-payments",
  "be-taskdef-products",
  "be-taskdef-shipping",
"be-taskdef-orders"]
target_group = ["be-payments-tg",
  "be-products-tg",
  "be-shipping-tg",
"be-orders-tg"]
load_balancers = ["be-payments-lb",
  "be-products-lb",
  "be-shipping-lb",
"be-orders-lb"]
container_definitions = ["be-payments",
  "be-products",
  "be-shipping",
"be-orders"]
container_images = [
  "333417458425.dkr.ecr.us-east-1.amazonaws.com/proyecto-devops-gg-payments:prod",
  "333417458425.dkr.ecr.us-east-1.amazonaws.com/proyecto-devops-gg-products:prod",
  "333417458425.dkr.ecr.us-east-1.amazonaws.com/proyecto-devops-gg-shipping:prod",
  "333417458425.dkr.ecr.us-east-1.amazonaws.com/proyecto-devops-gg-orders:prod"
]
ecr_names = ["proyecto-devops-gg-payments",
  "proyecto-devops-gg-products",
  "proyecto-devops-gg-shipping",
"proyecto-devops-gg-orders"]