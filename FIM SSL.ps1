Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Write-Host "What would you like to do?"
Write-Host "1. Create a new baseline"
Write-Host "2. Begin monitoring baseline"

$response = Read-Host -Prompt "Please enter 1 or 2"

if ($response -eq "1".Trim()) {
    # Calc Hash from  the target file and stroe in baseline.txt all files inside \FIM
    $files = Get-ChildItem -Path "C:\Users\Ahmad\Documents\FIM TEST"

    #For each file, calc hash then write in baseline.txt
    foreach ($f in $files){
        Calculate-File-Hash $f.FullName                     
        # using my function .FullName make it give full path as arg

        "$($hash.path)|$($hash.Hash)" | Out-File -FilePath "C:\Users\Ahmad\Documents\FIM TEST\Baseline.txt"     
        # "$()|$()"output: Path | $hash; first hash var then store value in.path
}
}
elseif ($response -eq "2".Trim()){
    # Begin monitoring
    Write-Host "monitor"
}

function Calculate-File-Hash($filepath) {              #Path of the file to monitor
    $Filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $Filehash # usage: $hash = Calculate-File-Hash "C:\Users\Ahmad\Documents\FIM TEST\A.txt" 
}

function Erase-Baseline-If-exist {
    $baselineExists = Test-Path -Path .\baseline.txt
    if ($baselineExists){
        Remove-Item -Path .\baseline.txt
    }
}



