resource "proxmox_virtual_environment_vm" "k3s_node" {
  for_each = var.clusters

  name      = each.value.hostname
  node_name = var.proxmox_node
  vm_id     = each.value.vm_id
  on_boot   = true # "start at boot", per your notes

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  cpu {
    cores = each.value.vcpus
    type  = "host" # per your notes: CPU type -> host
  }

  memory {
    dedicated = each.value.memory_mb
    floating  = 0 # per your notes: ballooning device unchecked
  }

  # per your notes: virtIO SCSI single controller, Qemu Agent
  scsi_hardware = "virtio-scsi-single"
  agent {
    enabled = true
  }

  disk {
    datastore_id = var.vm_storage_pool
    interface    = "scsi0"
    size         = each.value.disk_gb
    ssd          = true  # per your notes: SSD emulation
    discard      = "on"  # per your notes: Discard
  }

  network_device {
    bridge  = var.bridge
    model   = "virtio"
    queues  = each.value.vcpus # per your notes: Multiqueue == vCPU count
  }

  operating_system {
    type = "l26" # Linux 2.6+ kernel family, covers Debian 13
  }

  initialization {
    datastore_id      = var.vm_storage_pool
    user_data_file_id = proxmox_virtual_environment_file.user_data[each.key].id

    ip_config {
      ipv4 {
        address = each.value.ip_address
        gateway = each.value.gateway
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # avoid churn from cloud-init re-render diffs after first boot
      initialization[0].user_data_file_id,
    ]
  }
}
