﻿function Publish-Traumatiserad {
  param (
    [Parameter(Mandatory)]
    [string]$rootPath,
    [Parameter(Mandatory)]
    [string]$FTPUser,
    [Parameter(Mandatory)]
    $FTPPass,
    [Parameter(Mandatory)]
    [string]$FTPHost
  )

    write-output "Publicerar..."

    $webclient = Create-WebClient -FTPUser $FTPUser -FTPPass $FTPPass -FTPHost $FTPHost
    
    #Directory where to find pictures to upload
    $UploadFolder = join-path $rootPath "\build"
    
    $SrcEntries = Get-ChildItem $UploadFolder -Recurse
    $Srcfolders = $SrcEntries | Where-Object{$_.PSIsContainer}
    $SrcFiles = $SrcEntries | Where-Object{!$_.PSIsContainer}
    
    write-output "Börjar ladda upp filer..."
    # Create FTP Directory/SubDirectory If Needed - Start
    foreach($folder in $Srcfolders)
    {   
        $SrcFolderPath = $UploadFolder  -replace "\\","\\" -replace "\:","\:"  
        $DesFolder = $folder.Fullname -replace $SrcFolderPath,$FTPHost
        $DesFolder = $DesFolder -replace "\\", "/"
        # Write-Output $DesFolder
    
        try
            {
                $makeDirectory = [System.Net.WebRequest]::Create($DesFolder);
                $makeDirectory.Credentials = New-Object System.Net.NetworkCredential($FTPUser,$FTPPass);
                $makeDirectory.Method = [System.Net.WebRequestMethods+FTP]::MakeDirectory;
                $makeDirectory.GetResponse();
                #folder created successfully
            }
        catch [Net.WebException]
            {
                try {
                    #if there was an error returned, check if folder already existed on server
                    $checkDirectory = [System.Net.WebRequest]::Create($DesFolder);
                    $checkDirectory.Credentials = New-Object System.Net.NetworkCredential($FTPUser,$FTPPass);
                    $checkDirectory.Method = [System.Net.WebRequestMethods+FTP]::PrintWorkingDirectory;
                    $response = $checkDirectory.GetResponse();
                    #folder already exists!
                }
                catch [Net.WebException] {
                    #if the folder didn't exist
                }
            }
    }
    #Create FTP Directory/SubDirectory If Needed - Stop
    
    # Upload Files - Start
    foreach($entry in $SrcFiles)
    {
        $SrcFullname = $entry.fullname
        $SrcName = $entry.Name
        $SrcFilePath = $UploadFolder -replace "\\","\\" -replace "\:","\:"
        $DesFile = $SrcFullname -replace $SrcFilePath,$FTPHost
        $DesFile = $DesFile -replace "\\", "/"
        # Write-Output $DesFile
        
        $uri = New-Object System.Uri($DesFile)
        $webclient.UploadFile($uri, $SrcFullname)
    }
    # Upload Files - Stop
    
    
    $webclient.Dispose()
}