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
      github_user    = var.github_user
      github_repo    = var.github_repo
      github_branch  = var.github_branch
      github_token   = var.github_token
      flux_path      = each.value.flux_path
    })
  }
}
