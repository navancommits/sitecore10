$SCSDK="C:\sitecore\Azure\SitecoreAzureToolkit"
$SCTemplates="https://raw.githubusercontent.com/Sitecore/Sitecore-Azure-Quickstart-Templates/master/Sitecore%2010.0.0/XMSingle"
$DeploymentId = "newresgrp20200814"
$LicenseFile = "c:\license\license.xml"
$SubscriptionId = "your azure subscription id"
$Location="australiaeast"
$CertificateFile = “c:\Sitecore\627436046BF7CCB5B92704C1BE6B0C661357C288.pfx”
$ParamFile="C:\sitecore\Azure\azuredeploy.parameters.json"
$Parameters = @{
     #set the size of all recommended instance sizes   
     #"sitecoreSKU"="Small";
     "deploymentId"=$DeploymentId;
     "authCertificateBlob" = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($CertificateFile));
     #by default this installs azuresearch
     #if you uncomment the following it will use an existing solr connectionstring that
     # you have created instead of using AzureSearch
     #"solrConnectionString"= "https://myinstancesomewhere/solr";
}
Import-Module $SCSDK\tools\Sitecore.Cloud.Cmdlets.psm1
Connect-AzAccount
Set-AzContext -SubscriptionId $SubscriptionId
Start-SitecoreAzureDeployment -Name $DeploymentId -Location $Location -ArmTemplateUrl "$SCTemplates/azuredeploy.json"  -ArmParametersPath $ParamFile  -LicenseXmlPath $LicenseFile  -SetKeyValue $Parameters