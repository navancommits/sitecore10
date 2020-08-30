#define parameters
Param(
 [string]$Prefix = "xc10",
 [string]$CommDbPrefix = "Sitecore",
 [string]$SiteName = "xc10sc.dev.local",  
 [string]$SitecoreBizFxSiteName = "SitecoreBizFx",
 [string]$CommerceServicesPostfix = "Sc",
 [string]$SolrService = 'xc10solr-8.4.0',
 [string]$PathToSolr = 'C:\Solr\xc10solr-8.4.0',
 [string]$SqlServer = 'dbservername\instancename',
 [string]$SqlAccount = 'sa',
 [string]$SqlPassword = 'sqlpwd',
 [string]$SitecorexConnectSiteName = "xc10xconnect.dev.local",
 [string]$SitecoreIdentityServerSiteName = "xc10IdentityServer.dev.local",
 [string]$CommerceServicesHostPostfix = "$CommerceServicesPostfix.com",  
 [string]$CommerceOpsSiteName = "CommerceOps_$CommerceServicesPostfix",
 [string]$CommerceShopsSiteName = "CommerceShops_$CommerceServicesPostfix",
 [string]$CommerceAuthoringSiteName = "CommerceAuthoring_$CommerceServicesPostfix",
 [string]$CommerceMinionsSiteName = "CommerceMinions_$CommerceServicesPostfix",   
 [string]$SitecoreMarketingAutomationService="$SitecorexConnectSiteName-MarketingAutomationService",
 [string]$SitecoreProcessingEngineService="$SitecorexConnectSiteName-ProcessingEngineService",
 [string]$SitecoreIndexWorkerService="$SitecorexConnectSiteName-IndexWorker" 
)

Function Remove-Service{
 [CmdletBinding()]
 param(
  [string]$serviceName
 )
 if(Get-Service $serviceName -ErrorAction SilentlyContinue){
  sc.exe delete $serviceName
 }
}

Function Stop-Service{
 [CmdletBinding()]
 param(
  [string]$serviceName
 )
If (Get-Service $serviceName -ErrorAction SilentlyContinue) {

    If ((Get-Service $serviceName).Status -eq 'Running') {

        Stop-Service $serviceName
        Write-Host "Stopping $serviceName"

    } 
}
}


Function Remove-Website{
 [CmdletBinding()]
 param(
  [string]$siteName  
 )

 $appCmd = "C:\windows\system32\inetsrv\appcmd.exe"
 & $appCmd delete site $siteName
}

Function Remove-AppPool{
 [CmdletBinding()]
 param(  
  [string]$appPoolName
 )

 $appCmd = "C:\windows\system32\inetsrv\appcmd.exe"
 & $appCmd delete apppool $appPoolName
}

if (Test-Path "IIS:\Sites\Default Web Site\$CommerceOpsSiteName") { Stop-Website -Name $CommerceOpsSiteName }
if (Test-Path "IIS:\Sites\Default Web Site\$CommerceShopsSiteName") { Stop-Website -Name $CommerceShopsSiteName }
if (Test-Path "IIS:\Sites\Default Web Site\$CommerceAuthoringSiteName") { Stop-Website -Name $CommerceAuthoringSiteName }
if (Test-Path "IIS:\Sites\Default Web Site\$CommerceMinionsSiteName") { Stop-Website -Name $CommerceMinionsSiteName } 
if (Test-Path "IIS:\Sites\Default Web Site\$SitecoreBizFxSiteName") { Stop-Website -Name $SitecoreBizFxSiteName } 
if (Test-Path "IIS:\Sites\Default Web Site\$SitecoreIdentityServerSiteName") { Stop-Website -Name $SitecoreIdentityServerSiteName } 
if (Test-Path "IIS:\Sites\Default Web Site\$SiteName") { Stop-Website -Name $SiteName } 
if (Test-Path "IIS:\Sites\Default Web Site\$SitecorexConnectSiteName") { Stop-Website -Name $SitecorexConnectSiteName } 

$IISPath = "IIS:\AppPools"

if (Test-Path "IIS:\AppPools\$CommerceOpsSiteName") { Stop-WebAppPool -Name $CommerceOpsSiteName }
if (Test-Path "IIS:\AppPools\$CommerceShopsSiteName") { Stop-WebAppPool -Name $CommerceShopsSiteName }
if (Test-Path "IIS:\AppPools\$CommerceAuthoringSiteName") { Stop-WebAppPool -Name $CommerceAuthoringSiteName }
if (Test-Path "IIS:\AppPools\$CommerceMinionsSiteName") { Stop-WebAppPool -Name $CommerceMinionsSiteName }
if (Test-Path "IIS:\AppPools\$SitecoreBizFxSiteName") { Stop-WebAppPool -Name $SitecoreBizFxSiteName }
if (Test-Path "IIS:\AppPools\$SitecoreIdentityServerSiteName") { Stop-WebAppPool -Name $SitecoreIdentityServerSiteName }
if (Test-Path "IIS:\AppPools\$SiteName") { Stop-WebAppPool -Name $SiteName }
if (Test-Path "IIS:\AppPools\$SitecorexConnectSiteName") { Stop-WebAppPool -Name $SitecorexConnectSiteName }

#Stop Solr Service
Write-Host "Stopping solr service"
Stop-Service $SolrService  
Write-Host "Solr service stopped successfully"
   
#Delete solr cores
Write-Host "Deleting Solr directory"
$pathToCores = $PathToSolr
Remove-Item $PathToSolr -recurse -force -ErrorAction stop
Write-Host "Solr folder deleted successfully"


Write-Host "Stopping Marketing Automation service"
Stop-Service $SitecoreMarketingAutomationService 
Write-Host "Marketing Automation service stopped successfully"

Remove-Service $SitecoreMarketingAutomationService

Write-Host "Stopping Processing Engine service"
Stop-Service $SitecoreProcessingEngineService  
Write-Host "Processing Engine service stopped successfully"

Remove-Service $SitecoreProcessingEngineService

Write-Host "Stopping Index Worker service"
Stop-Service $SitecoreIndexWorkerService  
Write-Host "Index Worker service stopped successfully"

Remove-Service $SitecoreIndexWorkerService


#Remove Sites and App Pools from IIS
Write-Host "Deleting Websites"
Remove-Website -siteName $CommerceOpsSiteName -ErrorAction stop
Remove-Website -siteName $CommerceShopsSiteName -ErrorAction stop
Remove-Website -siteName $CommerceAuthoringSiteName -ErrorAction stop
Remove-Website -siteName $CommerceMinionsSiteName  -ErrorAction stop
Remove-Website -siteName $SitecoreBizFxSiteName -ErrorAction stop
Remove-Website -siteName $SitecorexConnectSiteName -ErrorAction stop
Remove-Website -siteName $SitecoreIdentityServerSiteName -ErrorAction stop
Remove-Website -siteName $SiteName -ErrorAction stop
Write-Host "Websites deleted"


Write-Host "Deleting Application pools"
Remove-AppPool -appPoolName $CommerceOpsSiteName -ErrorAction stop
Remove-AppPool -appPoolName $CommerceShopsSiteName -ErrorAction stop
Remove-AppPool -appPoolName $CommerceAuthoringSiteName -ErrorAction stop
Remove-AppPool -appPoolName $CommerceMinionsSiteName -ErrorAction stop
Remove-AppPool -appPoolName $SitecoreBizFxSiteName -ErrorAction stop
Remove-AppPool -appPoolName $SitecoreIdentityServerSiteName -ErrorAction stop
Remove-AppPool -appPoolName $SiteName -ErrorAction stop
Remove-AppPool -appPoolName $SitecorexConnectSiteName -ErrorAction stop
Write-Host "Application pools deleted"

Write-Host "Deleting Websites from wwwroot"
rm C:\inetpub\wwwroot\$CommerceOpsSiteName -force -recurse -ea ig
rm C:\inetpub\wwwroot\$CommerceShopsSiteName -force -recurse -ea ig
rm C:\inetpub\wwwroot\$CommerceAuthoringSiteName -force -recurse -ea ig
rm C:\inetpub\wwwroot\$CommerceMinionsSiteName -force -recurse  -ea ig
rm C:\inetpub\wwwroot\$SitecoreBizFxSiteName -force -recurse  -ea ig
rm C:\inetpub\wwwroot\$SitecoreIdentityServerSiteName -force -recurse  -ea ig
rm C:\inetpub\wwwroot\$SiteName  -recurse -force  -ea ig
rm C:\inetpub\wwwroot\$SitecorexConnectSiteName  -recurse -force   -ea ig
Write-Host "Websites removed from wwwroot"


#Write-TaskHeader -TaskName "SQL Server" -TaskType "Drop Databases"
#Drop databases from SQL
Write-Host "Dropping databases from SQL server"
push-location
import-module sqlps

Write-Host $("Dropping Sitecore databases")
$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_Core]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_Master]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_Web]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_EXM.Master]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_ReferenceData]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_Reporting]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_ExperienceForms]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_MarketingAutomation]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_Processing.Pools]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_Processing.Tasks]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_ProcessingEngineStorage]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_ProcessingEngineTasks]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_Xdb.Collection.Shard0]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_Xdb.Collection.Shard1]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_Xdb.Collection.ShardMapManager]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$sitecoreDbPrefix = "DROP DATABASE IF EXISTS [" + $Prefix + "_Messaging]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $sitecoreDbPrefix -ErrorAction stop

$commerceDbPrefix = "DROP DATABASE IF EXISTS [" + $CommDbPrefix + "_Global]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $commerceDbPrefix -ErrorAction stop

$commerceDbPrefix = "DROP DATABASE IF EXISTS [" + $CommDbPrefix + "_SharedEnvironments]"
invoke-sqlcmd -ServerInstance $SqlServer -U $SqlAccount -P $SqlPassword -Query $commerceDbPrefix -ErrorAction stop

Write-Host "Databases dropped successfully"
pop-location