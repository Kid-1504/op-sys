<#
.SYNOPSIS
    Searches for a string in .txt files and saves the results to an output file.
.DESCRIPTION
    This script searches all .txt files in the current directory and subdirectories
    for the specified string and writes the matching file paths to an output file.
.PARAMETER searchString
    The string to search for in .txt files
.PARAMETER outputFile
    The file path to save the results to
.EXAMPLE
    .\SearchTextFiles.ps1 "hello world" "results.txt"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$searchString,
    
    [Parameter(Mandatory=$true)]
    [string]$outputFile
)

# Check if output file already exists
if (Test-Path $outputFile) {
    $answer = Read-Host "File '$outputFile' already exists. Overwrite? (y/n)"
    if ($answer -ne "y") {
        Write-Host "Operation cancelled."
        exit 1
    }
}

Write-Host "Searching for '$searchString' in .txt files..."

# Search for files containing the string and save to output file
$files = Get-ChildItem -Recurse -Filter "*.txt" | 
         Select-String -Pattern $searchString -List | 
         Select-Object -ExpandProperty Path

# Process results
if ($files.Count -gt 0) {
    $files | Out-File -FilePath $outputFile
    Write-Host "Found $($files.Count) files. List saved to '$outputFile'"
} else {
    Write-Host "No files containing '$searchString' were found."
    if (Test-Path $outputFile) { Remove-Item $outputFile }
}
