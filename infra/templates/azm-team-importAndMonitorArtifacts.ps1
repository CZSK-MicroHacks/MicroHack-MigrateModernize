# Ensure we're using Az modules and remove any AzureRM conflicts
Import-Module Az.Accounts, Az.Resources -Force
Get-Module -Name AzureRM* | Remove-Module -Force

# Generate unique environment name with timestamp
$timestamp = Get-Date -Format "MMddHHmm"
$environmentName = "mig$timestamp"

$subscriptionId = (Get-AzContext).Subscription.Id
$resourceGroup = "$environmentName-rg"
 $masterSiteName = "$($environmentName)mastersite"
 $migrateProjectName = "${environmentName}-azm"
 $assessmentProjectName = "${environmentName}-asmproject"
 $vmwarecollectorName = "${environmentName}-vmwaresitevmwarecollector"

 $apiVersionOffAzure = "2024-12-01-preview"


 $remoteZipFilePath = "https://github.com/crgarcia12/migrate-modernize-lab/raw/refs/heads/main/lab-material/Azure-Migrate-Discovery.zip"
 $localZipFilePath = Join-Path (Get-Location) "importArtifacts.zip"

 # Create resource group and deploy ARM template
   Write-Host "Creating new resource group: $resourceGroup"
   New-AzResourceGroup -Name "$resourceGroup" -Location "swedencentral" -Force
   
   # Check if ARM template exists, if not skip deployment
   if (Test-Path '.\azure-migrate-artifacts-template.json') {
       Write-Host "Deploying ARM template..."
       New-AzResourceGroupDeployment `
           -Name $environmentName `
           -ResourceGroupName "$resourceGroup" `
           -TemplateFile '.\azure-migrate-artifacts-template.json' `
           -prefix $environmentName `
           -Verbose
   } else {
       Write-Host "ARM template not found, skipping template deployment" -ForegroundColor Yellow
   }

# # # Get access token for REST API calls
  $token = (Get-AzAccessToken -ResourceUrl "https://management.azure.com/").Token

  $headers=@{} 
  $headers.Add("authorization", "Bearer $token") 
  $headers.Add("content-type", "application/json") 

   $registerToolApi = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/MigrateProjects/$migrateProjectName/registerTool?api-version=2020-06-01-preview"
   Write-Host "Register Server Discovery"
   $response = Invoke-RestMethod -Uri $registerToolApi `
      -Method POST `
      -Headers $headers `
       -ContentType 'application/json' `
       -Body '{   "tool": "ServerDiscovery" }'

   Write-Host "Register Server Assessment"
   $response = Invoke-RestMethod -Uri $registerToolApi `
      -Method POST `
      -Headers $headers `
      -ContentType 'application/json' `
      -Body '{   "tool": "ServerAssessment" }'

   Invoke-WebRequest $remoteZipFilePath -OutFile $localZipFilePath

# # # # Upload the ZIP file to OffAzure and start import
   $importUriUrl = "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.OffAzure/masterSites/${masterSiteName}/Import?api-version=${apiVersionOffAzure}"
   $importdiscoveredArtifactsResponse = Invoke-RestMethod -Uri $importUriUrl -Method POST -Headers $headers
   $blobUri = $importdiscoveredArtifactsResponse.uri
   $jobArmId = $importdiscoveredArtifactsResponse.jobArmId

   Write-Host "blob URI: $blobUri"
   Write-Host "Job ARM ID: $jobArmId"

   Write-Host "Uploading ZIP to blob.."
   $fileBytes = [System.IO.File]::ReadAllBytes($localZipFilePath)
   $uploadBlobHeaders = @{
      "x-ms-blob-type" = "BlockBlob"
      "x-ms-version"   = "2020-04-08"
   }
   Invoke-RestMethod -Uri $blobUri -Method PUT -Headers $uploadBlobHeaders -Body $fileBytes -ContentType "application/octet-stream"
   Write-Host "Done ZIP to blob.."
   $jobUrl = "https://management.azure.com${jobArmId}?api-version=${apiVersionOffAzure}"

   Write-Host "Polling import job status..."
   $waitTimeSeconds = 20
   $maxAttempts = 50 * (60 / $waitTimeSeconds)  # 50 minutes timeout
   $attempt = 0
   $jobCompleted = $false
 
   do {
       $jobStatus = Invoke-RestMethod -Uri $jobUrl -Method GET -Headers $headers
       $jobResult = $jobStatus.properties.jobResult
       Write-Host "Attempt $($attempt): Job status - $jobResult"

       if ($jobResult -eq "Completed") {
           $jobCompleted = $true
           break
       } elseif ($jobResult -eq "Failed") {
           throw "Import job failed."
       }
       Start-Sleep -Seconds $waitTimeSeconds
       $attempt++
  } while ($attempt -lt $maxAttempts)

  if (-not $jobCompleted) {
      throw "Timed out waiting for import job to complete."
  } else {
       Write-Host "Import job completed. Imported $importedCount machines."
   }

# Get VMware site first
$vmwareSiteUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/VMwareSites/$($environmentName)vmwaresite?api-version=2024-12-01-preview"
$vmwareSiteResponse = Invoke-RestMethod -Uri $vmwareSiteUri -Method GET -Headers $headers
$vmwareSiteId = $vmwareSiteResponse.id
$agentId = $vmwareSiteResponse.properties.agentDetails.id

# Get WebApp site
Write-Host "Getting WebApp Site"
$webAppSiteName = "$($environmentName)webappsite"
$webAppSiteUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/MasterSites/$masterSiteName/WebAppSites/$($environmentName)webappsite?api-version=2024-12-01-preview"
Write-Host "WebApp Site URI: $webAppSiteUri"

try {
    $webAppSiteResponse = Invoke-RestMethod -Uri $webAppSiteUri -Method GET -Headers $headers
    $webAppSiteId = $webAppSiteResponse.id
    
    # Extract agent ID from siteAppliancePropertiesCollection
    if ($webAppSiteResponse.properties.siteAppliancePropertiesCollection -and $webAppSiteResponse.properties.siteAppliancePropertiesCollection.Count -gt 0) {
        $webAppAgentId = $webAppSiteResponse.properties.siteAppliancePropertiesCollection[0].agentDetails.id
        Write-Host "WebApp Agent ID: $webAppAgentId"
    } else {
        Write-Host "No appliance properties found in WebApp site" -ForegroundColor Yellow
        $webAppAgentId = $null
    }
    
    Write-Host "WebApp Site ID: $webAppSiteId"
    Write-Host "WebApp Site retrieved successfully"
} catch {
    Write-Host "Failed to get WebApp Site: $($_.Exception.Message)" -ForegroundColor Yellow
    $webAppSiteId = $null
    $webAppAgentId = $null
}

# Get SQL Site
Write-Host "Getting SQL Site"
$sqlSiteName = "$($environmentName)sqlsites"
$sqlSiteUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/MasterSites/$masterSiteName/SqlSites/$($environmentName)sqlsites?api-version=2024-12-01-preview"
Write-Host "SQL Site URI: $sqlSiteUri"

try {
    $sqlSiteResponse = Invoke-RestMethod -Uri $sqlSiteUri -Method GET -Headers $headers
    $sqlSiteId = $sqlSiteResponse.id
    
    # Extract agent ID from siteAppliancePropertiesCollection
    if ($sqlSiteResponse.properties.siteAppliancePropertiesCollection -and $sqlSiteResponse.properties.siteAppliancePropertiesCollection.Count -gt 0) {
        $sqlAgentId = $sqlSiteResponse.properties.siteAppliancePropertiesCollection[0].agentDetails.id
        Write-Host "SQL Agent ID: $sqlAgentId"
    } else {
        Write-Host "No appliance properties found in SQL site" -ForegroundColor Yellow
        $sqlAgentId = $null
    }
    
    Write-Host "SQL Site ID: $sqlSiteId"
    Write-Host "SQL Site retrieved successfully"
} catch {
    Write-Host "Failed to get SQL Site: $($_.Exception.Message)" -ForegroundColor Yellow
    $sqlSiteId = $null
    $sqlAgentId = $null
}

    # Create VMware Collector
     Write-Host "Creating VMware Collector" -ErrorAction Continue
    $assessmentProjectName = "${environmentName}asmproject"
    $vmwarecollectorName = "${environmentName}vmwaresitevmwarecollector"

    # Get site first
    $vmwareSiteUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/VMwareSites/$($environmentName)vmwaresite?api-version=2024-12-01-preview"
    $vmwareSiteResponse = Invoke-RestMethod -Uri $vmwareSiteUri -Method GET -Headers $headers


    $vmwareCollectorUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/assessmentprojects/$assessmentProjectName/vmwarecollectors/$($vmwarecollectorName)?api-version=2018-06-30-preview"
    $vmwareCollectorBody = @{
        "id" = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/assessmentprojects/$assessmentProjectName/vmwarecollectors/$vmwarecollectorName"
        "name" = "$vmwarecollectorName"
        "type" = "Microsoft.Migrate/assessmentprojects/vmwarecollectors"
        "properties" = @{
            "agentProperties" = @{
                "id" = "$($vmwareSiteResponse.properties.agentDetails.id)"
                "lastHeartbeatUtc" = "2025-04-24T09:48:04.3893222Z"
                "spnDetails" = @{
                    "authority" = "authority"
                    "applicationId" = "appId"
                    "audience" = "audience"
                    "objectId" = "objectid"
                    "tenantId" = "tenantid"
                }
            }
            "discoverySiteId" = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/VMwareSites/$($environmentName)vmwaresite"
        }
    } | ConvertTo-Json -Depth 10
    
    $response = Invoke-RestMethod -Uri $vmwareCollectorUri `
        -Method PUT `
        -Headers $headers `
        -ContentType 'application/json' `
        -Body $vmwareCollectorBody    

    # Create WebApp Collector
    Write-Host "Creating WebApp Collector"
    $webAppCollectorName = "${environmentName}webappsitecollector"
    $webAppApiVersion = "2025-09-09-preview"
    $webAppCollectorUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/assessmentprojects/$assessmentProjectName/webappcollectors/$webAppCollectorName" + "?api-version=$webAppApiVersion"
    Write-Host "WebApp Collector URI: $webAppCollectorUri"
    
    $webAppCollectorBody = @{
        "id" = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/assessmentprojects/$assessmentProjectName/webappcollectors/$webAppCollectorName"
        "name" = "$webAppCollectorName"
        "type" = "Microsoft.Migrate/assessmentprojects/webappcollectors"
        "properties" = @{
            "agentProperties" = @{
                "id" = $webAppAgentId
                "version" = $null
                "lastHeartbeatUtc" = $null
                "spnDetails" = @{
                    "authority" = "authority"
                    "applicationId" = "appId"
                    "audience" = "audience"
                    "objectId" = "objectid"
                    "tenantId" = "tenantid"
                }
            }
            "discoverySiteId" = $webAppSiteId
        }
    } | ConvertTo-Json -Depth 10
    
    if ($webAppAgentId -and $webAppSiteId) {
        $webAppResponse = Invoke-RestMethod -Uri $webAppCollectorUri `
            -Method PUT `
            -Headers $headers `
            -ContentType 'application/json' `
            -Body $webAppCollectorBody
        Write-Host "WebApp Collector created successfully"
    } else {
        Write-Host "Skipping WebApp Collector creation - missing WebApp agent ID or site ID" -ForegroundColor Yellow
    }

    # Create SQL Collector
    Write-Host "Creating SQL Collector"
    $sqlCollectorName = "${environmentName}sqlsitescollector"
    $sqlApiVersion = "2025-09-09-preview"
    $sqlCollectorUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/assessmentprojects/$assessmentProjectName/sqlcollectors/$sqlCollectorName" + "?api-version=$sqlApiVersion"
    Write-Host "SQL Collector URI: $sqlCollectorUri"
    
    $sqlCollectorBody = @{
        "id" = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/assessmentprojects/$assessmentProjectName/sqlcollectors/$sqlCollectorName"
        "name" = "$sqlCollectorName"
        "type" = "Microsoft.Migrate/assessmentprojects/sqlcollectors"
        "properties" = @{
            "agentProperties" = @{
                "id" = $sqlAgentId
                "version" = $null
                "lastHeartbeatUtc" = $null
                "spnDetails" = @{
                    "authority" = "authority"
                    "applicationId" = "appId"
                    "audience" = "audience"
                    "objectId" = "objectid"
                    "tenantId" = "tenantid"
                }
            }
            "discoverySiteId" = $sqlSiteId
        }
    } | ConvertTo-Json -Depth 10
    
    if ($sqlAgentId -and $sqlSiteId) {
        $sqlResponse = Invoke-RestMethod -Uri $sqlCollectorUri `
            -Method PUT `
            -Headers $headers `
            -ContentType 'application/json' `
            -Body $sqlCollectorBody
        Write-Host "SQL Collector created successfully"
    } else {
        Write-Host "Skipping SQL Collector creation - missing SQL agent ID or site ID" -ForegroundColor Yellow
    }

    # Create Assessment
    Write-Host "Creating Assessment"
    Write-Host "Creating All VM Assessment"
    $assessmentRandomSuffix = -join ((65..90) + (97..122) | Get-Random -Count 3 | % {[char]$_})
    $assessmentName = "assessment$assessmentRandomSuffix"
    Write-Host "Assessment Name: $assessmentName"
    $apiVersion = "2024-03-03-preview"
    $assessmentUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/assessmentprojects/$assessmentProjectName/assessments/$assessmentName" + "?api-version=$apiVersion"
    Write-Host "Assessment URI: $assessmentUri"
    
    $assessmentBody = @{
        "type" = "Microsoft.Migrate/assessmentprojects/assessments"
        "apiVersion" = "2024-03-03-preview"
        "name" = "$assessmentProjectName/$assessmentName"
        "location" = "swedencentral"
        "tags" = @{}
        "kind" = "Migrate"
        "properties" = @{
            "settings" = @{
                "performanceData" = @{
                    "timeRange" = "Day"
                    "percentile" = "Percentile95"
                }
                "scalingFactor" = 1
                "azureSecurityOfferingType" = "MDC"
                "azureHybridUseBenefit" = "Yes"
                "linuxAzureHybridUseBenefit" = "Yes"
                "savingsSettings" = @{
                    "savingsOptions" = "RI3Year"
                }
                "billingSettings" = @{
                    "licensingProgram" = "Retail"
                    "subscriptionId" = $subscriptionId
                }
                "azureDiskTypes" = @()
                "azureLocation" = "swedencentral"
                "azureVmFamilies" = @()
                "environmentType" = "Production"
                "currency" = "USD"
                "discountPercentage" = 0
                "sizingCriterion" = "PerformanceBased"
                "azurePricingTier" = "Standard"
                "azureStorageRedundancy" = "LocallyRedundant"
                "vmUptime" = @{
                    "daysPerMonth" = "31"
                    "hoursPerDay" = "24"
                }
            }
            "details" = @{}
            "scope" = @{
                "azureResourceGraphQuery" = "migrateresources`n        | where id contains `"/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/VMwareSites/$($environmentName)vmwaresite`" or`n            id contains `"/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/MasterSites/$masterSiteName/WebAppSites/$($environmentName)webappsite`" or`n            id contains `"/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/MasterSites/$masterSiteName/SqlSites/$sqlSiteName`""
                "scopeType" = "AzureResourceGraphQuery"
            }
        }
    } | ConvertTo-Json -Depth 10

    $assessmentResponse = Invoke-RestMethod -Uri $assessmentUri `
        -Method PUT `
        -Headers $headers `
        -ContentType 'application/json' `
        -Body $assessmentBody

    Write-Host "Created All VM Assessment created successfully"

    Write-Host "Creating All SQL Assessment"
    $assessmentRandomSuffix = -join ((65..90) + (97..122) | Get-Random -Count 3 | % {[char]$_})
    $assessmentName = "assessment$assessmentRandomSuffix"
    Write-Host "Assessment Name: $assessmentName"
    $apiVersion = "2024-03-03-preview"
    $assessmentUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/assessmentprojects/$assessmentProjectName/sqlassessments/$assessmentName" + "?api-version=$apiVersion"
    Write-Host "Assessment URI: $assessmentUri"
    
    $assessmentBody = @{
        "type" = "Microsoft.Migrate/assessmentprojects/assessments"
        "apiVersion" = "2024-03-03-preview"
        "name" = "$assessmentProjectName/$assessmentName"
        "location" = "swedencentral"
        "tags" = @{}
        "kind" = "Migrate"
        "properties" = @{
            "settings" = @{
                "performanceData" = @{
                    "timeRange" = "Day"
                    "percentile" = "Percentile95"
                }
                "scalingFactor" = 1
                "azureSecurityOfferingType" = "MDC"
                "osLicense" = "Yes"
                "azureLocation" = "koreasouth"
                "preferredTargets" = @(
                    "SqlMI"
                )
                "discountPercentage" = 0
                "currency" = "USD"
                "sizingCriterion" = "PerformanceBased"
                "savingsSettings" = @{
                    "savingsOptions" = "SavingsPlan1Year"
                }
                "billingSettings" = @{
                    "licensingProgram" = "Retail"
                    "subscriptionId" = "4bd2aa0f-2bd2-4d67-91a8-5a4533d58600"
                }
                "sqlServerLicense" = "Yes"
                "azureSqlVmSettings" = @{
                    "instanceSeries" = @(
                        "Ddsv4_series",
                        "Ddv4_series",
                        "Edsv4_series",
                        "Edv4_series"
                    )
                }
                "entityUptime" = @{
                    "daysPerMonth" = 31
                    "hoursPerDay" = 24
                }
                "azureSqlManagedInstanceSettings" = @{
                    "azureSqlInstanceType" = "SingleInstance"
                    "azureSqlServiceTier" = "SqlServiceTier_Automatic"
                }
                "azureSqlDatabaseSettings" = @{
                    "azureSqlComputeTier" = "Provisioned"
                    "azureSqlPurchaseModel" = "VCore"
                    "azureSqlServiceTier" = "SqlServiceTier_Automatic"
                    "azureSqlDataBaseType" = "SingleDatabase"
                }
                "environmentType" = "Production"
                "enableHadrAssessment" = $true
                "disasterRecoveryLocation" = "koreasouth"
                "multiSubnetIntent" = "DisasterRecovery"
                "isInternetAccessAvailable" = $true
                "asyncCommitModeIntent" = "DisasterRecovery"
            }
            "details" = @{}
            "scope" = @{
                "azureResourceGraphQuery" = "migrateresources`n        | where id contains `"/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/VMwareSites/$($environmentName)vmwaresite`" or`n            id contains `"/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/MasterSites/$masterSiteName/WebAppSites/$($environmentName)webappsite`" or`n            id contains `"/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/MasterSites/$masterSiteName/SqlSites/$sqlSiteName`""
                "scopeType" = "AzureResourceGraphQuery"
            }
        }
    } | ConvertTo-Json -Depth 10

    $assessmentResponse = Invoke-RestMethod -Uri $assessmentUri `
        -Method PUT `
        -Headers $headers `
        -ContentType 'application/json' `
        -Body $assessmentBody

    Write-Host "Created All SQL Assessment created successfully"
    Write-Host "Created Assessment created successfully"

    # Create Optimise for PaaS Business Case
    Write-Host "Creating Business Case"
    Write-Host "Creating OptimizeForPaas Business Case"
    $randomSuffix = -join ((65..90) + (97..122) | Get-Random -Count 3 | % {[char]$_})
    $businessCaseName = "buizzcase$randomSuffix"
    Write-Host "Business Case Name: $businessCaseName"
    $businessCaseApiVersion = "2025-09-09-preview"
    $businessCaseUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/assessmentprojects/$assessmentProjectName/businesscases/$businessCaseName" + "?api-version=$businessCaseApiVersion"
    Write-Host "Business Case URI: $businessCaseUri"
    
    $businessCaseBody = @{
        "type" = "Microsoft.Migrate/assessmentprojects/businesscases"
        "apiVersion" = $businessCaseApiVersion
        "name" = "$assessmentProjectName/$businessCaseName"
        "location" = "swedencentral"
        "kind" = "Migrate"
        "properties" = @{
            "businessCaseScope" = @{
                "scopeType" = "Datacenter"
                "azureResourceGraphQuery" = "migrateresources`n        | where id contains `"/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/VMwareSites/$($environmentName)vmwaresite`" or`n            id contains `"/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/MasterSites/$masterSiteName/WebAppSites/$($environmentName)webappsite`" or`n            id contains `"/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/MasterSites/$masterSiteName/SqlSites/$sqlSiteName`""
            }
            "settings" = @{
                "commonSettings" = @{
                    "targetLocation" = "swedencentral"
                    "infrastructureGrowthRate" = 0
                    "currency" = "USD"
                    "workloadDiscoverySource" = "Appliance"
                    "businessCaseType" = "OptimizeForPaas"
                }
                "azureSettings" = @{
                    "savingsOption" = "RI3Year"
                }
            }
            "details" = @{}
        }
    } | ConvertTo-Json -Depth 10

    $businessCaseResponse = Invoke-RestMethod -Uri $businessCaseUri `
        -Method PUT `
        -Headers $headers `
        -ContentType 'application/json' `
        -Body $businessCaseBody

    Write-Host "Business Case created successfully for Optimize for PaaS"


    # Create IaaSOnly Business Case
    Write-Host "Creating IaaSOnly Business Case"
    $randomSuffix = -join ((65..90) + (97..122) | Get-Random -Count 3 | % {[char]$_})
    $businessCaseName = "buizzcase$randomSuffix"
    Write-Host "Business Case Name: $businessCaseName"
    $businessCaseApiVersion = "2025-09-09-preview"
    $businessCaseUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/assessmentprojects/$assessmentProjectName/businesscases/$businessCaseName" + "?api-version=$businessCaseApiVersion"
    Write-Host "Business Case URI: $businessCaseUri"
    
    $businessCaseBody = @{
        "type" = "Microsoft.Migrate/assessmentprojects/businesscases"
        "apiVersion" = $businessCaseApiVersion
        "name" = "$assessmentProjectName/$businessCaseName"
        "location" = "swedencentral"
        "kind" = "Migrate"
        "properties" = @{
            "businessCaseScope" = @{
                "scopeType" = "Datacenter"
                "azureResourceGraphQuery" = "migrateresources`n        | where id contains `"/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/VMwareSites/$($environmentName)vmwaresite`" or`n            id contains `"/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/MasterSites/$masterSiteName/WebAppSites/$($environmentName)webappsite`" or`n            id contains `"/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.OffAzure/MasterSites/$masterSiteName/SqlSites/$sqlSiteName`""
            }
            "settings" = @{
                "commonSettings" = @{
                    "targetLocation" = "swedencentral"
                    "infrastructureGrowthRate" = 0
                    "currency" = "USD"
                    "workloadDiscoverySource" = "Appliance"
                    "businessCaseType" = "IaaSOnly"
                }
                "azureSettings" = @{
                    "savingsOption" = "RI3Year"
                }
            }
            "details" = @{}
        }
    } | ConvertTo-Json -Depth 10

    $businessCaseResponse = Invoke-RestMethod -Uri $businessCaseUri `
        -Method PUT `
        -Headers $headers `
        -ContentType 'application/json' `
        -Body $businessCaseBody

    Write-Host "Business Case created successfully for IaaSOnly"
    Write-Host "Business Case created successfully."

    # Create Heterogeneous Assessment
    Write-Host "Creating Heterogeneous Assessment"
    $heteroAssessmentRandomSuffix = -join ((65..90) + (97..122) | Get-Random -Count 3 | % {[char]$_})
    $heteroAssessmentName = "default-all-workloads$heteroAssessmentRandomSuffix"
    Write-Host "Heterogeneous Assessment Name: $heteroAssessmentName"
    $heteroApiVersion = "2024-03-03-preview"
    $heteroAssessmentUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/assessmentprojects/$assessmentProjectName/heterogeneousAssessments/$heteroAssessmentName" + "?api-version=$heteroApiVersion"
    Write-Host "Heterogeneous Assessment URI: $heteroAssessmentUri"
    
    $heteroAssessmentBody = @{
        "type" = "Microsoft.Migrate/assessmentProjects/heterogeneousAssessments"
        "apiVersion" = "2024-03-03-preview"
        "name" = "$assessmentProjectName/$heteroAssessmentName"
        "location" = "koreasouth"
        "tags" = @{}
        "kind" = "Migrate"
        "properties" = @{
            "assessmentArmIds" = @(
                "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/AssessmentProjects/$assessmentProjectName/assessments/assessment*",
                "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Migrate/assessmentprojects/$assessmentProjectName/sqlassessments/assessment*"
            )
        }
    } | ConvertTo-Json -Depth 10

    $heteroAssessmentResponse = Invoke-RestMethod -Uri $heteroAssessmentUri `
        -Method PUT `
        -Headers $headers `
        -ContentType 'application/json' `
        -Body $heteroAssessmentBody

    Write-Host "Heterogeneous Assessment created successfully"

    # Script execution completed
    Write-Host "Script execution completed"


