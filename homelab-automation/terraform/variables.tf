variable "proxmox_endpoint" {
  type        = string
  description = "e.g. https://proxmox.lan:8006/"
}

variable "proxmox_api_token" {
  type        = string
  description = "e.g. terraform@pve!terraform=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  sensitive   = true
}

variable "proxmox_insecure_tls" {
  type    = bool
  default = true
}

variable "proxmox_ssh_username" {
  type        = string
  description = "Used by the provider for a couple of operations (e.g. file uploads) that go over SSH instead of the API"
  default     = "root"
}

variable "proxmox_node" {
  type        = string
  description = "Proxmox node name (your Dell Precision 3280)"
}

variable "template_vm_id" {
  type        = number
  description = "vm_id of the Packer-built template to clone from"
  default     = 9000
}

variable "vm_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "snippets_datastore" {
  type        = string
  description = "Storage ID with 'Snippets' content enabled, used to hold rendered cloud-init files"
  default     = "local"
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "ssh_public_key" {
  type        = string
  description = "Your SSH public key, installed for the admin user on every node"
}

variable "admin_username" {
  type    = string
  default = "debian"
}

variable "github_user" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "github_branch" {
  type    = string
  default = "main"
}

variable "github_token" {
  type        = string
  sensitive   = true
  description = "GitHub PAT with repo scope, used once by `flux bootstrap` on each node. Pass via TF_VAR_github_token, don't put it in tfvars."
}

# One entry per k3s node/cluster. Mirrors your two-VM (staging/prod) setup
# on the single Proxmox host — add more entries here if the lab grows.
variable "clusters" {
  description = "Map of cluster name -> node config. Cluster name is also used as the Flux --path suffix (clusters/<name>)."
  type = map(object({
    vm_id       = number
    hostname    = string
    vcpus       = number
    memory_mb   = number
    disk_gb     = number
    ip_address  = string # CIDR, e.g. "10.0.10.11/24"
    gateway     = string
    flux_path   = string # e.g. "./clusters/staging"
  }))

  default = {
    staging = {
      vm_id      = 201
      hostname   = "k3s-staging"
      vcpus      = 2
      memory_mb  = 4096
      disk_gb    = 40
      ip_address = "10.0.10.11/24"
      gateway    = "10.0.10.1"
      flux_path  = "./clusters/staging"
    }
    production = {
      vm_id      = 202
      hostname   = "k3s-production"
      vcpus      = 4
      memory_mb  = 8192
      disk_gb    = 60
      ip_address = "10.0.10.12/24"
      gateway    = "10.0.10.1"
      flux_path  = "./clusters/production"
    }
  }
}
