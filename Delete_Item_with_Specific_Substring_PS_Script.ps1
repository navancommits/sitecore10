$startPath = $_.Paths.FullPath
Write-Host "Processing started $(Get-Date -format 'u')"
$list = [System.Collections.ArrayList]@()
$itemsToProcess = Get-ChildItem $startPath -Language * -Recurse

if($itemsToProcess -ne $null) {
    $itemsToProcess | ForEach-Object { 
        $match = 0;
        foreach($field in $_.Fields) {
                if($field -match '.*new.*') {                    
                    $_.Paths.FullPath | Remove-Item
                    $info = [PSCustomObject]@{
                        "ID"=$_.Paths.FullPath
                        "Language"=$_.Language
                        "TemplateName"=$_.TemplateName
                        "FieldName"=$field.Name
                        "FieldType"=$field.Type
                        "FieldValue"=$field
                    }
                    [void]$list.Add($info)
            }
        }
    }
}
Write-Host "Processing ended $(Get-Date -format 'u')"
Write-Host "Items deleted: $($list.Count)"
$list | Format-Table