# Azure Key Vault Access Audit Script
# This script audits access to Key Vault and generates reports

param(
    [Parameter(Mandatory=$true)]
    [string]$VaultName,
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = ".\audit-reports",
    
    [Parameter(Mandatory=$false)]
    [int]$DaysToLookBack = 30
)

# Function to write colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to get Key Vault resource ID
function Get-KeyVaultResourceId {
    param([string]$VaultName, [string]$ResourceGroupName)
    
    if ($ResourceGroupName) {
        return (Get-AzKeyVault -VaultName $VaultName -ResourceGroupName $ResourceGroupName).ResourceId
    } else {
        $vaults = Get-AzKeyVault -VaultName $VaultName
        if ($vaults.Count -eq 0) {
            throw "Key Vault not found: $VaultName"
        } elseif ($vaults.Count -gt 1) {
            throw "Multiple Key Vaults found with name: $VaultName. Please specify ResourceGroupName."
        }
        return $vaults[0].ResourceId
    }
}

# Function to audit RBAC assignments
function Get-RbacAudit {
    param([string]$VaultResourceId)
    
    Write-ColorOutput "Auditing RBAC assignments..." "Yellow"
    
    $assignments = Get-AzRoleAssignment -Scope $VaultResourceId
    $rbacReport = @()
    
    foreach ($assignment in $assignments) {
        $rbacReport += [PSCustomObject]@{
            Role = $assignment.RoleDefinitionName
            PrincipalType = $assignment.ObjectType
            PrincipalName = $assignment.DisplayName
            PrincipalId = $assignment.ObjectId
            AssignmentScope = $assignment.Scope
            CreatedOn = $assignment.CreatedOn
        }
    }
    
    return $rbacReport
}

# Function to audit access logs
function Get-AccessLogAudit {
    param([string]$VaultName, [int]$DaysToLookBack)
    
    Write-ColorOutput "Auditing access logs for the last $DaysToLookBack days..." "Yellow"
    
    $startTime = (Get-Date).AddDays(-$DaysToLookBack)
    $endTime = Get-Date
    
    # Get diagnostic logs from Log Analytics
    $query = @"
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where TimeGenerated >= datetime('$($startTime.ToString("yyyy-MM-dd HH:mm:ss"))')
| where TimeGenerated <= datetime('$($endTime.ToString("yyyy-MM-dd HH:mm:ss"))')
| project TimeGenerated, OperationName, ResultType, CallerIPAddress, CallerDisplayName, SecretName, KeyName
| order by TimeGenerated desc
"@
    
    try {
        $logs = Invoke-AzOperationalInsightsQuery -WorkspaceId (Get-AzOperationalInsightsWorkspace).ResourceId -Query $query
        return $logs.Results
    }
    catch {
        Write-ColorOutput "Warning: Could not retrieve access logs. Make sure diagnostic settings are configured." "Yellow"
        return @()
    }
}

# Function to generate summary report
function Get-SummaryReport {
    param(
        [array]$RbacReport,
        [array]$AccessLogs
    )
    
    $summary = [PSCustomObject]@{
        TotalRbacAssignments = $RbacReport.Count
        UniquePrincipals = ($RbacReport | Select-Object -ExpandProperty PrincipalId -Unique).Count
        TotalAccessEvents = $AccessLogs.Count
        FailedAccessAttempts = ($AccessLogs | Where-Object { $_.ResultType -eq "Failure" }).Count
        UniqueCallers = ($AccessLogs | Select-Object -ExpandProperty CallerIPAddress -Unique).Count
        MostAccessedSecrets = ($AccessLogs | Where-Object { $_.SecretName } | Group-Object SecretName | Sort-Object Count -Descending | Select-Object -First 10)
        MostAccessedKeys = ($AccessLogs | Where-Object { $_.KeyName } | Group-Object KeyName | Sort-Object Count -Descending | Select-Object -First 10)
    }
    
    return $summary
}

# Function to export reports
function Export-Reports {
    param(
        [string]$OutputPath,
        [array]$RbacReport,
        [array]$AccessLogs,
        [object]$Summary
    )
    
    # Create output directory if it doesn't exist
    if (-not (Test-Path $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    
    # Export RBAC report
    $rbacPath = Join-Path $OutputPath "rbac-audit-$timestamp.csv"
    $RbacReport | Export-Csv -Path $rbacPath -NoTypeInformation
    Write-ColorOutput "RBAC report exported to: $rbacPath" "Green"
    
    # Export access logs
    if ($AccessLogs.Count -gt 0) {
        $logsPath = Join-Path $OutputPath "access-logs-$timestamp.csv"
        $AccessLogs | Export-Csv -Path $logsPath -NoTypeInformation
        Write-ColorOutput "Access logs exported to: $logsPath" "Green"
    }
    
    # Export summary report
    $summaryPath = Join-Path $OutputPath "audit-summary-$timestamp.json"
    $Summary | ConvertTo-Json -Depth 3 | Out-File -FilePath $summaryPath
    Write-ColorOutput "Summary report exported to: $summaryPath" "Green"
    
    return @{
        RbacPath = $rbacPath
        LogsPath = $logsPath
        SummaryPath = $summaryPath
    }
}

# Main execution
try {
    Write-ColorOutput "Starting Azure Key Vault access audit..." "Cyan"
    
    # Check if user is logged in
    $context = Get-AzContext
    if (-not $context) {
        Write-ColorOutput "Please login to Azure first using Connect-AzAccount" "Red"
        exit 1
    }
    
    Write-ColorOutput "Logged in as: $($context.Account.Id)" "Green"
    
    # Get Key Vault resource ID
    $vaultResourceId = Get-KeyVaultResourceId -VaultName $VaultName -ResourceGroupName $ResourceGroupName
    Write-ColorOutput "Auditing Key Vault: $VaultName" "Yellow"
    
    # Audit RBAC assignments
    $rbacReport = Get-RbacAudit -VaultResourceId $vaultResourceId
    
    # Audit access logs
    $accessLogs = Get-AccessLogAudit -VaultName $VaultName -DaysToLookBack $DaysToLookBack
    
    # Generate summary report
    $summary = Get-SummaryReport -RbacReport $rbacReport -AccessLogs $accessLogs
    
    # Display summary
    Write-ColorOutput "`n=== AUDIT SUMMARY ===" "Cyan"
    Write-ColorOutput "Total RBAC Assignments: $($summary.TotalRbacAssignments)" "White"
    Write-ColorOutput "Unique Principals: $($summary.UniquePrincipals)" "White"
    Write-ColorOutput "Total Access Events: $($summary.TotalAccessEvents)" "White"
    Write-ColorOutput "Failed Access Attempts: $($summary.FailedAccessAttempts)" "White"
    Write-ColorOutput "Unique Callers: $($summary.UniqueCallers)" "White"
    
    if ($summary.MostAccessedSecrets) {
        Write-ColorOutput "`nMost Accessed Secrets:" "Yellow"
        $summary.MostAccessedSecrets | ForEach-Object {
            Write-ColorOutput "  $($_.Name): $($_.Count) accesses" "White"
        }
    }
    
    if ($summary.MostAccessedKeys) {
        Write-ColorOutput "`nMost Accessed Keys:" "Yellow"
        $summary.MostAccessedKeys | ForEach-Object {
            Write-ColorOutput "  $($_.Name): $($_.Count) accesses" "White"
        }
    }
    
    # Export reports
    $exportPaths = Export-Reports -OutputPath $OutputPath -RbacReport $rbacReport -AccessLogs $accessLogs -Summary $summary
    
    Write-ColorOutput "`nAudit completed successfully!" "Green"
    Write-ColorOutput "Reports saved to: $OutputPath" "Cyan"
    
} catch {
    Write-ColorOutput "Audit failed: $($_.Exception.Message)" "Red"
    exit 1
}
