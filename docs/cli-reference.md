# CLI Reference

## Vault Management

### Create Vault

```bash
az keyvault create \
  --name "{vault-name}" \
  --resource-group "{rg}" \
  --location "{location}" \
  --enable-purge-protection true \
  --retention-days 90 \
  --enable-rbac-authorization true \
  --sku standard
```

### Configure Private Endpoint

```bash
# Create private endpoint
az network private-endpoint create \
  --name "kv-pe-{vault-name}" \
  --resource-group "{rg}" \
  --vnet-name "{vnet}" \
  --subnet "{subnet}" \
  --private-connection-resource-id $(az keyvault show --name "{vault-name}" --query id -o tsv) \
  --group-id vault \
  --connection-name "kv-connection"
```

### List Vaults

```bash
# List all vaults in subscription
az keyvault list --output table

# List vaults in resource group
az keyvault list --resource-group "{rg}" --output table
```

### Get Vault Properties

```bash
# Get vault details
az keyvault show --name "{vault-name}" --resource-group "{rg}"

# Get vault URI
az keyvault show --name "{vault-name}" --query vaultUri --output tsv
```

## Secret Management

### Create Secret

```bash
az keyvault secret set \
  --vault-name "{vault-name}" \
  --name "{secret-name}" \
  --value "{secret-value}" \
  --expires "$(date -u -d '+180 days' +%Y-%m-%dT%H:%M:%SZ)" \
  --content-type "password" \
  --tags team="{team}" env="{env}" owner="{owner}" ticket="{ticket}"
```

### Update Secret

```bash
az keyvault secret set \
  --vault-name "{vault-name}" \
  --name "{secret-name}" \
  --value "{new-value}" \
  --tags team="{team}" env="{env}" owner="{owner}" ticket="{ticket}"
```

### Get Secret

```bash
# Get secret value
az keyvault secret show --vault-name "{vault-name}" --name "{secret-name}"

# Get secret value only
az keyvault secret show --vault-name "{vault-name}" --name "{secret-name}" --query value --output tsv
```

### List Secrets

```bash
# List all secrets
az keyvault secret list --vault-name "{vault-name}" --output table

# List secrets with specific tag
az keyvault secret list --vault-name "{vault-name}" --query "[?tags.team=='data']" --output table
```

### Delete Secret

```bash
# Delete secret
az keyvault secret delete --vault-name "{vault-name}" --name "{secret-name}"

# Purge deleted secret
az keyvault secret purge --vault-name "{vault-name}" --name "{secret-name}"
```

### Restore Secret

```bash
# Restore deleted secret
az keyvault secret restore --vault-name "{vault-name}" --name "{secret-name}"
```

## Key Management

### Create Key

```bash
az keyvault key create \
  --vault-name "{vault-name}" \
  --name "{key-name}" \
  --kty RSA \
  --size 3072 \
  --ops sign verify wrapKey unwrapKey \
  --tags team="{team}" env="{env}" owner="{owner}"
```

### Get Key

```bash
# Get key details
az keyvault key show --vault-name "{vault-name}" --name "{key-name}"

# Get public key
az keyvault key show --vault-name "{vault-name}" --name "{key-name}" --query key --output tsv
```

### List Keys

```bash
# List all keys
az keyvault key list --vault-name "{vault-name}" --output table

# List keys with specific tag
az keyvault key list --vault-name "{vault-name}" --query "[?tags.team=='data']" --output table
```

### Rotate Key

```bash
az keyvault key rotate \
  --vault-name "{vault-name}" \
  --name "{key-name}"
```

### Delete Key

```bash
# Delete key
az keyvault key delete --vault-name "{vault-name}" --name "{key-name}"

# Purge deleted key
az keyvault key purge --vault-name "{vault-name}" --name "{key-name}"
```

## Access Management

### Assign Role to Group

```bash
az role assignment create \
  --role "Key Vault Secrets User" \
  --assignee-object-id "{group-object-id}" \
  --scope $(az keyvault show --name "{vault-name}" --query id -o tsv)
```

### List Role Assignments

```bash
az role assignment list \
  --scope $(az keyvault show --name "{vault-name}" --query id -o tsv) \
  --output table
```

### Remove Role Assignment

```bash
az role assignment delete \
  --role "Key Vault Secrets User" \
  --assignee-object-id "{group-object-id}" \
  --scope $(az keyvault show --name "{vault-name}" --query id -o tsv)
```

## Monitoring and Diagnostics

### Configure Diagnostic Settings

```bash
# Create Log Analytics workspace
az monitor log-analytics workspace create \
  --resource-group "{rg}" \
  --workspace-name "kv-logs-{vault-name}"

# Configure diagnostic settings
az monitor diagnostic-settings create \
  --name "kv-diagnostics" \
  --resource "{vault-name}" \
  --resource-group "{rg}" \
  --workspace "kv-logs-{vault-name}" \
  --logs '[{"category": "AuditEvent", "enabled": true}]'
```

### Create Alert Rules

```bash
# Create action group
az monitor action-group create \
  --name "kv-alerts" \
  --resource-group "{rg}" \
  --short-name "kv-alerts"

# Create alert rule
az monitor metrics alert create \
  --name "kv-failed-auth" \
  --resource-group "{rg}" \
  --scopes "{vault-name}" \
  --condition "count 'Authentication' > 10" \
  --action "kv-alerts"
```

## Backup and Recovery

### Create Backup

```bash
az keyvault backup start \
  --vault-name "{vault-name}" \
  --blob-container-name "kv-backups" \
  --storage-account-name "stgkvbackups"
```

### Restore from Backup

```bash
az keyvault restore \
  --vault-name "{vault-name}" \
  --blob-container-name "kv-backups" \
  --storage-account-name "stgkvbackups" \
  --backup-folder "2024-01-15T10-30-00"
```

## Network Configuration

### Configure Firewall

```bash
# Add IP to firewall
az keyvault network-rule add \
  --name "{vault-name}" \
  --resource-group "{rg}" \
  --ip-address "192.168.1.0/24"

# Add subnet to firewall
az keyvault network-rule add \
  --name "{vault-name}" \
  --resource-group "{rg}" \
  --subnet "/subscriptions/{sub-id}/resourceGroups/{rg}/providers/Microsoft.Network/virtualNetworks/{vnet}/subnets/{subnet}"
```

### Configure Private Endpoint

```bash
# Create private DNS zone
az network private-dns zone create \
  --resource-group "{rg}" \
  --name "privatelink.vaultcore.azure.net"

# Link to VNet
az network private-dns zone link vnet create \
  --resource-group "{rg}" \
  --zone-name "privatelink.vaultcore.azure.net" \
  --name "kv-dns-link" \
  --virtual-network "{vnet}" \
  --registration-enabled false
```

## Troubleshooting Commands

### Check Vault Status

```bash
# Get vault properties
az keyvault show --name "{vault-name}" --resource-group "{rg}"

# List access policies
az keyvault show --name "{vault-name}" --query "properties.accessPolicies"

# Check diagnostic settings
az monitor diagnostic-settings list --resource "{vault-id}"
```

### Test Access

```bash
# Test secret access
az keyvault secret show --vault-name "{vault-name}" --name "{secret-name}"

# Test key access
az keyvault key show --vault-name "{vault-name}" --name "{key-name}"

# List secrets (if permitted)
az keyvault secret list --vault-name "{vault-name}"
```

### Check Network Connectivity

```bash
# Test DNS resolution
nslookup {vault-name}.vault.azure.net

# Test connectivity
telnet {vault-name}.vault.azure.net 443
```

## PowerShell Equivalents

### Vault Management

```powershell
# Create vault
New-AzKeyVault -VaultName "{vault-name}" -ResourceGroupName "{rg}" -Location "{location}"

# Get vault
Get-AzKeyVault -VaultName "{vault-name}" -ResourceGroupName "{rg}"

# List vaults
Get-AzKeyVault
```

### Secret Management

```powershell
# Set secret
Set-AzKeyVaultSecret -VaultName "{vault-name}" -Name "{secret-name}" -SecretValue (ConvertTo-SecureString "{value}" -AsPlainText -Force)

# Get secret
Get-AzKeyVaultSecret -VaultName "{vault-name}" -Name "{secret-name}"

# List secrets
Get-AzKeyVaultSecret -VaultName "{vault-name}"
```

### Access Management

```powershell
# Assign role
New-AzRoleAssignment -RoleDefinitionName "Key Vault Secrets User" -ObjectId "{object-id}" -Scope "{vault-id}"

# List role assignments
Get-AzRoleAssignment -Scope "{vault-id}"
```

## Common Scripts

### Bulk Secret Creation

```bash
#!/bin/bash
# Create multiple secrets from a file

VAULT_NAME="contoso-prod-secrets"
SECRETS_FILE="secrets.txt"

while IFS=',' read -r name value team env owner; do
  az keyvault secret set \
    --vault-name "$VAULT_NAME" \
    --name "$name" \
    --value "$value" \
    --tags team="$team" env="$env" owner="$owner"
done < "$SECRETS_FILE"
```

### Access Audit Script

```bash
#!/bin/bash
# Audit access to Key Vault

VAULT_NAME="contoso-prod-secrets"
VAULT_ID=$(az keyvault show --name "$VAULT_NAME" --query id -o tsv)

echo "Role Assignments:"
az role assignment list --scope "$VAULT_ID" --output table

echo "Recent Access Logs:"
az monitor activity-log list \
  --resource-id "$VAULT_ID" \
  --start-time "$(date -u -d '7 days ago' +%Y-%m-%dT%H:%M:%SZ)" \
  --output table
```

### Secret Expiration Check

```bash
#!/bin/bash
# Check for secrets expiring in the next 30 days

VAULT_NAME="contoso-prod-secrets"
EXPIRY_DATE=$(date -u -d '+30 days' +%Y-%m-%dT%H:%M:%SZ)

az keyvault secret list --vault-name "$VAULT_NAME" --query "[?attributes.expires < '$EXPIRY_DATE'].{Name:name, Expires:attributes.expires}" --output table
```
