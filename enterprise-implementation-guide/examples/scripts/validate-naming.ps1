# Validate Naming Conventions
# This script validates secret and key names against naming conventions

param(
    [Parameter(Mandatory=$true)]
    [string]$VaultName,
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$false)]
    [switch]$FixNames
)

# Function to write colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to validate secret name
function Test-SecretName {
    param([string]$Name)
    
    $pattern = '^[a-z]+/[a-z-]+/[a-z-]+(/[a-z]+)?$'
    return $Name -match $pattern
}

# Function to validate key name
function Test-KeyName {
    param([string]$Name)
    
    $pattern = '^keys/[a-z]+/[a-z-]+/[a-z-]+(/[a-z]+)?$'
    return $Name -match $pattern
}

# Function to suggest new name
function Get-SuggestedName {
    param([string]$Name, [string]$Type)
    
    $suggestions = @()
    
    # Convert to lowercase
    $lowerName = $Name.ToLower()
    $suggestions += $lowerName
    
    # Replace underscores with forward slashes
    $slashName = $lowerName -replace '_', '/'
    $suggestions += $slashName
    
    # Replace hyphens with forward slashes
    $hyphenName = $lowerName -replace '-', '/'
    $suggestions += $hyphenName
    
    # Add keys/ prefix for keys
    if ($Type -eq "key" -and -not $lowerName.StartsWith("keys/")) {
        $keyName = "keys/" + $lowerName
        $suggestions += $keyName
    }
    
    # Remove keys/ prefix for secrets
    if ($Type -eq "secret" -and $lowerName.StartsWith("keys/")) {
        $secretName = $lowerName -replace '^keys/', ''
        $suggestions += $secretName
    }
    
    return $suggestions | Select-Object -Unique
}

# Function to validate secrets
function Test-Secrets {
    param([string]$VaultName)
    
    Write-ColorOutput "Validating secrets..." "Yellow"
    
    try {
        $secrets = Get-AzKeyVaultSecret -VaultName $VaultName
        $invalidSecrets = @()
        
        foreach ($secret in $secrets) {
            if (-not (Test-SecretName -Name $secret.Name)) {
                $invalidSecrets += [PSCustomObject]@{
                    Name = $secret.Name
                    Type = "Secret"
                    Suggestions = Get-SuggestedName -Name $secret.Name -Type "secret"
                }
            }
        }
        
        return $invalidSecrets
    }
    catch {
        Write-ColorOutput "Error retrieving secrets: $($_.Exception.Message)" "Red"
        return @()
    }
}

# Function to validate keys
function Test-Keys {
    param([string]$VaultName)
    
    Write-ColorOutput "Validating keys..." "Yellow"
    
    try {
        $keys = Get-AzKeyVaultKey -VaultName $VaultName
        $invalidKeys = @()
        
        foreach ($key in $keys) {
            if (-not (Test-KeyName -Name $key.Name)) {
                $invalidKeys += [PSCustomObject]@{
                    Name = $key.Name
                    Type = "Key"
                    Suggestions = Get-SuggestedName -Name $key.Name -Type "key"
                }
            }
        }
        
        return $invalidKeys
    }
    catch {
        Write-ColorOutput "Error retrieving keys: $($_.Exception.Message)" "Red"
        return @()
    }
}

# Function to fix secret name
function Fix-SecretName {
    param([string]$VaultName, [string]$OldName, [string]$NewName)
    
    try {
        # Get the secret
        $secret = Get-AzKeyVaultSecret -VaultName $VaultName -Name $OldName
        
        # Create new secret with correct name
        Set-AzKeyVaultSecret -VaultName $VaultName -Name $NewName -SecretValue $secret.SecretValue -Tags $secret.Tags
        
        # Delete old secret
        Remove-AzKeyVaultSecret -VaultName $VaultName -Name $OldName -Force
        
        return $true
    }
    catch {
        Write-ColorOutput "Error fixing secret '$OldName': $($_.Exception.Message)" "Red"
        return $false
    }
}

# Function to fix key name
function Fix-KeyName {
    param([string]$VaultName, [string]$OldName, [string]$NewName)
    
    try {
        # Get the key
        $key = Get-AzKeyVaultKey -VaultName $VaultName -Name $OldName
        
        # Create new key with correct name
        Add-AzKeyVaultKey -VaultName $VaultName -Name $NewName -KeyType $key.KeyType -KeySize $key.KeySize -KeyOps $key.KeyOps -Tags $key.Tags
        
        # Delete old key
        Remove-AzKeyVaultKey -VaultName $VaultName -Name $OldName -Force
        
        return $true
    }
    catch {
        Write-ColorOutput "Error fixing key '$OldName': $($_.Exception.Message)" "Red"
        return $false
    }
}

# Main execution
try {
    Write-ColorOutput "Starting naming convention validation..." "Cyan"
    
    # Check if user is logged in
    $context = Get-AzContext
    if (-not $context) {
        Write-ColorOutput "Please login to Azure first using Connect-AzAccount" "Red"
        exit 1
    }
    
    Write-ColorOutput "Logged in as: $($context.Account.Id)" "Green"
    Write-ColorOutput "Validating vault: $VaultName" "Yellow"
    
    # Validate secrets
    $invalidSecrets = Test-Secrets -VaultName $VaultName
    
    # Validate keys
    $invalidKeys = Test-Keys -VaultName $VaultName
    
    # Combine results
    $invalidItems = $invalidSecrets + $invalidKeys
    
    # Display results
    if ($invalidItems.Count -eq 0) {
        Write-ColorOutput "`nAll names follow the naming convention!" "Green"
    } else {
        Write-ColorOutput "`nFound $($invalidItems.Count) items with invalid names:" "Red"
        
        foreach ($item in $invalidItems) {
            Write-ColorOutput "`n$($item.Type): $($item.Name)" "Yellow"
            Write-ColorOutput "Suggestions:" "Cyan"
            foreach ($suggestion in $item.Suggestions) {
                Write-ColorOutput "  - $suggestion" "White"
            }
        }
        
        # Fix names if requested
        if ($FixNames) {
            Write-ColorOutput "`nFixing names..." "Yellow"
            
            foreach ($item in $invalidItems) {
                $newName = $item.Suggestions[0]
                Write-ColorOutput "Renaming '$($item.Name)' to '$newName'..." "Yellow"
                
                if ($item.Type -eq "Secret") {
                    if (Fix-SecretName -VaultName $VaultName -OldName $item.Name -NewName $newName) {
                        Write-ColorOutput "Successfully renamed secret" "Green"
                    }
                } elseif ($item.Type -eq "Key") {
                    if (Fix-KeyName -VaultName $VaultName -OldName $item.Name -NewName $newName) {
                        Write-ColorOutput "Successfully renamed key" "Green"
                    }
                }
            }
        } else {
            Write-ColorOutput "`nTo fix names automatically, run with -FixNames parameter" "Yellow"
        }
    }
    
} catch {
    Write-ColorOutput "Validation failed: $($_.Exception.Message)" "Red"
    exit 1
}
