# Quick Reference

Essential information for using Azure Key Vault Explorer.

## 🚀 Getting Started

### Install App
1. Microsoft Store → Search "Azure Key Vault Explorer"
2. Install and launch
3. Sign in with company account
4. Select company tenant
5. Connect to vault

### Connect to Vault
1. **Search** for vault name
2. **Click** "Connect"
3. **Wait** for connection confirmation
4. **Start** browsing secrets

## 🔍 Finding Secrets

### Browse by Team
- **Data Team**: `data/` folder
- **Web Team**: `web/` folder
- **Mobile Team**: `mobile/` folder
- **Infrastructure**: `infra/` folder

### Search Secrets
- **Search box**: Type part of secret name
- **Filter**: Use filter options
- **Sort**: Click column headers

### Secret Naming
```
{team}/{system}/{purpose}/{environment}
```
**Examples:**
- `data/etl/database/password/prod`
- `web/api/external-service/key/dev`
- `mobile/app/push-notification/cert/prod`

## 🔐 Working with Secrets

### View Secret
1. **Click** on secret name
2. **View** details in right panel
3. **Copy** value using copy button
4. **Close** panel when done

### Copy Value
1. **Click** copy button
2. **Paste** where needed (Ctrl+V)
3. **Clear** clipboard after use

### Check Expiration
1. **Click** on secret
2. **Look** at "Expires" field
3. **Request** renewal if needed

## 🏷️ Understanding Tags

### Common Tags
- **team**: Team that owns secret
- **environment**: prod/dev/staging
- **owner**: Person responsible
- **project**: Associated project
- **pii**: Contains personal data

### Using Tags
- **Filter by team**: Find your team's secrets
- **Filter by environment**: Separate prod/dev
- **Find owner**: Contact person for questions

## ⚠️ Security Rules

### Do's
- ✅ Use only when needed
- ✅ Copy to secure password manager
- ✅ Clear clipboard after use
- ✅ Report suspicious activity
- ✅ Follow company policies

### Don'ts
- ❌ Don't share via email/chat
- ❌ Don't save in plain text files
- ❌ Don't screenshot secret values
- ❌ Don't ignore expiration warnings
- ❌ Don't bypass security controls

## 🆘 Common Issues

### Access Denied
- Check with admin
- Wait 15 minutes
- Sign out and back in
- Verify vault name

### Vault Not Found
- Check vault name
- Check tenant
- Check network
- Try Azure Portal

### No Secrets Visible
- Check permissions
- Request access
- Wait for approval
- Contact support

### Copy Not Working
- Check clipboard
- Restart app
- Check permissions
- Use right-click

## 📞 Support

### IT Service Desk
- **Email**: it-servicedesk@company.com
- **Response**: 1-2 business days
- **For**: General issues, access requests

### Platform Team
- **Email**: platform-team@company.com
- **Response**: 4-8 hours
- **For**: Technical issues, vault problems

### Emergency
- **Phone**: +1-XXX-XXX-XXXX
- **Response**: 1-2 hours
- **For**: Critical business impact

## 📋 Access Request

### Email Template
```
To: it-servicedesk@company.com
Subject: Key Vault Access Request - [Your Name] - [Team]

Dear IT Service Desk,

I am requesting access to Azure Key Vault secrets for my work.

Request Details:
- Name: [Your Full Name]
- Team: [Your Team/Department]
- Manager: [Your Manager's Name]
- Secrets Needed: [List specific secrets]
- Business Justification: [Why you need access]
- Duration: [Permanent/Temporary]

I understand that all access is logged and monitored.

Manager Approval: [Your Manager] has approved this request.

Best regards,
[Your Name]
```

## ⌨️ Keyboard Shortcuts

- **Ctrl+F**: Search secrets
- **Ctrl+C**: Copy selected secret
- **Escape**: Close details panel
- **F5**: Refresh vault

## 🔄 Common Workflows

### Daily Workflow
1. Open app
2. Connect to vault
3. Find needed secret
4. Copy value
5. Use in application
6. Close app

### Database Access
1. Look for `data/database/password/` secrets
2. Check environment (prod/dev)
3. Copy password
4. Use in connection string

### API Integration
1. Look for `web/api/` or `mobile/api/` secrets
2. Check service name
3. Copy API key
4. Configure application

### Certificate Access
1. Look for `certs/` secrets
2. Check certificate type
3. Copy certificate
4. Use for SSL/signing

## 📊 Environment Codes

- **prod**: Production environment
- **dev**: Development environment
- **staging**: Staging environment
- **test**: Testing environment

## 🎯 Secret Types

- **Passwords**: Database, service account passwords
- **API Keys**: External service authentication
- **Certificates**: SSL, code signing certificates
- **Connection Strings**: Database connection strings
- **Tokens**: Access tokens, refresh tokens

---

*Need more help? Check the full user guide or contact IT support.*
