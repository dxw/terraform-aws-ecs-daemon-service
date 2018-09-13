variable "environment" {
  description = "Logical name of the environment, will be used as prefix and in tags."
  type        = "string"
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
