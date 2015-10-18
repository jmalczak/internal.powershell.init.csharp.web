param([String]$project_name, [Boolean]$is_service);

function FindAndReplace($path, $find, $replace) {
    $files = Get-ChildItem $path -rec -Include ("*.config", "*.cs", "*.js", "*.ts", "*.xml", "*.asax", "*.csproj", "*.sln") | 
             Where-Object { $_.FullName -notlike ".*" -and $_.FullName -notlike "*packages*" }

    foreach($file in $files) {
        (Get-Content $file.PSPath) | 
        Foreach-Object { $_ -replace $find, $replace } | 
        Set-Content $file.PSPath    
    }
}

if ($project_name -eq $null -or $project_name -eq "") {
    echo "Use init -project_name YourProjectName;
} else {
    echo "Bootstraping project: $project_name";
    echo "Renaming folders";
    echo "Done"
    echo "Replacing values"

    FindAndReplace -path "." -find "PROJECT_NAME" -replace $project_name;
    
    echo "Done"
}
