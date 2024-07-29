# Set SSL to tls1.2 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# tab completion for azure-cli
Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    $completion_file = New-TemporaryFile
    $env:ARGCOMPLETE_USE_TEMPFILES = 1
    $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
    $env:COMP_LINE = $wordToComplete
    $env:COMP_POINT = $cursorPosition
    $env:_ARGCOMPLETE = 1
    $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
    $env:_ARGCOMPLETE_IFS = "`n"
    $env:_ARGCOMPLETE_SHELL = 'powershell'
    az 2>&1 | Out-Null
    Get-Content $completion_file | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
    }
    Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, Env:\_ARGCOMPLETE_SHELL
}

# tab completion working like bash
Set-PSReadLineKeyHandler -Key tab -Function MenuComplete

# Check required env variables
if (-not $env:tenantId) {
    write-error "# `$tenantId not found!"
    exit 1
} elseif (-not $env:SPN01AZCLICID) {
    write-error "# `$SPN01AZCLICID not found!"
    exit 1
} elseif (-not $env:SPN01AZCLIPWD) {
    write-error "# `$SPN01AZCLIPWD not found!"
    exit 1
}


$az = $(az logout 2>&1 | ConvertFrom-Json)

$az = $(az login --service-principal --tenant $($env:tenantid) --username $env:SPN01AZCLICID --password $env:SPN01AZCLIPWD | ConvertFrom-Json)

if (-not $az) {
    Write-Error -Message "####"
    Write-Error -Message "## Cannot login"
    Write-Error -Message "####"
    exit 1
}

if (-not (Test-Path "C:\tmp")) {
    New-Item -ItemType Directory -Path "c:\tmp" | Out-Null
}

$certPath = "C:\tmp\$($env:CERTFILE)"
$certDownload = $(az keyvault certificate download --name "$($env:VAULTCERTNAME)" --vault-name "$($env:VAULTNAME)" --file $($certPath))

$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$cert.Import($certPath)

$store = New-Object System.Security.Cryptography.X509Certificates.X509Store -ArgumentList "Root", "LocalMachine"
$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
$store.Add($cert)
$store.Close()

# ###
# # Check online cert for validity

# # Define the URL of the website
# $url = "secure.orkboyz.nl"
# $port = 443

# # Create a TCP client
# $tcpClient = New-Object System.Net.Sockets.TcpClient
# $tcpClient.Connect($url, $port)

# # Create an SSL stream
# $sslStream = New-Object System.Net.Security.SslStream($tcpClient.GetStream(), $false, ({ $true }))

# # Authenticate the server
# $sslStream.AuthenticateAsClient($url)

# # Get the certificate
# $remoteCert = $sslStream.RemoteCertificate

# # Close the streams and TCP connection
# $sslStream.Close()
# $tcpClient.Close()

# $checkCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $remoteCert

# # Display the certificate details
# $certDetails = @{
#     Subject = $checkCert.Subject
#     Issuer = $checkCert.Issuer
#     EffectiveDate = $checkCert.NotBefore
#     ExpirationDate = $checkCert.NotAfter
#     Thumbprint = $checkCert.Thumbprint
#     SerialNumber = $checkCert.SerialNumber
#     FriendlyName = $checkCert.FriendlyName
#     PublicKey = $checkCert.GetPublicKeyString()
#     SignatureAlgorithm = $checkCert.SignatureAlgorithm.FriendlyName
# }

Start-Process -NoNewWindow cmd.exe -ArgumentList "/c ping -t localhost"