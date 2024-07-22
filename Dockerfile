# FROM mcr.microsoft.com/azure-cli
FROM ubuntu:22.04

# Set environment variables to avoid user prompts during the installation
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \ 
    && apt install -y wget openssh-server sudo curl iputils-ping dnsutils

# install Azure-CLI according to https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Create the required directories and set permissions
RUN mkdir -p /run/sshd \
    && chmod 0755 /run/sshd \
    && mkdir -p /var/run/sshd \
    && chmod 0755 /var/run/sshd

# Add user with public key login
RUN useradd -m -s /bin/bash willem \
    && mkdir -p /home/willem/.ssh \
    && mkdir -p /home/willem/tmp \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVWQLA3B5Bnkzb7Nkd2LMLb0X746syC5ymwPvAeVtS0/JCDonAaD90mhAIo8Qs4TITZwf2PfWWgrCzdu0zNSWsbYFLtqIe2RaakTzOAEn6zDieTb4ClyIG3OeEGMJ/wykkVJ52N1MOGb/qqyMTDeUU77A6yr27DBJeXhwvzyVY02VTbH35SRPOL1UAnGQZQwADhIh28FgsLfgTzktVjeh9E8Z9KTsn0WCs+7oSiiwoCGqQEUvwwqCMc6yxweVIHRBG89g2hi+cWrwLMeStT97CnwgGqKwhBmEf7Xez1b9fcJ+5CWaD6iN3chlXcwMcgJNH5SKrpZPZJ8BZ5pE2h79/ willem@Odin" > /home/willem/.ssh/authorized_keys \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNwCUST+3/MtHzT/JIr2ZlaGHOpc18MtqMf4LJLmHOoiLCT0sfkUe+xLnJx4zl/fEPrie38QJ3VXOJ+Yy2Ulp8JLSr6DrTB1am20YuyyXZOpFVxSWeGYwAI5UH7AcSDAy+ZUHaH5zmC3s1JZjPph4yrKp+d65ildCnSp1WjY1y1fTcdZpaRDjY/9zGSQ6kkMtHdYL2XRDSWqH5P0FghgLTqbukGm65Bowhnz3Ftthygr/3C0kAF9t7ER2WfWYo7QWdkERxeFUGUwZPnIQe6dG4KNUfggo0TTCm1USq/EMPzPdCABxRik49VDcanlEvN8SGgf64fLiRq6jjmhULnnVH willem@customer" >> /home/willem/.ssh/authorized_keys \
    && chown -R willem:willem /home/willem/.ssh \
    && chmod 700 /home/willem/.ssh \
    && chmod 600 /home/willem/.ssh/authorized_keys

RUN wget -O /home/willem/tmp/az.completion "https://raw.githubusercontent.com/Azure/azure-cli/dev/az.completion" \
    && echo "source /home/willem/tmp/az.completion" >> /home/willem/.bashrc

# Add user to SUDOers 
RUN echo 'willem ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER root

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
# CMD ["ping", "-4", "localhost"]