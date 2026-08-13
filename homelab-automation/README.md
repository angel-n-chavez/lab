# homelab-automation

Automates what I was doing by hand: Packer builds a golden Debian 13
template on Proxmox (cloud-init + qemu-guest-agent baked in), Terraform
clones that template into `staging` and `production` k3s nodes with
the exact VM settings from my notes, and cloud-init takes it from a
freshly booted VM to a k3s node bootstrapped by Flux. No Ansible, no
manual clicking through the Proxmox UI.

```
homelab-automation/
├── packer/
│   ├── debian13-k3s.pkr.hcl      # builds the template
│   ├── http/preseed.cfg          # unattended Debian installer answers
│   └── scripts/provision.sh      # cloud-init/qemu-guest-agent + cleanup
└── terraform/
    ├── versions.tf
    ├── variables.tf
    ├── main.tf                   # clones the template per cluster
    ├── cloud-init.tf             # uploads rendered cloud-init as a Proxmox snippet
    ├── outputs.tf
    ├── terraform.tfvars.example
    └── templates/
        └── user-data.yaml.tftpl  # k3s install + flux bootstrap, per node
```

## How it fits together

1. **Packer** boots the Debian 13 netinst ISO on your Proxmox node, feeds
   it `http/preseed.cfg` for a fully unattended install (no swap partition,
   OpenSSH + sudo + curl in from the start), then runs
   `scripts/provision.sh` to install `qemu-guest-agent` + `cloud-init`,
   and generalizes the image (clears machine-id, SSH host keys, cloud-init
   cache) before converting the VM to a Proxmox template.
2. **Terraform** clones that template twice, once per entry in
   `var.clusters` (`staging`, `production` by default). applying the VM
   hardware settings from my manual notes, and attaches a per-node
   cloud-init config rendered from `user-data.yaml.tftpl`.
3. **cloud-init**, on first boot of each clone: sets hostname/user/SSH
   keys, disables swap, installs k3s (`INSTALL_K3S_EXEC=--disable=helm-controller`,
   matching your notes), installs the Flux CLI, and runs
   `flux bootstrap github --path=./clusters/<cluster>` against my repo.
   From that point Flux owns the cluster and back to pure GitOps.

## One-time setup

```bash
# Packer
cd packer
packer init .
packer build -var-file=variables.pkrvars.hcl debian13-k3s.pkr.hcl

# Terraform
cd ../terraform
cp terraform.tfvars.example terraform.tfvars   # fill in your values
export TF_VAR_proxmox_api_token="root@pam!terraform=xxxxxxxx-xxxx-..."
export TF_VAR_github_token="ghp_xxx"           # never put this in tfvars/git
terraform init
terraform plan
terraform apply
```

