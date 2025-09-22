# Azure Key Vault Quick Start Guide

This guide provides step-by-step instructions for quickly setting up Azure Key Vault in your organization.

## Prerequisites

- Azure subscription with appropriate permissions
- Azure CLI or PowerShell installed
- Access to Microsoft Entra ID (Azure AD) for group management

## Quick Setup (15 minutes)

### Step 1: Create Key Vault

#### Using Azure CLI

```bash
# Login to Azure
az login

# Create resource group
az group create --name "rg-keyvault-prod" --location "East US"

# Create Key Vault
az keyvault create \
  --name "contoso-prod-secrets" \
  --resource-group "rg-keyvault-prod" \
  --location "East US" \
  --enable-rbac-authorization true \
  --enable-purge-protection true \
  --retention-days 90 \
  --sku standard
```

#### Using PowerShell

```powershell
# Login to Azure
Connect-AzAccount

# Run the setup script
.\scripts\setup-keyvault.ps1 -VaultName "contoso-prod-secrets" -ResourceGroupName "rg-keyvault-prod" -Location "East US"
```

### Step 2: Create Security Groups

1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to **Microsoft Entra ID** > **Groups**
3. Create the following groups:
   - `GG-AKV-PROD-ADMINS-PLATFORM`
   - `GG-AKV-PROD-SECRETS-USERS-DATA`
   - `GG-AKV-PROD-SECRETS-OFFICERS-PLATFORM`

### Step 3: Assign RBAC Roles

```bash
# Get the vault resource ID
VAULT_ID=$(az keyvault show --name "contoso-prod-secrets" --resource-group "rg-keyvault-prod" --query id -o tsv)

# Get group object IDs (replace with actual IDs)
ADMIN_GROUP_ID="11111111-1111-1111-1111-111111111111"
SECRETS_USER_GROUP_ID="22222222-2222-2222-2222-222222222222"
SECRETS_OFFICER_GROUP_ID="33333333-3333-3333-3333-333333333333"

# Assign roles
az role assignment create --role "Key Vault Administrator" --assignee-object-id $ADMIN_GROUP_ID --scope $VAULT_ID
az role assignment create --role "Key Vault Secrets User" --assignee-object-id $SECRETS_USER_GROUP_ID --scope $VAULT_ID
az role assignment create --role "Key Vault Secrets Officer" --assignee-object-id $SECRETS_OFFICER_GROUP_ID --scope $VAULT_ID
```

### Step 4: Add Your First Secret

```bash
# Add a test secret
az keyvault secret set \
  --vault-name "contoso-prod-secrets" \
  --name "test/secret" \
  --value "MySecretValue123!" \
  --expires "2024-12-31T23:59:59Z" \
  --tags team="platform" env="prod" owner="admin@contoso.com"
```

### Step 5: Test Access

```bash
# Test secret retrieval
az keyvault secret show --vault-name "contoso-prod-secrets" --name "test/secret"
```

## Next Steps

1. **Configure Monitoring**: Set up diagnostic settings and alerts
2. **Set Up Private Endpoint**: For enhanced security
3. **Migrate Existing Secrets**: Use the bulk import scripts
4. **Train Users**: Share the user guides with your team
5. **Establish Processes**: Implement the access request workflow

## Common Commands

### List all secrets

```bash
az keyvault secret list --vault-name "contoso-prod-secrets"
```

### Create a new secret

```bash
az keyvault secret set \
  --vault-name "contoso-prod-secrets" \
  --name "team/system/purpose" \
  --value "secret-value" \
  --expires "2024-12-31T23:59:59Z" \
  --tags team="team-name" env="environment" owner="owner@company.com"
```

### Update a secret

```bash
az keyvault secret set \
  --vault-name "contoso-prod-secrets" \
  --name "team/system/purpose" \
  --value "new-secret-value"
```

### Delete a secret

```bash
az keyvault secret delete --vault-name "contoso-prod-secrets" --name "team/system/purpose"
```

### List role assignments

```bash
az role assignment list --scope $VAULT_ID --output table
```

## Troubleshooting

### Access Denied

- Verify you're in the correct security group
- Check RBAC role assignments
- Ensure your account has the necessary permissions

### Cannot Connect

- Check if you're on the corporate network (if using private endpoint)
- Verify DNS resolution
- Check firewall rules

### Secret Not Found

- Verify the secret name is correct
- Check if you have permission to access the secret
- Ensure the secret hasn't been deleted

## Getting Help

- **Documentation**: See the main README.md for detailed information
- **Scripts**: Use the provided PowerShell scripts for automation
- **Templates**: Use ARM templates for infrastructure as code
- **Support**: Contact your IT team or platform team for assistance

## Security Reminders

- Never share secrets via email or chat
- Use strong, unique passwords for all secrets
- Regularly rotate secrets according to your organization's policy
- Report any security incidents immediately
- Follow the principle of least privilege when assigning access
