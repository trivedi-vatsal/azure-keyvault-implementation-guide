# Azure Key Vault Explorer User Guide

Complete guide for using Azure Key Vault Explorer to access and manage secrets.

## 📱 Getting Started

### First Time Setup
1. **Download & Install**
   - Go to Microsoft Store
   - Search "Azure Key Vault Explorer"
   - Install and launch

2. **Sign In**
   - Use your company email address
   - Complete MFA if prompted
   - Select your company tenant

3. **Connect to Vault**
   - Search for your vault name
   - Click "Connect"
   - Wait for connection confirmation

## 🔍 Finding Secrets

### Browse by Category
- **Data Team**: `data/` folder
- **Web Team**: `web/` folder  
- **Mobile Team**: `mobile/` folder
- **Infrastructure**: `infra/` folder

### Search Secrets
1. **Use Search Box**: Type part of secret name
2. **Filter Results**: Use filter options
3. **Sort Results**: Click column headers

### Secret Naming Pattern
```
{team}/{system}/{purpose}/{environment}
```
**Examples:**
- `data/etl/database/password/prod`
- `web/api/external-service/key/dev`
- `mobile/app/push-notification/cert/prod`

## 🔐 Working with Secrets

### Viewing Secrets
1. **Click on Secret**: Opens details panel
2. **View Properties**: See expiration, tags, etc.
3. **Copy Value**: Click copy button
4. **Close Panel**: Click X or press Escape

### Copying Secret Values
1. **Click Copy Button**: Copies to clipboard
2. **Paste Where Needed**: Use Ctrl+V
3. **Clear Clipboard**: Restart app or clear manually

### Understanding Secret Properties
- **Name**: Full secret name
- **Value**: The actual secret (click to reveal)
- **Expires**: When secret expires
- **Created**: When secret was created
- **Tags**: Additional metadata

## 🏷️ Understanding Tags

### Common Tags
- **team**: Which team owns the secret
- **environment**: prod/dev/staging
- **owner**: Person responsible
- **project**: Associated project
- **pii**: Contains personal data (yes/no)

### Using Tags
- **Filter by Team**: Look for your team tag
- **Filter by Environment**: Find prod vs dev secrets
- **Find Owner**: Contact person for questions

## 🔄 Common Workflows

### Daily Workflow
1. **Open App**: Launch Azure Key Vault Explorer
2. **Connect**: Sign in and connect to vault
3. **Find Secret**: Browse or search for needed secret
4. **Copy Value**: Copy secret to clipboard
5. **Use in Application**: Paste where needed
6. **Close App**: Sign out when done

### Finding Database Credentials
1. **Look for**: `data/database/password/` secrets
2. **Check Environment**: prod/dev/staging
3. **Copy Password**: Use copy button
4. **Use in App**: Paste in connection string

### Finding API Keys
1. **Look for**: `web/api/` or `mobile/api/` secrets
2. **Check Service**: External service name
3. **Copy Key**: Use copy button
4. **Configure App**: Add to API configuration

### Checking Expiration
1. **Click Secret**: Open details
2. **Check Expires Field**: Look at date
3. **Request Renewal**: If expiring soon
4. **Contact Owner**: Use owner tag

## ⚠️ Security Guidelines

### Do's
- ✅ **Use only when needed**
- ✅ **Copy to secure password manager**
- ✅ **Clear clipboard after use**
- ✅ **Report suspicious activity**
- ✅ **Follow company policies**

### Don'ts
- ❌ **Don't share via email/chat**
- ❌ **Don't save in plain text files**
- ❌ **Don't screenshot secret values**
- ❌ **Don't ignore expiration warnings**
- ❌ **Don't bypass security controls**

## 🆘 Troubleshooting

### App Won't Start
1. **Check Internet**: Ensure you're connected
2. **Restart App**: Close and reopen
3. **Update App**: Check for updates
4. **Contact Support**: If still not working

### Can't Sign In
1. **Check Credentials**: Verify email/password
2. **Check MFA**: Complete multi-factor auth
3. **Check Tenant**: Select correct company tenant
4. **Contact IT**: If still having issues

### Can't Find Vault
1. **Check Vault Name**: Ask admin for correct name
2. **Check Permissions**: Verify you have access
3. **Check Network**: Ensure corporate network
4. **Contact Support**: For assistance

### Can't See Secrets
1. **Check Access Level**: You may need higher permissions
2. **Request Access**: Follow access request process
3. **Wait for Approval**: Can take up to 24 hours
4. **Contact Admin**: For urgent requests

### Copy Not Working
1. **Check Clipboard**: Try copying something else
2. **Restart App**: Close and reopen
3. **Check Permissions**: App may need clipboard access
4. **Use Alternative**: Try right-click copy

## 📞 Getting Help

### Self-Service
- **Check this guide**: Most issues covered here
- **Try troubleshooting**: Follow steps above
- **Ask colleagues**: Other team members may know

### IT Support
- **Email**: it-servicedesk@company.com
- **Phone**: +1-XXX-XXX-XXXX
- **Include**: Error message, steps taken, vault name

### Emergency
- **Critical Issues**: Call emergency number
- **Security Concerns**: Contact security team
- **After Hours**: Use emergency contact

## 📋 Quick Reference

### Keyboard Shortcuts
- **Ctrl+F**: Search secrets
- **Ctrl+C**: Copy selected secret
- **Escape**: Close details panel
- **F5**: Refresh vault

### Common Secret Types
- **Passwords**: Database, service account passwords
- **API Keys**: External service authentication
- **Certificates**: SSL, code signing certificates
- **Connection Strings**: Database connection strings
- **Tokens**: Access tokens, refresh tokens

### Environment Codes
- **prod**: Production environment
- **dev**: Development environment
- **staging**: Staging environment
- **test**: Testing environment

---

*Need more help? Contact IT Support or check the main implementation guide for administrators.*
