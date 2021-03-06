resource "random_uuid" "this" {}

# 默认资源名称。
locals {
  k8s_name           = substr(join("-", [var.k8s_name_prefix, random_uuid.this.result]), 0, 63)
  new_vpc_name       = "vpc-for-${local.k8s_name}"
  new_vsw_name       = "vsw-for-${local.k8s_name}"
  log_project_name   = "log-for-${local.k8s_name}"
  load_balancer_name = "iac-nginx-${local.k8s_name}"
}

# 节点ECS实例配置。
data "alicloud_instance_types" "default" {
  cpu_core_count       = var.node_ecs_cpu
  memory_size          = var.node_ecs_memory_size
  kubernetes_node_role = "Worker"
}

# 专有网络。
resource "alicloud_vpc" "default" {
  vpc_name   = local.new_vpc_name
  cidr_block = var.vpc_cidr
}

# 交换机。
resource "alicloud_vswitch" "vswitches" {
  vswitch_name = local.new_vsw_name
  vpc_id       = alicloud_vpc.default.id
  cidr_block   = var.vpc_cidr
  zone_id      = var.zone_id
}

# 负载均衡
resource "alicloud_slb_load_balancer" "default" {
  load_balancer_name = local.load_balancer_name
  address_type       = "intranet"
  load_balancer_spec = var.slb_spec
  vswitch_id         = alicloud_vswitch.vswitches.id
  tags = {
    info = "create for internet"
  }
}


# Kubernetes托管版。
resource "alicloud_cs_managed_kubernetes" "default" {
  # Kubernetes集群名称。
  name = local.k8s_name
  # 新的Kubernetes集群将位于的vswitch。指定一个或多个vswitch的ID。它必须在availability_zone指定的区域中。
  worker_vswitch_ids    = split(",", join(",", alicloud_vswitch.vswitches.*.id))
  new_nat_gateway       = false
  worker_instance_types = [data.alicloud_instance_types.default.instance_types[0].id]
  worker_number         = var.k8s_worker_number
  password              = var.k8s_ssh_password
  pod_cidr              = var.k8s_pod_cidr
  service_cidr          = var.k8s_service_cidr
  # 是否为kubernetes的节点安装云监控。
  install_cloud_monitor = true
  # 是否为API Server创建Internet负载均衡。默认为false。
  slb_internet_enabled = true
  # 节点的系统磁盘类别。其有效值为cloud_ssd和cloud_efficiency。默认为cloud_efficiency。
  worker_disk_category = "cloud_efficiency"
  # 节点的数据磁盘类别。其有效值为cloud_ssd和cloud_efficiency，如果未设置，将不会创建数据磁盘。
  worker_data_disk_category = "cloud_ssd"
  worker_data_disk_size     = var.k8s_worker_disk_size
}


provider "kubernetes" {
  host                   = alicloud_cs_managed_kubernetes.default.connections.api_server_internet
  client_certificate     = base64decode(alicloud_cs_managed_kubernetes.default.certificate_authority.client_cert)
  client_key             = base64decode(alicloud_cs_managed_kubernetes.default.certificate_authority.client_key)
  cluster_ca_certificate = base64decode(alicloud_cs_managed_kubernetes.default.certificate_authority.cluster_cert)
}
