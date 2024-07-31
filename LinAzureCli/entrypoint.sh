#!/bin/bash

# echo commands
set -x

# Export variables to be available to everyone who logs in
echo " " >> /etc/profile
echo "export VAULTNAME=${VAULTNAME}" >> /etc/profile
echo "export VAULTCERTNAME=${VAULTCERTNAME}" >> /etc/profile
echo "export CERTLOC=${CERTLOC}" >> /etc/profile
echo "export CERTPROJ=${CERTPROJ}" >> /etc/profile
echo "export CERTFILE=${CERTFILE}" >> /etc/profile

# Create the directory for certificates and set permissions
CERT_PATH="${CERTLOC}/${CERTPROJ}"
echo "Creating certificate directory: ${CERT_PATH}"
mkdir -p "${CERT_PATH}"
chmod 755 "${CERT_PATH}"
echo " "

# Log in to Azure and download the certificate
echo "Logging in to Azure..."
az login --identity
echo " "

CERT_FULL_PATH="${CERT_PATH}/${CERTFILE}"
echo "Downloading certificate to: ${CERT_FULL_PATH}"
az keyvault certificate download --name "${VAULTCERTNAME}" --vault-name "${VAULTNAME}" --file "${CERT_FULL_PATH}"
chmod 644 "${CERT_FULL_PATH}"
echo " "

# Update CA certificates
echo "Updating CA certificates..."
update-ca-certificates
echo " "

# Execute the original CMD passed as arguments to the script
exec "$@"
