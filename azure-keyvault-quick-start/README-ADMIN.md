# Admin Quick Setup

Streamlined setup guide for IT administrators to prepare Azure Key Vault for user access.

## 🎯 Prerequisites

- ✅ Azure Key Vault already exists
- ✅ Admin has Owner/Contributor access
- ✅ Entra ID access for group management
- ✅ Users have company email accounts

## ⚡ Quick Setup (15 minutes)

### Step 1: Create Security Groups
1. **Go to Azure Portal** → Entra ID → Groups
2. **Create these groups:**
   - `GG-AKV-SECRETS-USERS` (for regular users)
   - `GG-AKV-SECRETS-OFFICERS` (for team leads)
   - `GG-AKV-ADMINS` (for platform team)

### Step 2: Assign RBAC Roles
1. **Go to Key Vault** → Access Control (IAM)
2. **Add role assignments:**
   - `Key Vault Secrets User` → `GG-AKV-SECRETS-USERS`
   - `Key Vault Secrets Officer` → `GG-AKV-SECRETS-OFFICERS`
   - `Key Vault Administrator` → `GG-AKV-ADMINS`

### Step 3: Configure Network Access
1. **Go to Key Vault** → Networking
2. **Set access to:** Selected networks
3. **Add your corporate IP ranges**
4. **Enable private endpoint** (if needed)

### Step 4: Set Up Monitoring
1. **Go to Key Vault** → Monitoring → Diagnostic settings
2. **Create diagnostic setting:**
   - Send to Log Analytics workspace
   - Enable all logs
   - Set retention to 90 days

## 👥 User Onboarding

### Add Users to Groups
1. **Go to each security group**
2. **Add members** (users who need access)
3. **Verify membership** is correct

### Send Welcome Email
**Template:**
```
Subject: Azure Key Vault Access Granted

Dear [User Name],

You now have access to Azure Key Vault. Here's how to get started:

1. Install Azure Key Vault Explorer from Microsoft Store
2. Sign in with your company account
3. Connect to vault: [Vault Name]
4. Start accessing your team's secrets

Quick Start Guide: [Link to guide]
User Guide: [Link to user guide]

Need help? Contact IT Service Desk.

Best regards,
IT Team
```

## 🔧 Common Admin Tasks

### Adding New Users
1. **Add user to appropriate group**
2. **Send welcome email**
3. **Verify access works**

### Removing Access
1. **Remove user from all groups**
2. **Verify access is revoked**
3. **Update documentation**

### Managing Secrets
1. **Create secrets** with proper naming
2. **Add appropriate tags**
3. **Set expiration dates**
4. **Assign to correct teams**

## 📋 Secret Naming Standards

### Format
```
{team}/{system}/{purpose}/{environment}
```

### Examples
- `data/database/password/prod`
- `web/api/external-service/key/dev`
- `mobile/app/push-notification/cert/prod`

### Required Tags
- `team`: Team name
- `environment`: prod/dev/staging
- `owner`: UPN of responsible person
- `pii`: yes/no

## 🚨 Troubleshooting

### User Can't Access Vault
1. **Check group membership**
2. **Verify RBAC assignment**
3. **Check network access**
4. **Test with admin account**

### User Can't See Secrets
1. **Check user's role level**
2. **Verify secret permissions**
3. **Check secret naming**
4. **Review access logs**

### Performance Issues
1. **Check vault SKU**
2. **Review request limits**
3. **Monitor usage patterns**
4. **Consider caching**

## 📊 Monitoring

### Key Metrics to Watch
- **Failed authentications**
- **Access patterns**
- **Secret usage**
- **Error rates**

### Alerts to Set Up
- **Multiple failed logins**
- **Unusual access patterns**
- **High error rates**
- **Secret expiration warnings**

## 📞 Support Contacts

- **Platform Team**: platform-team@company.com
- **Security Team**: security-team@company.com
- **Service Desk**: it-servicedesk@company.com

## 🔄 Maintenance

### Weekly Tasks
- **Review access logs**
- **Check for expiring secrets**
- **Update user groups**
- **Monitor performance**

### Monthly Tasks
- **Audit access assignments**
- **Review secret inventory**
- **Update documentation**
- **Security review**

---

*For advanced configuration, see the main implementation guide.*
