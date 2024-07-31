FROM mcr.microsoft.com/windows/servercore:ltsc2022

ARG ADMUSR
ARG ADMPWD

ENV ADMUSR=$ADMUSR
ENV ADMPWD=$ADMPWD 

RUN powershell.exe -Command \
    $ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile AzureCLI.msi; \
    Start-Process msiexec.exe -ArgumentList '/I AzureCLI.msi /quiet' -NoNewWindow -Wait; \
    Remove-Item -Force AzureCLI.msi;

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    $securestring = ConvertTo-SecureString $env:ADMPWD -AsPlainText -Force; \
    New-LocalUser -Name $env:ADMUSR -Password $securestring -PasswordNeverExpires; \
    Add-LocalGroupMember -Member (Get-LocalUser -Name $env:ADMUSR) -Group "administrators"

CMD ["powershell.exe", "-Command", "ping", "-t", "localhost"]