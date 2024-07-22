FROM azcp4nonprodsb2.azurecr.io/buildimg:latest

ENV VAULTNAME="$VAULTNAME"
ENV VAULTCERTNAME="$VAULTCERTNAME"
ENV CERTLOC="/usr/local/share/ca-certificates/"
ENV CERTPROJ="azure"
ENV CERTFILE="azure.fw.custom.cert.crt"

USER root

RUN apt update \
    && apt upgrade -y \
    && apt install -y curl wget \
    && apt clean

RUN mkdir -p "${CERTLOC}/${CERTPROJ}" \
    && chmod 755 "${CERTLOC}/${CERTPROJ}"

RUN az login --identity \
    && az keyvault certificate download --name $VAULTCERTNAME --vault-name $VAULTNAME --file "${CERTLOC}/${CERTPROJ}/${CERTFILE}}" \
    && chmod 644 "${CERTLOC}/${CERTPROJ}/${CERTFILE}}" \
    && update-ca-certificates

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
