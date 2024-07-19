# FROM mcr.microsoft.com/azure-cli
FROM ubuntu:22.04

# Set environment variables to avoid user prompts during the installation
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \ 
    && apt install -y wget openssh-server sudo curl

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
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVWQLA3B5Bnkzb7Nkd2LMLb0X746syC5ymwPvAeVtS0/JCDonAaD90mhAIo8Qs4TITZwf2PfWWgrCzdu0zNSWsbYFLtqIe2RaakTzOAEn6zDieTb4ClyIG3OeEGMJ/wykkVJ52N1MOGb/qqyMTDeUU77A6yr27DBJeXhwvzyVY02VTbH35SRPOL1UAnGQZQwADhIh28FgsLfgTzktVjeh9E8Z9KTsn0WCs+7oSiiwoCGqQEUvwwqCMc6yxweVIHRBG89g2hi+cWrwLMeStT97CnwgGqKwhBmEf7Xez1b9fcJ+5CWaD6iN3chlXcwMcgJNH5SKrpZPZJ8BZ5pE2h79/ willem@Odin" > /home/willem/.ssh/authorized_keys \
    && chown -R willem:willem /home/willem/.ssh \
    && chmod 700 /home/willem/.ssh \
    && chmod 600 /home/willem/.ssh/authorized_keys

# Add user to SUDOers 
RUN echo 'willem ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER root

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]