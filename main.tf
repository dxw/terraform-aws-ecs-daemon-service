resource "aws_ecs_task_definition" "main" {
  count                    = "${var.enabled == "true" ? 1 : 0}"
  family                   = "${var.environment}-${var.service_name}"
  container_definitions    = "${var.task_definition}"
  task_role_arn            = "${var.task_role_arn}"
  network_mode             = "${var.task_network_mode}"
  cpu                      = "${var.task_cpu}"
  memory                   = "${var.task_memory}"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = "${var.task_execution_role_arn}"

  dynamic "volume" {
    for_each = var.task_volumes

    content {
      name      = volume.value.name
      host_path = lookup(volume.value, "host_path", null) == null ? null : volume.value.host_path

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", null) == null ? [] : volume.value.docker_volume_configuration

        content {
          scope         = lookup(docker_volume_configuration.value, "scope", null) == null ? null : docker_volume_configuration.value.scope
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null) == null ? null : docker_volume_configuration.value.autoprovision
          driver        = lookup(docker_volume_configuration.value, "driver", null) == null ? null : docker_volume_configuration.value.driver
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null) == null ? null : docker_volume_configuration.value.driver_opts
          labels        = lookup(docker_volume_configuration.value, "labels", null) == null ? null : docker_volume_configuration.value.labels
        }
      }
    }
  }
}

# Service with bridge networking mode
resource "aws_ecs_service" "main" {
  count = (
    var.task_network_mode == "bridge" ? (
      var.enabled == "true" ? 1 : 0
    ) : 0
  )

  name            = "${var.service_name}"
  iam_role        = "${var.ecs_service_role}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${join("", aws_ecs_task_definition.main.*.arn)}"

  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"

  health_check_grace_period_seconds = var.lb_target_group_arn == "" ? null : "${var.lb_health_check_grace_period_seconds}"

  dynamic "load_balancer" {
    for_each = var.lb_target_group_arn == "" ? [] : [1]

    content {
      target_group_arn = "${var.lb_target_group_arn}"
      container_name   = "${var.container_name}"
      container_port   = "${var.container_port}"
    }
  }

  scheduling_strategy = "DAEMON"
}

# Service with awsvpc networking mode
resource "aws_ecs_service" "main_awsvpc" {
  count = (
    var.task_network_mode == "awsvpc" ? (
      var.enabled == "true" ? 1 : 0
    ) : 0
  )

  name            = "${var.service_name}"
  iam_role        = "${var.ecs_service_role}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${join("", aws_ecs_task_definition.main.*.arn)}"

  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"

  health_check_grace_period_seconds = var.lb_target_group_arn == "" ? null : "${var.lb_health_check_grace_period_seconds}"

  dynamic "load_balancer" {
    for_each = var.lb_target_group_arn == "" ? [] : [1]

    content {
      target_group_arn = "${var.lb_target_group_arn}"
      container_name   = "${var.container_name}"
      container_port   = "${var.container_port}"
    }
  }

  network_configuration {
    security_groups = "${var.awsvpc_service_security_groups}"
    subnets         = "${var.awsvpc_service_subnetids}"
  }

  scheduling_strategy = "DAEMON"
}
