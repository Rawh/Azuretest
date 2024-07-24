# FROM mcr.microsoft.com/azure-cli
FROM mcr.microsoft.com/windows/servercore:ltsc2022

ENV SSHPKGNAME = "OpenSSH.Server~~~~0.0.1.0"
ENV CHECKURL = "https://secure.orkboyz.nl" 

ARG ADMUSR
ARG ADMPWD

ENV ADMUSR=$ADMUSR
ENV ADMPWD=$ADMPWD 
# vqZxW3B9Wj3XL2

RUN powershell -Command \
    New-Item -Path C:\tmp -Type Directory
    # | Out-Null

# COPY vc_redist.x64.exe "C:\tmp\vc_redist.x64.exe"

# RUN powershell.exe -command \
#     # Install winget dependencies
#     Start-Process -FilePath "C:\tmp\vc_redist.x64.exe" -ArgumentList '/install', '/passive', '/norestart' -NoNewWindow -Wait; \
#     Remove-Item -Force "C:\tmp\vc_redist.x64.exe"; \
#     # Download and install winget (App Installer)
#     Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v1.1.13405/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile Microsoft.DesktopAppInstaller.msixbundle; \
#     Add-AppxPackage -Path .\Microsoft.DesktopAppInstaller.msixbundle; \
#     Remove-Item -Force Microsoft.DesktopAppInstaller.msixbundle; \
#     # Install Azure CLI
#     winget install --id Microsoft.AzureCLI -e -i

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

RUN net user %ADMUSR% %ADMPWD% /add; \
    net localgroup Administrators %ADMUSR% /add

RUN powershell -Command \
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0; \
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"; \
    $objUser = [ADSI]("WinNT://./$($env:ADMUSR),user"); \
    $objGroup = [ADSI]("WinNT://./Remote Desktop Users,group"); \
    $objGroup.Add($objUser.Path)

# EXPOSE 22
EXPOSE 3389

CMD ["powershell.exe", "-Command", "ping", "-t", "localhost"]