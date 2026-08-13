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

# Path on the jumpbox to your existing age private key (used to seed the
# sops-age secret in flux-system on each new cluster).
age_key_path = "~/.config/sops/age/keys.txt"

# clusters map already has placeholder staging/production IPs in
# variables.tf within 10.10.10.0/24 — override here to match real,
# unused addresses on your flat subnet before applying.
