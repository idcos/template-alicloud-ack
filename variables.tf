variable "k8s_name_prefix" {
  description = "The name prefix used to create managed kubernetes cluster."
  default     = "tf-ack"
}

variable "zone_id" {
  description = "The zone for creating resources"
  default     = "cn-beijing-e"
}