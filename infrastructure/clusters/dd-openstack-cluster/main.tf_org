locals {
  # this will be the user's name and the DNS zone prefix
  cluster_name                            = "dd-openstack-cluster"
  cluster_fqdn                            = "dd-openstack-cluster.dfw3.k8s.opencenter.cloud"
  # Prefix to add to Openstack resource names
  naming_prefix                           = "${local.cluster_name}-"
  # auth_url and region have no template fallback on purpose. A default here
  # would silently provision one region while the rendered in-cluster CCM and
  # CSI consume a different one; cluster validate and the deploy preflight are
  # the places that reject a missing value, and both authenticate for real.
  openstack_auth_url                      = "https://keystone.api.dfw3.rackspacecloud.com/v3/"
  openstack_insecure                      = false
  openstack_region                        = "DFW3"
  availability_zone                       = "az1"
  openstack_user_name                     = ""
  openstack_user_password                 = ""
  application_credential_id               = var.os_application_credential_id
  application_credential_secret           = var.os_application_credential_secret
  openstack_project_domain_name           = "66b6868403a5071ba7ec0bf37708b709"
  openstack_user_domain_name              = "66b6868403a5071ba7ec0bf37708b709"
  openstack_tenant_name                   = ""
  floatingip_pool                         = "PUBLICNET"
  router_external_network_id              = "external-network-id-placeholder"
  # VLAN settings
  vlan_id                                 = ""
  mtu                                     = ""
  network_provider                        = "physnet1"
  #CIDR that the openstack VMs will use for K8s nodes
  subnet_nodes                            = "10.2.128.0/22"
  subnet_nodes_oct                       = join(".", slice(split(".", split("/", local.subnet_nodes)[0]), 0, 3))
  #Leave some IPs free for the VRRP IP and the MetalLB Range
  allocation_pool_start                   = "10.2.128.10"
  allocation_pool_end                     = "10.2.131.250"
  # vrrp_ip Must be an IP from subnet_nodes and will be used as the internal Kubernetes API VIP.
  vrrp_ip                                 = "10.2.128.5"
  #CIDR that will be used by kubernetes pods. Not an openstack network.
  subnet_pods                             = "10.42.0.0/16"
  #CIDR that will be used for kubernetes services. Not an openstack network.
  subnet_services                         = "10.43.0.0/16"
  # use_octavia set to false to create a floating IP associated with the vrrp_ip port. true will create an octavia LB with a floating IP
  use_octavia                             = false
  loadbalancer_provider                   = "ovn"
  # vrrp_enabled cannot be set to true if use_octavia is true
  vrrp_enabled                            = "true"
  # Creates a DNS record using the LB floating IP and dns_zone_name
  use_designate                           = false
  # dns_zone_name is the dns zone to create if use_designate is true
  dns_zone_name                           = "dd-openstack-cluster.dfw3.k8s.opencenter.cloud"
  # DNS servers to configure on the nodes
  dns_nameservers                         = ["8.8.8.8", "8.8.4.4"]
  ntp_servers                             = ["time.dfw3.rackspace.com", "time2.dfw3.rackspace.com"]
  image_id                                = "3e069513-804e-4a88-b75f-28516de01007"
  image_id_windows                        = ""
  k8s_api_port                            = 443
  k8s_api_port_acl                        = ["0.0.0.0/0"]
  worker_count                            = 3
  worker_count_windows                    = 0
  # Enter 1 or 3 masters.
  master_count                            = 3
  ssh_user                                = "ubuntu"
  # these are the ssh public keys that will be able to connect to the cluster's bastion node
  ssh_authorized_keys                     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBUekgxH6nQ1utRd9NzBk3aSPQ2EX5Gt4H6Taz4aZc8o my-org-dd-openstack-cluster-DFW3"]
  node_worker                             = "wn"
  node_master                             = "cp"
  node_worker_windows                     = "win"
  ub_version                              = "24"
  #FLEX Flavor Settings ==========================
  flavor_bastion                          = "gp.0.4.4"
  flavor_master                           = "gp.0.4.4"
  flavor_worker                           = "gp.0.4.4"
  flavor_worker_windows                   = "gp.0.4.4"

  worker_node_bfv_volume_size             = 40
  worker_node_bfv_destination_type        = "volume"
  worker_node_bfv_source_type             = "image"
  worker_node_bfv_volume_type             = "HA-Standard"
  wn_server_group_affinity                = ["soft-anti-affinity"]
  cp_server_group_affinity                = ["soft-anti-affinity"]
  additional_block_devices_worker = []

  additional_server_pools_worker = []

  # ===================================
  #ca_certificates add CA certificates to server's trusts. Good for trusting internal private Certificate Authorities.
  ca_certificates                         = ""
  openstack_ca                            = ""

  # ====================================
  #Kubespray Settings
  kubespray_version                       = "v2.31.0"
  kubernetes_version                      = "1.35.4"
  # CNI install_method: "helm" (default) and "kustomize-helm" skip CNI in Kubespray.
  # OpenStack deploy installs the selected CNI after kubeconfig normalization.
  # "kubespray" is retained only for non-OpenStack migration compatibility.
  network_plugin                          = "none"
  # CLI mode delegates Kubernetes lifecycle operations to the CLI. Keep the
  # explicit deployment setting in legacy mode for existing module users.
  deploy_cluster                          = var.opencenter_lifecycle_mode == "cli" ? false : true
  #kub-vip settings
  kube_vip_enabled                        = true
  #Hardening
  k8s_hardening_enabled                   = true
  kube_pod_security_exemptions_namespaces = ["trivy-temp"]
  # Must remain false for the initial bootstrap. No CNI is installed by Kubespray
  # (CNI is deployed via GitOps after kubeconfig normalization). Kubelet certificate
  # rotation requires node Ready status, which depends on a functioning CNI.
  # Enabling this before the CNI is running causes bootstrap failure.
  kubelet_rotate_server_certificates      = false
  os_hardening_enabled                    = true

  # Interface kube-vip binds the control-plane VIP to. When empty, kube-vip auto-detects.
  kube_vip_interface                      = ""

  #Calico Settings
  cni_iface                               = "enp3s0"
  #Interface detection method for Calico nodeAddressAutodetectionV4. Can be "first-found", "interface", "cidr"
  #https://docs.tigera.io/calico/latest/reference/installation/api#operator.tigera.io%2fv1.NodeAddressAutodetection
  calico_interface_autodetect             = "interface"
  calico_interface_autodetect_cidr        = ""
  calico_encapsulation_type               = "VXLAN"
  calico_nat_outgoing                     = true
  additional_server_pools_worker_windows = []
}
module "openstack-nova" {
  source = "github.com/opencenter-cloud/openCenter-gitops-base.git//iac/cloud/openstack/openstack-nova?ref=2026.03-rc4"
  # source = "../../../gitclones/openCenter-gitops-base/iac/cloud/openstack/openstack-nova"
  availability_zone             = local.availability_zone
  additional_block_devices_worker      = local.additional_block_devices_worker
  application_credential_id     = local.application_credential_id
  application_credential_secret = local.application_credential_secret
  ca_certificates               = local.ca_certificates
  use_octavia                   = local.use_octavia
  use_designate                 = local.use_designate
  dns_nameservers               = local.dns_nameservers
  dns_zone_name                 = local.dns_zone_name
  flavor_bastion                = local.flavor_bastion
  openstack_auth_url            = local.openstack_auth_url
  openstack_ca                  = local.openstack_ca
  openstack_insecure            = local.openstack_insecure
  openstack_region              = local.openstack_region
  openstack_tenant_name         = local.openstack_tenant_name
  openstack_user_name           = local.openstack_user_name
  openstack_password            = local.openstack_user_password
  openstack_project_domain_name = local.openstack_project_domain_name
  openstack_user_domain_name    = local.openstack_user_domain_name
  naming_prefix                 = local.naming_prefix
  ntp_servers                   = local.ntp_servers
  ssh_user                      = local.ssh_user
  floatingip_pool               = local.floatingip_pool
  image_id                      = local.image_id
  image_id_windows              = local.image_id_windows
  router_external_network_id    = local.router_external_network_id
  network_id                    = ""
  subnet_id                     = ""
  vlan_id                       = local.vlan_id
  vrrp_enabled                  = local.vrrp_enabled
  vrrp_ip                       = local.vrrp_ip
  ssh_authorized_keys           = local.ssh_authorized_keys
  subnet_nodes                  = local.subnet_nodes
  subnet_services               = local.subnet_services
  subnet_pods                   = local.subnet_pods
  allocation_pool_start         = local.allocation_pool_start
  allocation_pool_end           = local.allocation_pool_end
  k8s_api_port                  = local.k8s_api_port
  k8s_api_port_acl              = local.k8s_api_port_acl
  size_master = {
    count  = local.master_count
    flavor = local.flavor_master
  }
  size_worker = {
    count  = local.worker_count
    flavor = local.flavor_worker
  }
  node_master                  = local.node_master
  node_worker                  = local.node_worker
  node_worker_windows          = local.node_worker_windows
  ub_version                   = local.ub_version

  worker_node_bfv_volume_size = local.worker_node_bfv_volume_size
  worker_node_bfv_destination_type = local.worker_node_bfv_destination_type
  worker_node_bfv_source_type = local.worker_node_bfv_source_type
  worker_node_bfv_volume_type = local.worker_node_bfv_volume_type
  wn_server_group_affinity = local.wn_server_group_affinity
  cp_server_group_affinity = local.cp_server_group_affinity
}

module "kubespray-cluster" {
  source = "github.com/opencenter-cloud/openCenter-gitops-base.git//iac/provider/kubespray?ref=2026.03-rc4"
  # CLI mode makes OpenTofu infrastructure-only; legacy mode preserves
  # Deployment.AutoDeploy through local.deploy_cluster.
  address_bastion                         = module.openstack-nova.bastion_floating_ip
  cluster_name                            = local.cluster_name
  cni_iface                               = local.cni_iface
  kube_vip_interface                      = local.kube_vip_interface
  deploy_cluster                          = local.deploy_cluster
  dns_zone_name                           = local.dns_zone_name
  master_nodes                            = module.openstack-nova.master_nodes
  network_plugin                          = local.network_plugin
  # Configure kubelet for an external CCM while preventing Kubespray from
  # installing a provider-specific CCM. GitOps remains the single CCM owner.
  kubelet_cloud_provider                  = "external"
  external_cloud_provider                 = "manual"
  # CLI mode renders the inventory directly into the cluster state zone so the
  # GitOps worktree stays clean and Ansible executes the only copy. Legacy mode
  # keeps the module default (./inventory under the working directory).
  inventory_output_dir                    = var.inventory_output_dir
  k8s_hardening_enabled                   = local.k8s_hardening_enabled
  os_hardening_enabled                    = local.os_hardening_enabled
  ssh_user                                = local.ssh_user
  subnet_nodes                            = local.subnet_nodes
  subnet_pods                             = local.subnet_pods
  subnet_services                         = local.subnet_services
  kubernetes_version                      = local.kubernetes_version
  kubespray_version                       = local.kubespray_version
  kube_vip_enabled                        = local.kube_vip_enabled
  kube_pod_security_exemptions_namespaces = local.kube_pod_security_exemptions_namespaces
  kubelet_rotate_server_certificates      = local.kubelet_rotate_server_certificates
  # Additional Linux worker pools are provisioned by openstack-nova but are only
  # joined to the cluster when they reach the Kubespray inventory: concat them
  # with the default worker pool so kube_node contains every worker node.
  # additional_worker_pools_nodes is an empty map when no pools are configured,
  # so the flatten yields [] and the default pool is unchanged.
  worker_nodes = concat(
    module.openstack-nova.worker_nodes,
    flatten([
      for pool_name, pool_nodes in module.openstack-nova.additional_worker_pools_nodes : pool_nodes
    ])
  )
  k8s_api_ip                              = module.openstack-nova.k8s_api_ip
  k8s_internal_ip                         = module.openstack-nova.k8s_internal_ip
  k8s_api_port                            = local.k8s_api_port
  vrrp_ip                                 = local.vrrp_ip
  vrrp_enabled                            = local.vrrp_enabled
  windows_nodes                           = []
  use_octavia                             = local.use_octavia
  coredns_rewrite_block                   = "rewrite name exact auth.${local.cluster_fqdn} envoy-gateway.gateway.svc.cluster.local"
}
