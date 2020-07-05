function Sort-Images(){
    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $true, 
            HelpMessage = "Please enter directory to scan forsort images.")]
        [string]
        $DirectoryToScan,
        [Parameter( Mandatory = $true, 
        HelpMessage = "Please enter name catalog")]
        [string]
        $CatalogName
    )

    try {
        $location = Get-Location
        $FirstData = Get-ChildItem $DirectoryToScan | Sort-Object -Property LastWriteTime | Select-Object -Last 1
        $FirstData = $FirstData.LastWriteTime.tostring('MM-dd-yyyy')
        $LastData = Get-ChildItem $DirectoryToScan | Sort-Object -Property LastWriteTime | Select-Object -First 1
        $LastData = $LastData.LastWriteTime.tostring('MM-dd-yyyy')
    
        $FullNameCatalog = $CatalogName + ' ' + $FirstData + ' - ' + $LastData
    
        if(Test-Path $FullNameCatalog){
            Write-Host "Select other name! The directory already exists!!"
        }else{
            New-Item -Path $location -Name $FullNameCatalog -ItemType "directory"
            $files = Get-ChildItem $DirectoryToScan | Sort-Object -Property LastWriteTime
            foreach ($file in $files) {
                $path = $location.Path + "\" + $FullNameCatalog + "\" + $file.CreationTime.tostring('MM-dd-yyyy')
                if(Test-Path $path){
                    Copy-Item $file.FullName -Destination $path
                }else{
                    New-Item -Path $path -ItemType "directory"
                    Copy-Item $file.FullName -Destination $path
                }
            } 
        }


       

    }
    catch {
        Write-Host "ERROR!!"
    }
    

    
}