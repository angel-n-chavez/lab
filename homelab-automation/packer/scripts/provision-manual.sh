#!/bin/bash
# Identical to provision.sh with ONE difference at the bottom: this does
# NOT lock the debian account. Use this to build a throwaway template
# (different vm_id!) you can manually clone and log into directly with
# the same debian/packer-temp-pw credentials used during the build, to
# sanity-check the image without needing a Cloud-Init drive at all.
#
# Do not use this for the template Terraform clones from. That one
# should stay sealed (scripts/provision.sh).
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y

apt-get install -y qemu-guest-agent cloud-init cloud-guest-utils

systemctl enable qemu-guest-agent

swapoff -a || true
sed -i '/\sswap\s/d' /etc/fstab

# --- Generalize the image so every clone doesn't inherit build-time identity ---
truncate -s 0 /etc/machine-id
rm -f /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# rm -f /etc/ssh/ssh_host_*  # removed so that I can ssh into VM created manually from this template.

cloud-init clean --logs --seed || true

cat >/etc/cloud/cloud.cfg.d/99-proxmox-nocloud.cfg <<'EOF'
datasource_list: [ NoCloud, ConfigDrive ]
EOF

# --- The one intentional difference from provision.sh ---
# Leave the debian account's password as-is (packer-temp-pw, set via
# preseed) instead of locking it, so a manual clone with no cloud-init
# drive attached is still loggable-into over SSH or the Proxmox console.
echo "debian:packer-temp-pw" | chpasswd

apt-get autoremove -y
apt-get clean
rm -rf /tmp/* /var/tmp/*
history -c || true
