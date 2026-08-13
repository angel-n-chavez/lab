# Proxmox's cloud-init integration wants custom user-data as a "snippet"
# file living on a datastore with Snippets content enabled (Datacenter >
# Storage > <storage> > Content > Snippets). We render one per cluster
# from templates/user-data.yaml.tftpl and upload it here; main.tf then
# points each VM's initialization block at the matching snippet.

resource "proxmox_virtual_environment_file" "user_data" {
  for_each = var.clusters

  content_type = "snippets"
  datastore_id = var.snippets_datastore
  node_name    = var.proxmox_node

  source_raw {
    file_name = "${each.key}-user-data.yaml"
    data = templatefile("${path.module}/templates/user-data.yaml.tftpl", {
      hostname       = each.value.hostname
      admin_username = var.admin_username
      ssh_public_key = var.ssh_public_key
    })
    # Note: no GitHub token, no Flux install, nothing GitOps-related in here
    # on purpose — this node only ever gets k3s. Flux bootstrap happens from
    # the jumpbox in main.tf's null_resource, using your already-exported
    # GITHUB_TOKEN and local age key, so neither ever touches this snippet,
    # the Proxmox host, or Terraform state.
  }
}
