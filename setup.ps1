##[Ps1 To Exe]
##
##Kd3HDZOFADWE8uO1
##Nc3NCtDXTlaDjpzQ9wd/5FnrfkYuetaTuKSiioi/8Io=
##Kd3HFJGZHWLWoLaVvnQnhQ==
##LM/RF4eFHHGZ7/K1
##K8rLFtDXTiW5
##OsHQCZGeTiiZ4tI=
##OcrLFtDXTiW5
##LM/BD5WYTiiZ4tI=
##McvWDJ+OTiiZ4tI=
##OMvOC56PFnzN8u+Vs1Q=
##M9jHFoeYB2Hc8u+Vs1Q=
##PdrWFpmIG2HcofKIo2QX
##OMfRFJyLFzWE8uK1
##KsfMAp/KUzWI0g==
##OsfOAYaPHGbQvbyVvnQmqxuO
##LNzNAIWJGmPcoKHc7Do3uAuO
##LNzNAIWJGnvYv7eVvnRZ4F/dSmk5a6U=
##M9zLA5mED3nfu77Q7TV64AuzAkYuevaTuKSipA==
##NcDWAYKED3nfu77Q7TV64AuzAkYuevaTuKSipA==
##OMvRB4KDHmHQvbyVvnQX
##P8HPFJGEFzWE8pDH6jV5pXj6Q3ogDg==
##KNzDAJWHD2fS8u+Vgw==
##P8HSHYKDCX3N8u+Vgw==
##LNzLEpGeC3fMu77Ro2k3hQ==
##L97HB5mLAnfMu77Ro2k3hQ==
##P8HPCZWEGmaZ7/K1
##L8/UAdDXTlaDjpzQ9wd/5FnrfkYuevaTuKSiioSk+oo=
##Kc/BRM3KXxU=
##
##
##fd6a9f26a06ea3bc99616d4851b372ba
Write-Output "Stage 1 - Configuration"
Write-Output "Setting up the share configuration"
function NetShare {
    $config = Import-Csv -Path "$path\config.csv"
    $pass = $config.pass
    $user = $config.user
    $pc1 = $config.pc1
    $pc2 = $config.pc2
##########################################
#create a local account
$password = ConvertTo-SecureString $pass -AsPlainText -Force
$lpc = $env:COMPUTERNAME
$luser = $lpc+"\"+$user 
Write-Output $luser
New-LocalUser -name $user -Password $password
#add permissions to the folder
$acl = Get-Acl -Path $path
$ace = New-Object System.Security.Accesscontrol.FileSystemAccessRule ($user , "FullControl", "Allow")
$acl.AddAccessRule($ace)
Set-Acl -Path $path -AclObject $acl
#share setup
$Parameters = @{
    Name       = 'Local Share'
    Path       = $path
    FullAccess = $luser, "everyone"
}
New-SmbShare @Parameters
Write-Output "Complete - Stage 2 - Creation"
Write-Output "Share and user created."
Write-Output "The other PC must be at this stage before continuing."
Pause
write-host "Stage 3 - Share"
if ($env:COMPUTERNAME -eq $pc1){
    $remote = $Path
    $remote.replace('C:', "\\$pc2")
}
else {
    $remote = $Path
    $remote.replace('C:', "\\$pc1")
}
    $net = new-object -ComObject WScript.Network
    $net.MapNetworkDrive("z:", $remote, ".\$user", $pass)
    Write-Output "Complete - Stage 3 - Share"
    Write-Output "Remote share now set as Z drive. complete script on 2nd pc."
    Pause
    break
}

$path = "C:\NetShare\"
if (Test-Path -Path $path) {
    Write-Output "$path exists."
}
else {
    Write-Output "$path does not currently exist."
    New-Item -ItemType Directory -Path $path
}
Write-Output "$path Ready."
if (Test-Path -Path "$path\config.csv") {
    Write-Output "Config file exists."
    Write-Output "Begining Stage 2 - Local setup"
    NetShare
}
else {
    if (Test-Path -Path "$path\tempconfig.csv") {
        $config = Import-Csv -Path "$path\tempconfig.csv"
        Write-Output "Adding this PC to the config file"
        $lpc = $env:COMPUTERNAME
        $config | Add-Member -MemberType NoteProperty -Name pc2 -Value $lpc
        $config | Export-Csv -Path "$path\config.csv" -NoTypeInformation
        Remove-Item -Path "$path\tempconfig.csv"
        Write-Output "Config file complete - please copy the config file to PC1 and rerun the tool on both PC's"
        Pause
        break
    }
    else {
        Write-Output "Config file does not currently exist, Default config file created."
        $lpc = $env:COMPUTERNAME
        $pass = "Change_me1"
        $user = "Local"
        $config = [PSCustomObject]@{
            pass = $pass
            user = $user
            pc1  = $lpc
        }
        $config | Export-Csv -Path "$path\tempconfig.csv" -NoTypeInformation
        Write-Output "Please edit the file $path\tempconfig.csv to a username and password to use." 
        Write-Output "This should be different to your normal user name."  
        Write-Output "Once this has been done re-run the tool with the temp config file from PC1 on PC2"  
        Pause   
        break
    }
}
