# Import Secrets from CSV
# This script imports secrets from a CSV file into Azure Key Vault

param(
    [Parameter(Mandatory=$true)]
    [string]$CsvPath,
    
    [Parameter(Mandatory=$false)]
    [string]$VaultName,
    
    [Parameter(Mandatory=$false)]
    [switch]$WhatIf
)

# Function to write colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to validate CSV format
function Test-CsvFormat {
    param([string]$CsvPath)
    
    try {
        $csv = Import-Csv -Path $CsvPath
        $requiredColumns = @('VaultName', 'Name', 'Value', 'Team', 'Environment', 'Owner')
        
        foreach ($column in $requiredColumns) {
            if (-not ($csv[0].PSObject.Properties.Name -contains $column)) {
                Write-ColorOutput "Error: Missing required column: $column" "Red"
                return $false
            }
        }
        
        return $true
    }
    catch {
        Write-ColorOutput "Error: Could not read CSV file: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Function to validate secret name
function Test-SecretName {
    param([string]$Name)
    
    $pattern = '^[a-z]+/[a-z-]+/[a-z-]+(/[a-z]+)?$'
    return $Name -match $pattern
}

# Function to validate email
function Test-Email {
    param([string]$Email)
    
    $pattern = '^[^@]+@[^@]+\.[^@]+$'
    return $Email -match $pattern
}

# Function to create secret
function New-Secret {
    param(
        [string]$VaultName,
        [string]$Name,
        [string]$Value,
        [hashtable]$Tags
    )
    
    try {
        if ($WhatIf) {
            Write-ColorOutput "WhatIf: Would create secret '$Name' in vault '$VaultName'" "Yellow"
            return $true
        }
        
        $secureValue = ConvertTo-SecureString $Value -AsPlainText -Force
        Set-AzKeyVaultSecret -VaultName $VaultName -Name $Name -SecretValue $secureValue -Tags $Tags
        return $true
    }
    catch {
        Write-ColorOutput "Error creating secret '$Name': $($_.Exception.Message)" "Red"
        return $false
    }
}

# Main execution
try {
    Write-ColorOutput "Starting secret import process..." "Cyan"
    
    # Check if user is logged in
    $context = Get-AzContext
    if (-not $context) {
        Write-ColorOutput "Please login to Azure first using Connect-AzAccount" "Red"
        exit 1
    }
    
    Write-ColorOutput "Logged in as: $($context.Account.Id)" "Green"
    
    # Validate CSV format
    if (-not (Test-CsvFormat -CsvPath $CsvPath)) {
        exit 1
    }
    
    # Import CSV
    $secrets = Import-Csv -Path $CsvPath
    Write-ColorOutput "Found $($secrets.Count) secrets to import" "Green"
    
    # Process each secret
    $successCount = 0
    $errorCount = 0
    
    foreach ($secret in $secrets) {
        Write-ColorOutput "Processing secret: $($secret.Name)" "Yellow"
        
        # Validate secret name
        if (-not (Test-SecretName -Name $secret.Name)) {
            Write-ColorOutput "Warning: Secret name '$($secret.Name)' does not follow naming convention" "Yellow"
        }
        
        # Validate owner email
        if (-not (Test-Email -Email $secret.Owner)) {
            Write-ColorOutput "Warning: Invalid owner email '$($secret.Owner)'" "Yellow"
        }
        
        # Determine vault name
        $vaultName = if ($VaultName) { $VaultName } else { $secret.VaultName }
        
        # Create tags
        $tags = @{
            team = $secret.Team
            environment = $secret.Environment
            owner = $secret.Owner
        }
        
        # Add optional tags
        if ($secret.Project) { $tags.project = $secret.Project }
        if ($secret.Description) { $tags.description = $secret.Description }
        if ($secret.Ticket) { $tags.ticket = $secret.Ticket }
        if ($secret.PII) { $tags.pii = $secret.PII }
        if ($secret.DecommissionDate) { $tags.decommission_date = $secret.DecommissionDate }
        
        # Create secret
        if (New-Secret -VaultName $vaultName -Name $secret.Name -Value $secret.Value -Tags $tags) {
            $successCount++
            Write-ColorOutput "Successfully created secret: $($secret.Name)" "Green"
        } else {
            $errorCount++
        }
    }
    
    # Summary
    Write-ColorOutput "`nImport Summary:" "Cyan"
    Write-ColorOutput "Successfully imported: $successCount" "Green"
    Write-ColorOutput "Errors: $errorCount" "Red"
    
    if ($WhatIf) {
        Write-ColorOutput "`nNote: This was a WhatIf run. No secrets were actually created." "Yellow"
    }
    
} catch {
    Write-ColorOutput "Import failed: $($_.Exception.Message)" "Red"
    exit 1
}
