Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

#               ---Funcitons----                #

function Calculate-File-Hash($filepath) {
    # Path of the file to monitor
    $Filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $Filehash   # usage: $hash = Calculate-File-Hash "C:\Users\Ahmad\OneDrive\Documents\GitHub\FIM\A.txt" 
}

function Erase-Baseline-If-exists {
    $baselineExists = Test-Path -Path .\baseline.txt
    if ($baselineExists) {
        Remove-Item -Path .\baseline.txt
    }
}

#               ---Main(argv)----               #
Write-Host "What would you like to do?"
Write-Host "1. Create a new baseline"
Write-Host "2. Begin monitoring baseline"

$response = Read-Host -Prompt "Please enter 1 or 2"

if ($response -eq "1".Trim()) {
    Erase-Baseline-If-exists
    # Calc Hash from  the target file and stroe in baseline.txt all files inside \FIM
    $files = Get-ChildItem -Path "./FIM TEST"

    #For each file, calc hash then write in baseline.txt
    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName                     
        # using my function .FullName make it give full path as arg

        "$($hash.Path) | $($hash.Hash)" | Out-File -FilePath ".\Baseline.txt" -Append     
        # Output looks like: C:/Document/...  |  D6938E93YAKJGMELFKEROGM<EOLFEsOLTSGYE
    }
}
elseif ($response -eq "2".Trim()) {
    #Erase-Baseline-If-exists
    
    $fileHashDic = @{}  #initialze Dictonary/list

    # Load file|hash form baseline.txt and store them in a dictonary/list as a pair 
    $filePathsAndHashes = Get-Content -Path ".\Baseline.txt"
    # Map the data structure 
    foreach ($line in $filePathsAndHashes) {
        $fileHashDic.Add($line.Split("|")[0], $line.Split("|")[1])        #a pair is a key & value to check run $fileHashDic.key or value
    }
    
    # Now loop forever
    while (1){
    Start-Sleep -Seconds 1



    $files = Get-ChildItem -Path "./FIM TEST"

    #For each file, calc hash then write in baseline.txt
    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName

        # TODO: keeps notifiying me that files has been CREATED while not 

        # Notify if file is not in baseline (Newly added/created)
        if ($fileHashDic[$hash.Path] -eq $null) { #if it's true we know a file has been added
        write-host "$($hash.Path) has been created!" -ForegroundColor Yellow
        }
        else {
              if ($fileHashDic[$hash.Path] -eq $hash.Hash) { 
              #Do nothing as it matches
              }else {
              write-host "$($hash.Path) has been changed!" -ForegroundColor Red
              }
        }
        
        }
    }
    # Check if a key's path has been changed to what's inside our Dictonary

    foreach($key in $fileHashDic.Keys) { #spit out all keys in dictonary
            $baselineFileStillExist = Test-Path -Path $key
            if (-Not $baselineFileStillExist){
            Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed
            }
    
    }
}
















