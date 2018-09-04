param (
[Parameter(Mandatory=$true)][string]$templateName,
[Parameter(Mandatory=$true)][string]$siteCollectionUrl,
[Parameter(Mandatory=$true)][string]$siteCollectionTitle,
[Parameter(Mandatory=$true)][string]$organisationLabel,
[Parameter(Mandatory=$true)][string]$organisationGuid,
[Parameter(Mandatory=$true)][string]$newsFilterType,
[Parameter(Mandatory=$true)][string]$newsFilterValue,
[Parameter(Mandatory=$true)][string]$resourcesSearchQuery,
[Parameter(Mandatory=$true)][string]$functionResourcesSearchQuery,
[Parameter(Mandatory=$true)][string]$organisationLibraryUrl,
[Parameter(Mandatory=$true)][string]$organisationPrivateLibraryUrl
)

$json = $null

#load custom assembly for extensibility handlers
Add-Type -Path .\Nintex\SPR.Provisioning.dll
$handler = New-PnPExtensibilityHandlerObject -Assembly "SPR.Provisioning, Version=1.0.0.0, Culture=neutral, PublicKeyToken=0b6111688a847bb4" -type "SPR.Provisioning.PnpNintex"
#$siteCollectionTitle = $null

function loadJSON(){
    $jsonFile = Get-Content -Raw $templateName 
    
    $jsonFile = $jsonFile -replace "{parameter:functionDefaultLabel}", $web.functionLabel
    $jsonFile = $jsonFile -replace "{parameter:functionDefaultGuid}", $web.functionGuid
    $jsonFile = $jsonFile -replace "{parameter:sitecollectionUrl}", $siteCollectionUrl

    $jsonFile = $jsonFile -replace "{parameter:newsFilterType}", $newsFilterType
    $jsonFile = $jsonFile -replace "{parameter:newsFilterValue}", $newsFilterValue
    $jsonFile = $jsonFile -replace "{parameter:functionLabel}", $functionLabel
    $jsonFile = $jsonFile -replace "{parameter:functionGuid}", $functionGuid
    $jsonFile = $jsonFile -replace "{parameter:organisationLabel}", $organisationLabel
    $jsonFile = $jsonFile -replace "{parameter:organisationGuid}", $organisationGuid
    $jsonFile = $jsonFile -replace "{parameter:siteCollectionTitle}", $siteCollectionTitle
    $jsonFile = $jsonFile -replace "{parameter:resourcesSearchQuery}", $resourcesSearchQuery
    $jsonFile = $jsonFile -replace "{parameter:functionResourcesSearchQuery}", $functionResourcesSearchQuery
    $jsonFile = $jsonFile -replace "{parameter:organisationLibraryUrl}", $organisationLibraryUrl
    $jsonFile = $jsonFile -replace "{parameter:organisationPrivateLibraryUrl}", $organisationPrivateLibraryUrl

    $json = $jsonFile | ConvertFrom-Json

    #$json.organisationLabel = $organisationLabel
    #$json.organisationGuid = $organisationGuid
    #$json.newsFilterType = $newsFilterType
    #$json.newsFilterValue = $newsFilterValue
    #$json.resourcesSearchQuery = $resourcesSearchQuery

    processWeb $json "top" $siteCollectionUrl
    processWeb $json "final" $siteCollectionUrl
}



function processWeb($web, $level, $url) {

    
    

    if (($level -ne "top") -and ($level -ne "final")) {
        $webUrl = $url + "/" + $web.url
        Write-Output $webUrl;
        if($webUrl -ccontains "workingarea") {
            Remove-PnPList -Identity "Shared Documents" -ErrorAction SilentlyContinue
        }
    }
    else {
        Write-Output "Processing Site $siteCollectionUrl"
        $webUrl = $url
    }

    applyTemplatesToWeb $web $webUrl $level
    if ($level -ne "final") {
        foreach ($subWeb in $web.webs.web) {
            processWeb $subWeb "subweb" $webUrl
        }
    }
}

function applyTemplatesToWeb ($web, $url, $level) {
    Write-Output "Connecting to $url"
    Connect-PnPOnline -CurrentCredentials $url
    if ($level -ne "final") {
        foreach ($template in $web.templates) {
            $templateName =  $template.template
            Write-Host "Processing '$templateName'..."
            $guid = [guid]::NewGuid()
            $tempFileName = ".\" + $guid.ToString() + "_" + $templateName
            Copy $templateName $tempFileName
            parseTemplate $web $tempFileName $level
            #Read-PnPProvisioningTemplate -Path $tempFileName
            Apply-PnPProvisioningTemplate -Path $tempFileName -ExtensibilityHandlers $handler
            Del $tempFileName
        }
    }
    else
    {
        foreach ($template in $web.postProcessemplates) {
            $templateName =  $template.template
            Write-Host "Processing final template '$templateName'..."
            $guid = [guid]::NewGuid()
            $tempFileName = ".\" + $guid.ToString() + "_" + $templateName
            Copy $templateName $tempFileName
            parseTemplate $web $tempFileName $level

            Apply-PnPProvisioningTemplate -Path $tempFileName -ExtensibilityHandlers $handler
            Del $tempFileName
        }
    }
}

function parseTemplate($web, $tempTemplateFile, $level) {
    $templateContent = Get-Content -Raw $tempTemplateFile

    $templateContent = $templateContent -replace "{parameter:functionDefaultLabel}", $web.functionLabel
    $templateContent = $templateContent -replace "{parameter:functionDefaultGuid}", $web.functionGuid
    $templateContent = $templateContent -replace "{parameter:organisationDefaultLabel}", $organisationLabel
    $templateContent = $templateContent -replace "{parameter:organisationDefaultGuid}", $organisationGuid
    $templateContent = $templateContent -replace "{parameter:siteCollectionTitle}", $siteCollectionTitle

    $templateContent = $templateContent -replace "{parameter:newsFilterType}", $web.newsFilterType
    $templateContent = $templateContent -replace "{parameter:newsFilterValue}", $web.newsFilterValue
    $templateContent = $templateContent -replace "{parameter:functionLabel}", $web.functionLabel
    $templateContent = $templateContent -replace "{parameter:functionGuid}", $web.functionGuid
    $templateContent = $templateContent -replace "{parameter:organisationLabel}", $organisationLabel
    $templateContent = $templateContent -replace "{parameter:organisationGuid}", $organisationGuid
    $templateContent = $templateContent -replace "{parameter:siteCollectionTitle}", $siteCollectionTitle
    $templateContent = $templateContent -replace "{parameter:organisationLibraryUrl}", $web.organisationLibraryUrl
    $templateContent = $templateContent -replace "{parameter:parentSiteName}", $web.parentSiteName
    
    $templateContent = $templateContent -replace "{parameter:organisationPrivateLibraryUrl}", $web.organisationPrivateLibraryUrl
    
    $templateContent = $templateContent -replace "{parameter:resourcesSearchQuery}", $resourcesSearchQuery
    $thisFunctionResourcesSearchQuery = $functionResourcesSearchQuery
    $thisFunctionResourcesSearchQuery = $thisFunctionResourcesSearchQuery -replace "{function}", $web.url
    $templateContent = $templateContent -replace "{parameter:functionResourcesSearchQuery}",$thisFunctionResourcesSearchQuery


    $templateContent | Out-File $tempTemplateFile
}

loadJSON