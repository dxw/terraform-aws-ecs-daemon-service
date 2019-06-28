resource "aws_ecs_task_definition" "main" {
  family                   = "${var.environment}-${var.service_name}"
  container_definitions    = "${var.task_definition}"
  task_role_arn            = "${var.task_role_arn}"
  network_mode             = "${var.task_network_mode}"
  cpu                      = "${var.task_cpu}"
  memory                   = "${var.task_memory}"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = "${var.task_execution_role_arn}"
  volume                   = ["${var.task_volumes}"]
}

# Service with bridge networking mode
resource "aws_ecs_service" "main" {
  count = "${var.task_network_mode == "bridge" ? 1 : 0 }"

  name            = "${var.environment}-${var.service_name}"
  iam_role        = "${var.ecs_service_role}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.main.arn}"

  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"

  health_check_grace_period_seconds = 30

  load_balancer {
    target_group_arn = "${var.lb_target_group_arn}"
    container_name   = "${var.container_name}"
    container_port   = "${var.container_port}"
  }

  scheduling_strategy = "DAEMON"
}

# Service with awsvpc networking mode
resource "aws_ecs_service" "main_awsvpc" {
  count = "${var.task_network_mode == "awsvpc" ? 1 : 0 }"

  name            = "${var.environment}-${var.service_name}"
  iam_role        = "${var.ecs_service_role}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.main.arn}"

  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"

  health_check_grace_period_seconds = 30

  load_balancer {
    target_group_arn = "${var.lb_target_group_arn}"
    container_name   = "${var.container_name}"
    container_port   = "${var.container_port}"
  }

  network_configuration {
    security_groups = ["${var.awsvpc_service_security_groups}"]
    subnets         = ["${var.awsvpc_service_subnetids}"]
  }

  scheduling_strategy = "DAEMON"
}
