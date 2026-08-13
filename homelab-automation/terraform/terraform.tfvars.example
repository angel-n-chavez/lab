# Copy to terraform.tfvars and fill in. Do NOT put proxmox_api_token or
# github_token in here if this repo is public/committed anywhere — pass
# those as TF_VAR_proxmox_api_token / TF_VAR_github_token env vars instead
# (same spirit as your manual `export GITHUB_TOKEN=...` step).

proxmox_endpoint = "https://proxmox.lan:8006/"
proxmox_node     = "pve"

template_vm_id  = 9000
vm_storage_pool = "local-lvm"
bridge          = "vmbr0"

ssh_public_key = "ssh-ed25519 AAAA... you@yourmachine"
admin_username = "debian"

github_user   = "angel-n-chavez"
github_repo   = "homelab"
github_branch = "main"

# clusters map already has sensible staging/production defaults in
# variables.tf — override here only if IPs/sizing need to change.
