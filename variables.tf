variable "k8s_name_prefix" {
  description = "The name prefix used to create managed kubernetes cluster."
  type        = string
  default     = "tf-ack"
}

variable "zone_id" {
  description = "The zone for creating resources"
  type        = string
  default     = "cn-beijing-e"
}

variable "iac_consul_image" {
  description = "iac consul服务镜像名称"
  type        = string
  default     = "registry.cn-beijing.aliyuncs.com/cloudiac-test-01/consul:latest"
}

variable "iac_mysql_image" {
  description = "iac mysql服务镜像名称"
  type        = string
  default     = "registry.cn-beijing.aliyuncs.com/cloudiac-test-01/mysql:5.7"
}

variable "iac_nginx_image" {
  description = "iac nginx 服务镜像名称"
  type        = string
  default     = "registry.cn-beijing.aliyuncs.com/cloudiac-test-01/cloudiac-web:latest"
}

variable "iac_cloudiac_image" {
  description = "iac cloudiac 后端服务镜像名称"
  type        = string
  default     = "registry.cn-beijing.aliyuncs.com/cloudiac-test-01/cloudiac:latest"
}

variable "node_ecs_cpu" {
  description = "节点ecs机器核心数"
  type        = number
  default     = 4
}

variable "node_ecs_memory_size" {
  description = "节点ecs内存数量"
  type        = number
  default     = 8
}

variable "vpc_cidr" {
  description = "vpc 网段区间"
  type        = string
  default     = "10.1.0.0/21"
}

variable "slb_spec" {
  description = "负载均衡实例规格"
  type        = string
  default     = "slb.s2.small"
}

variable "k8s_worker_number" {
  description = "Kubernetes集群的总工作节点数。默认值为3。最大限制为50"
  type        = number
  default     = 3
}

variable "k8s_new_nat_gateway" {
  description = "是否在创建kubernetes集群时创建新的nat网关。默认为true"
  type        = bool
  default     = true
}

variable "k8s_ssh_password" {
  description = "ssh登录集群节点的密码"
  type        = string
  sensitive   = true
  default     = "Yunjikeji#123"
}

variable "k8s_pod_cidr" {
  description = "pod网络的CIDR块。当cluster_network_type设置为flannel，你必须设定该参数。它不能与VPC CIDR相同，并且不能与VPC中的Kubernetes集群使用的CIDR相同，也不能在创建后进行修改。集群中允许的最大主机数量：256"
  type        = string
  default     = "172.20.0.0/16"
}

variable "k8s_service_cidr" {
  description = "服务网络的CIDR块。它不能与VPC CIDR相同，不能与VPC中的Kubernetes集群使用的CIDR相同，也不能在创建后进行修改"
  type        = string
  default     = "172.21.0.0/20"
}

variable "k8s_worker_disk_size" {
  description = "节点的数据磁盘大小。有效值范围[20〜32768]，以GB为单位。当worker_data_disk_category被呈现，则默认为40"
  type        = number
  default     = 40
}

variable "iac_nginx_replicas" {
  description = "副本数量"
  type        = number
  default     = 1
}

variable "iac_consul_replicas" {
  description = "副本数量"
  type        = number
  default     = 1
}

variable "iac_mysql_replicas" {
  description = "副本数量"
  type        = number
  default     = 1
}

variable "iac_portal_replicas" {
  description = "副本数量"
  type        = number
  default     = 1
}

variable "iac_runner_replicas" {
  description = "副本数量"
  type        = number
  default     = 1
}
