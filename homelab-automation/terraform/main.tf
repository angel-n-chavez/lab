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

# --- Everything below runs ON THE MACHINE WHERE YOU RUN `terraform apply`
# --- i.e. your jumpbox. Nothing here ever gets written into the VM, a
# --- Proxmox snippet, or Terraform state — it shells out locally, the same
# --- way you already `flux bootstrap github ...` by hand after SSHing to
# --- fetch a kubeconfig. GITHUB_TOKEN is inherited from your shell's
# --- environment (you already export it before running terraform apply);
# --- it is never referenced as a Terraform variable, so it can't leak into
# --- state or plan output.
resource "null_resource" "flux_bootstrap" {
  for_each = var.clusters

  depends_on = [proxmox_virtual_environment_vm.k3s_node]

  triggers = {
    vm_id = proxmox_virtual_environment_vm.k3s_node[each.key].vm_id
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -euo pipefail
      NODE_IP="${split("/", each.value.ip_address)[0]}"
      KCFG="${path.module}/kubeconfigs/${each.key}.yaml"
      mkdir -p "${path.module}/kubeconfigs"

      # Every clone gets a fresh SSH host key (by design — see provision.sh).
      # If this IP was previously used by a VM we destroyed, Larry's
      # known_hosts still has the OLD key on file, which makes even
      # accept-new refuse to connect ("REMOTE HOST IDENTIFICATION HAS
      # CHANGED"). Purge any stale entry before every run so repeated
      # destroy/apply cycles at the same IP never get stuck.
      ssh-keygen -R "$NODE_IP" >/dev/null 2>&1 || true

      echo ">> [${each.key}] waiting for SSH + k3s kubeconfig on $NODE_IP..."
      for i in $(seq 1 60); do
        ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 \
          ${var.admin_username}@$NODE_IP \
          "test -f /home/${var.admin_username}/.kube/config" && break
        sleep 5
      done

      scp -o StrictHostKeyChecking=accept-new \
        ${var.admin_username}@$NODE_IP:/home/${var.admin_username}/.kube/config "$KCFG"
      sed -i "s/127.0.0.1/$NODE_IP/" "$KCFG"
      chmod 600 "$KCFG"

      echo ">> [${each.key}] running flux bootstrap..."
      export KUBECONFIG="$KCFG"
      flux bootstrap github \
        --owner="${var.github_user}" \
        --repository="${var.github_repo}" \
        --branch="${var.github_branch}" \
        --path="${each.value.flux_path}" \
        --personal

      echo ">> [${each.key}] applying sops-age secret for flux decryption..."
      kubectl create secret generic sops-age \
        -n flux-system \
        --from-file=age.agekey="${var.age_key_path}" \
        --dry-run=client -o yaml | kubectl apply -f -
    EOT
  }
}
