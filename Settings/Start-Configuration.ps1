#Check for the Music Module is installed or not
#Create a folder based on the user preference

Function Start-Configuration{
    [cmdletBinding()]
    param()
    #setting user directory path for runing the music files
    $usrhome = $env:HOMEPATH #Get user home dir
    $usrChoice = Read-Host "Do you want to set music directory path (Y/N)"
    switch($usrChoice){
        'Y'{
            $UsrMusicPath = Read-Host "Enter Music Path"
            if(Test-Path -Path $UsrMusicPath){
                New-Item -Path $UsrMusicPath\MusicPath.txt -Force -ItemType File
                $usrMusicPath | Out-File $UsrMusicPath\MusicPath.txt
                $SetMusicPath = Get-Content -Path $UsrMusicPath\MusicPath.txt
                Push-location $SetMusicPath
            }Else{
                Write-Host "An Error Just occured. Music Path Does Not Exist" -ForegroundColor Red
            }
        }
        'N'{
            New-Item -Path $usrhome\music\EAPlayer -ItemType Directory -Force
            if(Test-Path -Path "$usrhome\music\EAPlayer"){
                New-Item -Path $usrhome\music\EAPlayer\MusicPath.txt -ItemType File -Force
                Push-Location $usrhome\music\EAPlayer
                $GetUsrMusicPath = Get-Location
                Write-Host "Your Music Path is $GetUsrMusicPath" -ForegroundColor Green
                $GetUsrMusicPath.Path | Out-File $usrhome\music\EAPlayer\MusicPath.txt -Force
            }Else{
                Write-Host "An Error Just occured. Music Path Does Not Exist" -ForegroundColor Red
            }
        }
    }
    #Creating Configuration Enviroment
    $Languages = (Import-Csv -Path "C:\Program Files\EAPlayer\Files\languages.csv").Language_Names #Creating the language directory based on the user selection
    $LanguageCollections = [System.Collections.ArrayList]@()
    Write-Output "SELECT NUMBER TO THE LANGUAGE YOU WANT TO SET UP"
    forEach($language in $Languages){
        $langArrayIndex = $LanguageCollections.Add($language)
        Write-Output "$langArrayIndex. $language"
    }

    $userInput = Read-Host "Enter Number"
    $userChoice = $LanguageCollections[$userInput]
    Write-Output "$userChoice"

    #Get the Current Path of the user and create folders
    $MusicPathDir = Get-Content .\MusicPath.txt
    New-Item -Path "$MusicPathDir\$userChoice" -ItemType Directory -Force #Creating parent directory
    New-Item -Path "$MusicPathDir\$userChoice\PlayList" -ItemType Directory -Force
    New-Item -Path "$MusicPathDir\$userChoice\PlayList\Special" -ItemType Directory -Force
    New-Item -Path "$MusicPathDir\$userChoice\PlayList\Regular" -ItemType Directory -Force
}
Start-Configuration
