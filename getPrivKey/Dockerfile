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

COPY getPrivKey/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
