# Azure Key Vault Setup Script
# This script creates a Key Vault with proper RBAC configuration

param(
    [Parameter(Mandatory=$true)]
    [string]$VaultName,
    
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$Location,
    
    [Parameter(Mandatory=$false)]
    [string]$TenantId = (Get-AzContext).Tenant.Id,
    
    [Parameter(Mandatory=$false)]
    [string]$SkuName = "standard",
    
    [Parameter(Mandatory=$false)]
    [int]$SoftDeleteRetentionDays = 90,
    
    [Parameter(Mandatory=$false)]
    [bool]$EnablePurgeProtection = $true,
    
    [Parameter(Mandatory=$false)]
    [bool]$EnableRbacAuthorization = $true
)

# Function to write colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to check if resource group exists
function Test-ResourceGroup {
    param([string]$ResourceGroupName)
    
    try {
        Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

# Function to create resource group if it doesn't exist
function New-ResourceGroupIfNotExists {
    param(
        [string]$ResourceGroupName,
        [string]$Location
    )
    
    if (-not (Test-ResourceGroup -ResourceGroupName $ResourceGroupName)) {
        Write-ColorOutput "Creating resource group: $ResourceGroupName" "Yellow"
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location
    } else {
        Write-ColorOutput "Resource group already exists: $ResourceGroupName" "Green"
    }
}

# Function to create Key Vault
function New-KeyVault {
    param(
        [string]$VaultName,
        [string]$ResourceGroupName,
        [string]$Location,
        [string]$TenantId,
        [string]$SkuName,
        [int]$SoftDeleteRetentionDays,
        [bool]$EnablePurgeProtection,
        [bool]$EnableRbacAuthorization
    )
    
    Write-ColorOutput "Creating Key Vault: $VaultName" "Yellow"
    
    $vaultParams = @{
        VaultName = $VaultName
        ResourceGroupName = $ResourceGroupName
        Location = $Location
        TenantId = $TenantId
        Sku = $SkuName
        SoftDeleteRetentionInDays = $SoftDeleteRetentionDays
        EnablePurgeProtection = $EnablePurgeProtection
        EnableRbacAuthorization = $EnableRbacAuthorization
    }
    
    try {
        $vault = New-AzKeyVault @vaultParams
        Write-ColorOutput "Key Vault created successfully: $($vault.VaultUri)" "Green"
        return $vault
    }
    catch {
        Write-ColorOutput "Error creating Key Vault: $($_.Exception.Message)" "Red"
        throw
    }
}

# Function to configure diagnostic settings
function Set-DiagnosticSettings {
    param(
        [string]$VaultName,
        [string]$ResourceGroupName
    )
    
    Write-ColorOutput "Configuring diagnostic settings for Key Vault" "Yellow"
    
    # Get the Key Vault resource ID
    $vaultId = (Get-AzKeyVault -VaultName $VaultName -ResourceGroupName $ResourceGroupName).ResourceId
    
    # Create or get Log Analytics workspace
    $workspaceName = "kv-logs-$VaultName"
    $workspace = Get-AzOperationalInsightsWorkspace -Name $workspaceName -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue
    
    if (-not $workspace) {
        Write-ColorOutput "Creating Log Analytics workspace: $workspaceName" "Yellow"
        $workspace = New-AzOperationalInsightsWorkspace -Name $workspaceName -ResourceGroupName $ResourceGroupName -Location $Location
    }
    
    # Configure diagnostic settings
    $diagnosticSettings = @{
        ResourceId = $vaultId
        Name = "KeyVaultDiagnostics"
        WorkspaceId = $workspace.ResourceId
        Enabled = $true
    }
    
    Set-AzDiagnosticSetting @diagnosticSettings
    Write-ColorOutput "Diagnostic settings configured successfully" "Green"
}

# Main execution
try {
    Write-ColorOutput "Starting Azure Key Vault setup..." "Cyan"
    
    # Check if user is logged in
    $context = Get-AzContext
    if (-not $context) {
        Write-ColorOutput "Please login to Azure first using Connect-AzAccount" "Red"
        exit 1
    }
    
    Write-ColorOutput "Logged in as: $($context.Account.Id)" "Green"
    
    # Create resource group if it doesn't exist
    New-ResourceGroupIfNotExists -ResourceGroupName $ResourceGroupName -Location $Location
    
    # Create Key Vault
    $vault = New-KeyVault -VaultName $VaultName -ResourceGroupName $ResourceGroupName -Location $Location -TenantId $TenantId -SkuName $SkuName -SoftDeleteRetentionDays $SoftDeleteRetentionDays -EnablePurgeProtection $EnablePurgeProtection -EnableRbacAuthorization $EnableRbacAuthorization
    
    # Configure diagnostic settings
    Set-DiagnosticSettings -VaultName $VaultName -ResourceGroupName $ResourceGroupName
    
    Write-ColorOutput "Azure Key Vault setup completed successfully!" "Green"
    Write-ColorOutput "Vault URI: $($vault.VaultUri)" "Cyan"
    Write-ColorOutput "Next steps:" "Yellow"
    Write-ColorOutput "1. Configure private endpoint (if required)" "White"
    Write-ColorOutput "2. Set up RBAC groups and role assignments" "White"
    Write-ColorOutput "3. Configure firewall rules" "White"
    Write-ColorOutput "4. Migrate existing secrets" "White"
    
} catch {
    Write-ColorOutput "Setup failed: $($_.Exception.Message)" "Red"
    exit 1
}
