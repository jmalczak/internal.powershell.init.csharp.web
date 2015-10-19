param([String]$project_name, [Boolean]$is_service);

function GetFilteredObjects($path, $type) {
    $arguments = @{ Path = $path; Recurse = $true; }

    if($type -eq "file") {
        $arguments.Add("File", $true);
        $arguments.Add("Include", ("*.config", "*.cs", "*.js", "*.ts", "*.xml", "*.asax", "*.csproj", "*.sln"));
    } 
    if ($type -eq "dir") {
        $arguments.Add("Directory", $true); 
    }

    return Get-ChildItem @arguments | Where-Object { $_.FullName -notlike ".*" -and $_.FullName -notlike "*packages*" };
}

function FindAndReplace($path, $find, $replace) {
    foreach($file in (GetFilteredObjects $path "file")) {
        (Get-Content $file.FullName) | Foreach-Object { $_ -replace $find, $replace } | 
         Set-Content $file.FullName;
    }
}

function RenameFiles($path, $oldName, $newName) {
    $dirs =  (GetFilteredObjects $path "dir") | Sort-Object { $_.FullName.Length } -Descending

    foreach($dir in $dirs) {
        if($dir.Name -like "*$oldName*") {
            mv $dir.FullName ([System.IO.Path]::Combine($dir.Parent.FullName, $dir.Name.Replace($oldName, $newName)));
        }
    }

    foreach($file in (GetFilteredObjects $path "file")) {
        if($file.FullName -like "*$oldName*") {
            mv $file.FullName ([System.IO.Path]::Combine($file.Directory.FullName, $file.Name.Replace($oldName, $newName)));
        }
    }
}

if ($project_name -eq $null -or $project_name -eq "") {
    echo "Use init -project_name YourProjectName";
} else {
    echo "Bootstraping project: $project_name";
    echo "Renaming files and folders";
    RenameFiles -path "." -oldName "PROJECT_NAME" -newName $project_name;
    echo "Replacing values";
    FindAndReplace -path "." -find "PROJECT_NAME" -replace $project_name;
    echo "Done";
}
