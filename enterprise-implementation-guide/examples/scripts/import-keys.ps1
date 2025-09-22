# Import Keys from CSV
# This script imports keys from a CSV file into Azure Key Vault

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
        $requiredColumns = @('VaultName', 'Name', 'KeyType', 'KeySize', 'Operations', 'Team', 'Environment', 'Owner')
        
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

# Function to validate key name
function Test-KeyName {
    param([string]$Name)
    
    $pattern = '^keys/[a-z]+/[a-z-]+/[a-z-]+(/[a-z]+)?$'
    return $Name -match $pattern
}

# Function to validate email
function Test-Email {
    param([string]$Email)
    
    $pattern = '^[^@]+@[^@]+\.[^@]+$'
    return $Email -match $pattern
}

# Function to create key
function New-Key {
    param(
        [string]$VaultName,
        [string]$Name,
        [string]$KeyType,
        [int]$KeySize,
        [string]$Operations,
        [hashtable]$Tags
    )
    
    try {
        if ($WhatIf) {
            Write-ColorOutput "WhatIf: Would create key '$Name' in vault '$VaultName'" "Yellow"
            return $true
        }
        
        # Parse operations
        $ops = $Operations -split ',' | ForEach-Object { $_.Trim() }
        
        # Create key
        $key = Add-AzKeyVaultKey -VaultName $VaultName -Name $Name -KeyType $KeyType -KeySize $KeySize -KeyOps $ops -Tags $Tags
        return $true
    }
    catch {
        Write-ColorOutput "Error creating key '$Name': $($_.Exception.Message)" "Red"
        return $false
    }
}

# Main execution
try {
    Write-ColorOutput "Starting key import process..." "Cyan"
    
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
    $keys = Import-Csv -Path $CsvPath
    Write-ColorOutput "Found $($keys.Count) keys to import" "Green"
    
    # Process each key
    $successCount = 0
    $errorCount = 0
    
    foreach ($key in $keys) {
        Write-ColorOutput "Processing key: $($key.Name)" "Yellow"
        
        # Validate key name
        if (-not (Test-KeyName -Name $key.Name)) {
            Write-ColorOutput "Warning: Key name '$($key.Name)' does not follow naming convention" "Yellow"
        }
        
        # Validate owner email
        if (-not (Test-Email -Email $key.Owner)) {
            Write-ColorOutput "Warning: Invalid owner email '$($key.Owner)'" "Yellow"
        }
        
        # Determine vault name
        $vaultName = if ($VaultName) { $VaultName } else { $key.VaultName }
        
        # Create tags
        $tags = @{
            team = $key.Team
            environment = $key.Environment
            owner = $key.Owner
        }
        
        # Add optional tags
        if ($key.Project) { $tags.project = $key.Project }
        if ($key.Description) { $tags.description = $key.Description }
        if ($key.Ticket) { $tags.ticket = $key.Ticket }
        if ($key.PII) { $tags.pii = $key.PII }
        if ($key.DecommissionDate) { $tags.decommission_date = $key.DecommissionDate }
        
        # Create key
        if (New-Key -VaultName $vaultName -Name $key.Name -KeyType $key.KeyType -KeySize $key.KeySize -Operations $key.Operations -Tags $tags) {
            $successCount++
            Write-ColorOutput "Successfully created key: $($key.Name)" "Green"
        } else {
            $errorCount++
        }
    }
    
    # Summary
    Write-ColorOutput "`nImport Summary:" "Cyan"
    Write-ColorOutput "Successfully imported: $successCount" "Green"
    Write-ColorOutput "Errors: $errorCount" "Red"
    
    if ($WhatIf) {
        Write-ColorOutput "`nNote: This was a WhatIf run. No keys were actually created." "Yellow"
    }
    
} catch {
    Write-ColorOutput "Import failed: $($_.Exception.Message)" "Red"
    exit 1
}
