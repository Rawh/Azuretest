FROM azcp4nonprodsb2.azurecr.io/windows/buildimg:latest

RUN powershell.exe -command \
    New-Item -Type Directory -Path "C:\tmp" 

COPY WinAzureCli\\entrypoint.ps1 "c:\tmp\entrypoint.ps1"

ENTRYPOINT ["C:\tmp\entrypoint.ps1"]

