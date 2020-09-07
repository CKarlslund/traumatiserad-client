function Create-WebClient {
    param (
        [Parameter(Mandatory)]
        [string] $FTPUser,
        [Parameter(Mandatory)]
        $FTPPass,
        [Parameter(Mandatory)]
        [string] $FTPHost
    )

    $null = write-output "Creating webClient..." 

    $webclient = New-Object System.Net.WebClient
    $webclient.Credentials = New-Object System.Net.NetworkCredential($FTPUser,$FTPPass) 

    $null = Test-WebClientConnection -FTPHost $FTPHost -webClient $webclient

    return $webclient
}