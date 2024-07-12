cluster_name = "fargate-ecs-proyecto-gg"
services_name = ["be-svc-orders",
  "be-svc-payments",
  "be-svc-products",
"be-svc-shipping"]
tasks_definitions = ["be-taskdef-orders",
  "be-taskdef-payments",
  "be-taskdef-products",
"be-taskdef-shipping"]
ecr_names = ["proyecto-devops-gg-orders",
  "proyecto-devops-gg-payments",
  "proyecto-devops-gg-products",
"proyecto-devops-gg-shipping"]

