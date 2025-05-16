#!/bin/bash

set -ouex pipefail

echo "Embedding custom Ignition configuration for user setup..."
IGNITION_CONFIG_TARGET_DIR="/usr/lib/ignition/config.d"
# The build context (from Containerfile's "FROM scratch AS ctx; COPY build_files /")
# makes files from build_files/ available under /ctx/ in this script.
IGNITION_CONFIG_SOURCE_FILE="/ctx/99-user-setup.ign"

if [ -f "${IGNITION_CONFIG_SOURCE_FILE}" ]; then
mkdir -p "${IGNITION_CONFIG_TARGET_DIR}"
cp "${IGNITION_CONFIG_SOURCE_FILE}" "${IGNITION_CONFIG_TARGET_DIR}/99-user-setup.ign"
chmod 644 "${IGNITION_CONFIG_TARGET_DIR}/99-user-setup.ign"
echo "Successfully embedded '99-user-setup.ign'."
else
echo "WARNING: Ignition config file '${IGNITION_CONFIG_SOURCE_FILE}' not found. User setup may be incomplete."
fi

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y incus

systemctl enable podman.socket
