vpc_name = "be-devops-gg-vpc"
cluster_name = "fargate-ecs-proyecto-gg"
services_name = ["be-orders-svc",
  "be-payments-svc",
  "be-products-svc",
"be-shipping-svc"]
tasks_definitions = ["be-taskdef-orders",
  "be-taskdef-payments",
  "be-taskdef-products",
"be-taskdef-shipping"]
ecr_names = ["proyecto-devops-gg-orders",
  "proyecto-devops-gg-payments",
  "proyecto-devops-gg-products",
"proyecto-devops-gg-shipping"]

