output "nodes" {
  description = "Cluster name -> VM id / IP, for quick reference (kubeconfig is on each node at ~/.kube/config)"
  value = {
    for name, vm in proxmox_virtual_environment_vm.k3s_node : name => {
      vm_id      = vm.vm_id
      ip_address = var.clusters[name].ip_address
      flux_path  = var.clusters[name].flux_path
    }
  }
}
