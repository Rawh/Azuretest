FROM azcp4nonprodsb2.azurecr.io/windows/buildimg:latest

RUN New-Item -Type Directory -Path "C:\tmp\" 

COPY WinAzureCli\\entrypoint.ps1 "c:\tmp\"

ENTRYPOINT ["C:\tmp\entrypoint.ps1"]

