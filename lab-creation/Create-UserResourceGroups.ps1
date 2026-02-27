#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Creates Azure resource groups and assigns Contributor role for users 001-055.

.DESCRIPTION
    This script creates resource groups named rg-userXXX (where XXX is 001-055) and 
    grants Contributor role to corresponding users UserXXX@MngEnvMCAP346784.onmicrosoft.com.

.PARAMETER Location
    The Azure region where resource groups will be created. Default is "swedencentral".

.PARAMETER StartUser
    The starting user number. Default is 1.

.PARAMETER EndUser
    The ending user number. Default is 55.

.EXAMPLE
    .\Create-UserResourceGroups.ps1 -Location "swedencentral"

.EXAMPLE
    .\Create-UserResourceGroups.ps1 -Location "eastus" -StartUser 1 -EndUser 10
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$Location = "swedencentral",
    
    [Parameter(Mandatory=$false)]
    [int]$StartUser = 1,
    
    [Parameter(Mandatory=$false)]
    [int]$EndUser = 55
)

$ErrorActionPreference = "Stop"

# Check if Azure CLI is installed
Write-Host "Checking Azure CLI installation..." -ForegroundColor Cyan
$azCliVersion = az version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Error "Azure CLI is not installed or not in PATH. Please install from https://aka.ms/installazurecliwindows"
    exit 1
}

# Check if logged in to Azure
Write-Host "Checking Azure login status..." -ForegroundColor Cyan
$accountInfo = az account show 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Error "Not logged in to Azure. Please run 'az login' first."
    exit 1
}

$currentSubscription = (az account show --query name -o tsv)
Write-Host "Current subscription: $currentSubscription" -ForegroundColor Green
Write-Host ""

# Confirm before proceeding
Write-Host "This script will create $($EndUser - $StartUser + 1) resource groups and role assignments." -ForegroundColor Yellow
Write-Host "Location: $Location" -ForegroundColor Yellow
Write-Host "Users: User$('{0:D3}' -f $StartUser) to User$('{0:D3}' -f $EndUser)" -ForegroundColor Yellow
Write-Host ""
$confirm = Read-Host "Do you want to continue? (Y/N)"
if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "Operation cancelled by user." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Starting resource group creation and role assignment..." -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$failureCount = 0
$failures = @()

for ($i = $StartUser; $i -le $EndUser; $i++) {
    $userNumber = "{0:D3}" -f $i
    $rgName = "rg-user$userNumber"
    $userName = "User$userNumber@MngEnvMCAP346784.onmicrosoft.com"
    
    Write-Host "[$i/$EndUser] Processing user$userNumber..." -ForegroundColor White
    
    try {
        # Create resource group
        Write-Host "  Creating resource group: $rgName" -ForegroundColor Gray
        $rgResult = az group create --name $rgName --location $Location --output none 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ Resource group created successfully" -ForegroundColor Green
        } else {
            # Check if it already exists
            $existingRg = az group show --name $rgName 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  ℹ Resource group already exists" -ForegroundColor Yellow
            } else {
                throw "Failed to create resource group: $rgResult"
            }
        }
        
        # Assign Contributor role
        Write-Host "  Assigning Contributor role to: $userName" -ForegroundColor Gray
        
        # Check if user exists and get object ID
        $userObjectId = az ad user show --id $userName --query id -o tsv 2>$null
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  ✗ Warning: User $userName not found in Azure AD. Skipping role assignment." -ForegroundColor Red
            $failures += "User $userNumber - User not found in Azure AD"
            $failureCount++
            continue
        }
        
        # Create role assignment
        $roleResult = az role assignment create `
            --role "Contributor" `
            --assignee-object-id $userObjectId `
            --assignee-principal-type "User" `
            --scope "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$rgName" `
            --output none 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ Role assignment completed successfully" -ForegroundColor Green
            $successCount++
        } else {
            # Check if assignment already exists
            $existingAssignment = az role assignment list `
                --assignee $userObjectId `
                --role "Contributor" `
                --scope "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$rgName" 2>$null
            
            if ($existingAssignment -and $existingAssignment -ne "[]") {
                Write-Host "  ℹ Role assignment already exists" -ForegroundColor Yellow
                $successCount++
            } else {
                throw "Failed to assign role: $roleResult"
            }
        }
        
        Write-Host ""
        
    } catch {
        Write-Host "  ✗ Error processing user$userNumber : $_" -ForegroundColor Red
        $failures += "User $userNumber - $_"
        $failureCount++
        Write-Host ""
    }
}

# Summary
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Total users processed: $($EndUser - $StartUser + 1)" -ForegroundColor White
Write-Host "  Successful: $successCount" -ForegroundColor Green
Write-Host "  Failed: $failureCount" -ForegroundColor $(if ($failureCount -gt 0) { "Red" } else { "Green" })

if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "Failures:" -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host "  - $failure" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Script execution completed!" -ForegroundColor Cyan
