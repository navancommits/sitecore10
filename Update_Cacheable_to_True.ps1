$VerbosePreference = "continue"
$path = "master:/sitecore/layout/renderings"

Write-Log "Get all renderings and update cacheable to true."

 foreach($item in Get-ChildItem -Path $path -Recurse | 
Where-Object { $item.TemplateName -ne "Rendering Folder" }) {
    $item.Editing.BeginEdit()
    $item.Fields["Cacheable"] = "1"
    $item.Editing.EndEdit() | Out-Null
  }
