Get-ChildItem -Path ($PSScriptRoot+"\functions") | ForEach-Object {. $($_.FullName)}
Get-Content "C:\temp\Credentials.txt" | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }

clear

$ErrorActionPreference = "Stop"

write-output "Påbörjar bygge..."

$rootPath = $PSScriptRoot | split-path -parent
$FTPHost = $h.FTPHost
$FTPUser = $h.UserName
$FTPPass = $h.Password | ConvertTo-SecureString -AsPlainText -Force

Build-Traumatiserad -RootPath $rootPath

write-output "Bygge klart!"

Publish-Traumatiserad -FTPPass $FTPPass -FTPHost $FTPHost -rootPath $rootPath -FTPUser $FTPUser

write-output "Klart!"

