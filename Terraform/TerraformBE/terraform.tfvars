vpc_name     = "be-devops-gg-vpc"
cluster_name = "fargate-cluster-be-gg2" //Los nombres que terminan en 2, significa que tiene que ser unico y ya tenemos el tuyo creado ;)
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
target_group = ["be-payments-tg2",
                "be-shipping-tg2",
                "be-products-tg2",
                "be-orders-tg2"]
load_balancers = ["be-payments-lb",
                  "be-shipping-lb",
                  "be-products-lb",
                  "be-orders-lb"]
