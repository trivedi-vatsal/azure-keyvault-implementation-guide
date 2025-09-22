# Azure Key Vault Quick Start Guide

A streamlined guide for users to quickly start using an existing Azure Key Vault with Azure Key Vault Explorer.

## 🚀 Quick Setup (5 minutes)

### Step 1: Install Azure Key Vault Explorer

1. Go to [Microsoft Store](https://apps.microsoft.com/detail/9mz794c6t74m)
2. Install "Azure Key Vault Explorer"
3. Launch the application

### Step 2: Connect to Your Vault

1. **Sign in** with your company account
2. **Select your tenant** (company tenant)
3. **Search for your vault** (ask admin for vault name)
4. **Connect** to the vault

### Step 3: Start Using

- **Browse secrets** in the left panel
- **Click on a secret** to view details
- **Copy values** using the copy button
- **Search** using the search box

## 📱 Using Azure Key Vault Explorer

### Finding Secrets

1. **Browse by team**: Look for folders like `data/`, `web/`, `mobile/`
2. **Search**: Use the search box to find specific secrets
3. **Filter**: Use the filter options to narrow down results

### Working with Secrets

1. **View Secret**: Click on any secret to see its details
2. **Copy Value**: Click the copy button to copy the secret value
3. **View Properties**: See expiration date, tags, and other metadata

### Best Practices

- ✅ **Never share secrets** via email or chat
- ✅ **Use temporary storage** (password managers)
- ✅ **Clear clipboard** after use
- ✅ **Report issues** to IT support

## 🔐 Access Management

### Request Access

If you can't see secrets you need:

1. **Email IT Support**: `it-servicedesk@company.com`
2. **Include**:
   - Your name and team
   - Which secrets you need
   - Business justification
   - Manager approval

### Access Levels

- **Secrets User**: Can view and copy secrets
- **Secrets Officer**: Can create and manage secrets
- **Reader**: Can only see secret names (no values)

## 🆘 Troubleshooting

### "Access Denied" Error

- **Check with admin**: Verify you're in the correct security group
- **Wait**: Access changes can take up to 15 minutes
- **Try again**: Sign out and back in

### "Vault Not Found" Error

- **Check vault name**: Ask admin for correct vault name
- **Check tenant**: Make sure you're in the company tenant
- **Check network**: Ensure you're on corporate network

### "No Secrets Visible" Error

- **Check permissions**: You may not have access to any secrets
- **Request access**: Follow the access request process
- **Contact support**: Reach out to IT support

## 📋 Common Tasks

### Finding a Database Password

1. Look for `data/database/password/` secrets
2. Check the environment (prod/dev/staging)
3. Copy the value when needed

### Finding an API Key

1. Look for `web/api/` or `mobile/api/` secrets
2. Check the service name
3. Copy the key value

### Checking Secret Expiration

1. Click on the secret
2. Look at the "Expires" field
3. Request renewal if expiring soon
