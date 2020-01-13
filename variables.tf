variable "environment" {
  description = "Logical name of the environment, will be used as prefix and in tags."
  type        = "string"
}

variable "enabled" {
  description = "Enable this module"
  type        = "string"
  default     = "true"
}

variable "task_role_arn" {
  description = "The AWS IAM role that will be provided to the task to perform AWS actions."
  type        = "string"
  default     = ""
}

variable "task_execution_role_arn" {
  description = "Task execution role"
  type        = "string"
}

variable "ecs_cluster_id" {
  description = "The id of the ECS cluster"
  type        = "string"
}

variable "service_name" {
  description = "Logical name of the service."
  type        = "string"
}

variable "lb_target_group_arn" {
  description = "Load Balancer Target Group ARN"
  type        = "string"
}

variable "task_definition" {
  description = "The AWS task definition of the containers to be created."
  type        = "string"
}

variable "task_network_mode" {
  description = "The network mode to be used in the task definiton. Supported modes are awsvpc and bridge."
  type        = "string"
  default     = "bridge"
}

variable "awsvpc_service_security_groups" {
  description = "List of security groups to be attached to service running in awsvpc network mode."
  type        = "list"
  default     = []
}

variable "awsvpc_service_subnetids" {
  description = "List of subnet ids to which a service is deployed in awsvpc mode."
  type        = "list"
  default     = []
}

variable "ecs_service_role" {
  default = ""
}

variable "task_cpu" {
  description = "Task CPU"
  type        = "string"
  default     = ""
}

variable "task_memory" {
  description = "Task Memory"
  type        = "string"
  default     = ""
}

variable "task_volumes" {
  description = "Task volumes"
  type        = "list"
  default     = []
}

variable "container_name" {
  description = "Container Name"
  type        = "string"
  default     = ""
}

variable "container_port" {
  description = "Container Port"
  type        = "string"
  default     = ""
}

variable "deployment_minimum_healthy_percent" {
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
  type        = "string"
  default     = "50"
}

variable "lb_health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647"
  type        = "string"
  default     = "0"
}
