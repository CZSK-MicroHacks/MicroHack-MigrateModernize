#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Grants Contributor role to resource groups rg-onprem1 to rg-onprem15 for paired users.

.DESCRIPTION
    This script assigns Contributor role to resource groups rg-onpremX (where X is 1-15)
    for three users per resource group:
    - UserY@MngEnvMCAP346784.onmicrosoft.com (Y starts at 001, increments by 3)
    - UserZ@MngEnvMCAP346784.onmicrosoft.com (Z starts at 002, increments by 3)
    - UserQ@MngEnvMCAP346784.onmicrosoft.com (Q starts at 003, increments by 3)
    
    Example assignments:
    - rg-onprem1: User001, User002, and User003
    - rg-onprem2: User004, User005, and User006
    - rg-onprem3: User007, User008, and User009
    - ...
    - rg-onprem15: User043, User044, and User045

.PARAMETER StartRG
    The starting resource group number. Default is 1.

.PARAMETER EndRG
    The ending resource group number. Default is 15.

.EXAMPLE
    .\Grant-OnPremResourceGroupAccess.ps1

.EXAMPLE
    .\Grant-OnPremResourceGroupAccess.ps1 -StartRG 1 -EndRG 5
#>

param(
    [Parameter(Mandatory=$false)]
    [int]$StartRG = 1,
    
    [Parameter(Mandatory=$false)]
    [int]$EndRG = 15
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
$subscriptionId = az account show --query id -o tsv
Write-Host "Current subscription: $currentSubscription" -ForegroundColor Green
Write-Host ""

# Calculate user range
$startUserY = 1 + (($StartRG - 1) * 3)
$endUserQ = 3 + (($EndRG - 1) * 3)

# Confirm before proceeding
Write-Host "This script will grant Contributor role to $($EndRG - $StartRG + 1) resource groups." -ForegroundColor Yellow
Write-Host "Resource groups: rg-onprem$StartRG to rg-onprem$EndRG" -ForegroundColor Yellow
Write-Host "Users: User$('{0:D3}' -f $startUserY) to User$('{0:D3}' -f $endUserQ)" -ForegroundColor Yellow
Write-Host ""
$confirm = Read-Host "Do you want to continue? (Y/N)"
if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "Operation cancelled by user." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Starting role assignments..." -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$failureCount = 0
$failures = @()

for ($x = $StartRG; $x -le $EndRG; $x++) {
    $rgName = "rg-onprem$x"
    
    # Calculate user numbers for this resource group
    $userYNumber = 1 + (($x - 1) * 3)  # 1, 4, 7, 10, ...
    $userZNumber = 2 + (($x - 1) * 3)  # 2, 5, 8, 11, ...
    $userQNumber = 3 + (($x - 1) * 3)  # 3, 6, 9, 12, ...
    
    $userY = "User$('{0:D3}' -f $userYNumber)@MngEnvMCAP346784.onmicrosoft.com"
    $userZ = "User$('{0:D3}' -f $userZNumber)@MngEnvMCAP346784.onmicrosoft.com"
    $userQ = "User$('{0:D3}' -f $userQNumber)@MngEnvMCAP346784.onmicrosoft.com"
    
    Write-Host "[$x/$EndRG] Processing $rgName..." -ForegroundColor White
    Write-Host "  Users: $userY, $userZ, $userQ" -ForegroundColor Gray
    
    # Check if resource group exists
    Write-Host "  Checking if resource group exists..." -ForegroundColor Gray
    $rgExists = az group show --name $rgName 2>$null
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ✗ Error: Resource group '$rgName' does not exist!" -ForegroundColor Red
        $failures += "$rgName - Resource group does not exist"
        $failureCount++
        Write-Host ""
        continue
    }
    
    Write-Host "  ✓ Resource group exists" -ForegroundColor Green
    
    # Process UserY
    try {
        Write-Host "  Assigning Contributor role to: $userY" -ForegroundColor Gray
        
        # Check if user exists and get object ID
        $userYObjectId = az ad user show --id $userY --query id -o tsv 2>$null
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "    ✗ Warning: User $userY not found in Azure AD" -ForegroundColor Red
            $failures += "$rgName - User $userY not found in Azure AD"
            $failureCount++
        } else {
            # Create role assignment
            $roleResult = az role assignment create `
                --role "Contributor" `
                --assignee-object-id $userYObjectId `
                --assignee-principal-type "User" `
                --scope "/subscriptions/$subscriptionId/resourceGroups/$rgName" `
                --output none 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    ✓ Role assigned to $userY" -ForegroundColor Green
                $successCount++
            } else {
                # Check if assignment already exists
                $existingAssignment = az role assignment list `
                    --assignee $userYObjectId `
                    --role "Contributor" `
                    --scope "/subscriptions/$subscriptionId/resourceGroups/$rgName" 2>$null
                
                if ($existingAssignment -and $existingAssignment -ne "[]") {
                    Write-Host "    ℹ Role assignment already exists for $userY" -ForegroundColor Yellow
                    $successCount++
                } else {
                    Write-Host "    ✗ Failed to assign role to $userY : $roleResult" -ForegroundColor Red
                    $failures += "$rgName - Failed to assign role to $userY"
                    $failureCount++
                }
            }
        }
    } catch {
        Write-Host "    ✗ Error processing $userY : $_" -ForegroundColor Red
        $failures += "$rgName - Error processing $userY : $_"
        $failureCount++
    }
    
    # Process UserZ
    try {
        Write-Host "  Assigning Contributor role to: $userZ" -ForegroundColor Gray
        
        # Check if user exists and get object ID
        $userZObjectId = az ad user show --id $userZ --query id -o tsv 2>$null
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "    ✗ Warning: User $userZ not found in Azure AD" -ForegroundColor Red
            $failures += "$rgName - User $userZ not found in Azure AD"
            $failureCount++
        } else {
            # Create role assignment
            $roleResult = az role assignment create `
                --role "Contributor" `
                --assignee-object-id $userZObjectId `
                --assignee-principal-type "User" `
                --scope "/subscriptions/$subscriptionId/resourceGroups/$rgName" `
                --output none 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    ✓ Role assigned to $userZ" -ForegroundColor Green
                $successCount++
            } else {
                # Check if assignment already exists
                $existingAssignment = az role assignment list `
                    --assignee $userZObjectId `
                    --role "Contributor" `
                    --scope "/subscriptions/$subscriptionId/resourceGroups/$rgName" 2>$null
                
                if ($existingAssignment -and $existingAssignment -ne "[]") {
                    Write-Host "    ℹ Role assignment already exists for $userZ" -ForegroundColor Yellow
                    $successCount++
                } else {
                    Write-Host "    ✗ Failed to assign role to $userZ : $roleResult" -ForegroundColor Red
                    $failures += "$rgName - Failed to assign role to $userZ"
                    $failureCount++
                }
            }
        }
    } catch {
        Write-Host "    ✗ Error processing $userZ : $_" -ForegroundColor Red
        $failures += "$rgName - Error processing $userZ : $_"
        $failureCount++
    }
    
    # Process UserQ
    try {
        Write-Host "  Assigning Contributor role to: $userQ" -ForegroundColor Gray
        
        # Check if user exists and get object ID
        $userQObjectId = az ad user show --id $userQ --query id -o tsv 2>$null
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "    ✗ Warning: User $userQ not found in Azure AD" -ForegroundColor Red
            $failures += "$rgName - User $userQ not found in Azure AD"
            $failureCount++
        } else {
            # Create role assignment
            $roleResult = az role assignment create `
                --role "Contributor" `
                --assignee-object-id $userQObjectId `
                --assignee-principal-type "User" `
                --scope "/subscriptions/$subscriptionId/resourceGroups/$rgName" `
                --output none 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    ✓ Role assigned to $userQ" -ForegroundColor Green
                $successCount++
            } else {
                # Check if assignment already exists
                $existingAssignment = az role assignment list `
                    --assignee $userQObjectId `
                    --role "Contributor" `
                    --scope "/subscriptions/$subscriptionId/resourceGroups/$rgName" 2>$null
                
                if ($existingAssignment -and $existingAssignment -ne "[]") {
                    Write-Host "    ℹ Role assignment already exists for $userQ" -ForegroundColor Yellow
                    $successCount++
                } else {
                    Write-Host "    ✗ Failed to assign role to $userQ : $roleResult" -ForegroundColor Red
                    $failures += "$rgName - Failed to assign role to $userQ"
                    $failureCount++
                }
            }
        }
    } catch {
        Write-Host "    ✗ Error processing $userQ : $_" -ForegroundColor Red
        $failures += "$rgName - Error processing $userQ : $_"
        $failureCount++
    }
    
    Write-Host ""
}

# Summary
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Resource groups processed: $($EndRG - $StartRG + 1)" -ForegroundColor White
Write-Host "  Total role assignments attempted: $(($EndRG - $StartRG + 1) * 3)" -ForegroundColor White
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
