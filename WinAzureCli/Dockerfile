# FROM mcr.microsoft.com/azure-cli
FROM mcr.microsoft.com/windows/servercore:ltsc2022

ENV SSHPKGNAME = "OpenSSH.Server~~~~0.0.1.0"
ENV CHECKURL = "https://secure.orkboyz.nl" 

ARG ADMUSR
ARG ADMPWD

ENV ADMUSR=$ADMUSR
ENV ADMPWD=$ADMPWD 
# vqZxW3B9Wj3XL2

## Works, but disabled for run-through-time
# RUN powershell -Command \
#     New-Item -Path C:\tmp -Type Directory

RUN powershell.exe -Command \
    $ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile AzureCLI.msi; \
    Start-Process msiexec.exe -ArgumentList '/I AzureCLI.msi /quiet' -NoNewWindow -Wait; \
    Remove-Item -Force AzureCLI.msi;

RUN powershell.exe -Command \
    $ErrorActionPreference = 'Stop'; \
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0; \
    Start-Service sshd; \
    Set-Service -name sshd -StartupType 'Automatic'

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    $securestring = ConvertTo-SecureString $env:ADMPWD -AsPlainText -Force; \
    New-LocalUser -Name $env:ADMUSR -Password $securestring -PasswordNeverExpires; \
    Add-LocalGroupMember -Member (Get-LocalUser -Name $env:ADMUSR) -Group "administrators"; \
    Add-LocalGroupMember -Member (Get-LocalUser -Name $env:ADMUSR) -Group "Remote Desktop Users"


RUN powershell -Command \
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0; \
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"; 

# EXPOSE 22
EXPOSE 3389

CMD ["powershell.exe", "-Command", "ping", "-t", "localhost"]