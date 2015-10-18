param([String]$project_name, [Boolean]$is_service);

$filesToInclude = ("*.config", "*.cs", "*.js", "*.ts", "*.xml", "*.asax", "*.csproj", "*.sln");

function FindAndReplace($path, $find, $replace) {
    $files = Get-ChildItem $path -rec -Include $filesToInclude -File | 
             Where-Object { $_.FullName -notlike ".*" -and $_.FullName -notlike "*packages*" };

    foreach($file in $files) {
        (Get-Content $file.PSPath) | 
        Foreach-Object { $_ -replace $find, $replace } | 
        Set-Content $file.PSPath;
    }
}

function RenameFiles($path, $oldName, $newName) {
    $files = Get-ChildItem $path -rec -Include $filesToInclude -File | 
             Where-Object { $_.FullName -notlike ".*" -and $_.FullName -notlike "*packages*" };

    $dirs =  Get-ChildItem $path -rec -Directory | 
             Where-Object { $_.FullName -notlike ".*" -and $_.FullName -notlike "*packages*" }
             Sort -length -desc;

    foreach($dir in $dirs) {
        if($dir.PSPath -like "*$oldName*") {
            mv $dir.PSPath $dir.PSPath.Replace($oldName, $newName);
        }
    }

    foreach($file in $files) {
        if($file.PSPath -like "*$oldName*") {
            mv $file.PSPath $file.PSPath.Replace($oldName, $newName);
        }
    }
}

if ($project_name -eq $null -or $project_name -eq "") {
    echo "Use init -project_name YourProjectName";
} else {
    echo "Bootstraping project: $project_name";
    echo "Renaming folders";
    echo "Done";
    echo "Replacing values";

    #FindAndReplace -path "." -find "PROJECT_NAME" -replace $project_name;
    RenameFiles -path "." -oldName "PROJECT_NAME" -newName $project_name;
    
    echo "Done";
}
