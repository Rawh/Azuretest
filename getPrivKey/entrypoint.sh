#!/bin/bash

VAULTNAME="$VAULTNAME"
VAULTCERTNAME="$VAULTCERTNAME"
CERTLOC="/usr/local/share/ca-certificates/"
CERTPROJ="azure"
CERTFILE="azure.fw.custom.cert.crt"


# Function to check if sudo is installed
check_sudo_installed() {
    if command -v sudo > /dev/null 2>&1; then
        echo "sudo is installed."
    else
        echo "!!! sudo not installed, cannot continue"
    fi
}

# Function to check if the current user has sudo privileges
check_sudo_privileges() {
    if sudo -n true 2>/dev/null; then
        echo "User $(whoami) has sudo privileges."
    else
        echo "User $(whoami) does not have sudo privileges."
    fi
}

# Run the checks
check_sudo_installed
check_sudo_privileges



mkdir -p "${CERTLOC}/${CERTPROJ}" 
chmod 755 "${CERTLOC}/${CERTPROJ}"

az login --identity
az keyvault certificate download --name $VAULTCERTNAME --vault-name $VAULTNAME --file "${CERTLOC}/${CERTPROJ}/${CERTFILE}}"
chmod 644 "${CERTLOC}/${CERTPROJ}/${CERTFILE}}"
update-ca-certificates