function Test-WebClientConnection { 
    param (
    [Parameter(Mandatory)]
    [string]$FTPHost,
    [Parameter(Mandatory)]
    $webClient
    )

    write-output "Testar uppkoppling..."
    try {
      $TempFile = new-TemporaryFile
      $testUri = New-Object System.Uri($FTPHost+$TempFile.Name)
      $webClient.UploadFile($testUri, $TempFile.FullName)

      #Delete file
      $ftpRequest = [System.Net.FtpWebRequest]::create($testUri)
      $ftprequest.Credentials = $webClient.Credentials
      $ftprequest.Method = [System.Net.WebRequestMethods+Ftp]::DeleteFile
      $ftprequest.GetResponse()
      return "Inloggningen lyckades!"
    } 
    catch {
      $ErrorMessage = $_.Exception.Message
      write-output "Inloggningen misslyckades: $ErrorMessage"

      Exit
    }
}