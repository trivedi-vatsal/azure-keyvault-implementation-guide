# Troubleshooting Guide

Quick solutions for common Azure Key Vault Explorer issues.

## 🚨 Common Issues

### "Access Denied" Error
**Problem**: User can't access the vault or secrets

**Solutions:**
1. **Check with admin**: Verify you're in the correct security group
2. **Wait 15 minutes**: Group changes can take time to propagate
3. **Sign out and back in**: Refresh your authentication
4. **Check vault name**: Ensure you're connecting to the right vault

### "Vault Not Found" Error
**Problem**: Can't find or connect to the vault

**Solutions:**
1. **Verify vault name**: Ask admin for correct vault name
2. **Check tenant**: Make sure you're in the company tenant
3. **Check network**: Ensure you're on corporate network
4. **Try Azure Portal**: Test access via portal.azure.com

### "No Secrets Visible" Error
**Problem**: Can see vault but no secrets are listed

**Solutions:**
1. **Check permissions**: You may need higher access level
2. **Request access**: Follow the access request process
3. **Wait for approval**: Access changes can take up to 24 hours
4. **Contact support**: Reach out to IT Service Desk

### App Won't Start
**Problem**: Azure Key Vault Explorer won't launch

**Solutions:**
1. **Check internet connection**: Ensure you're connected
2. **Restart the app**: Close and reopen
3. **Update the app**: Check Microsoft Store for updates
4. **Restart computer**: Try a full restart
5. **Reinstall app**: Uninstall and reinstall from Store

### Can't Sign In
**Problem**: Authentication fails or loops

**Solutions:**
1. **Check credentials**: Verify email and password
2. **Complete MFA**: Finish multi-factor authentication
3. **Clear browser cache**: Clear cookies and cache
4. **Try different browser**: Use Edge or Chrome
5. **Check device compliance**: Ensure device is compliant

### Copy Not Working
**Problem**: Can't copy secret values to clipboard

**Solutions:**
1. **Check clipboard**: Try copying something else first
2. **Restart app**: Close and reopen Azure Key Vault Explorer
3. **Check permissions**: App may need clipboard access
4. **Use right-click**: Try right-click copy
5. **Manual copy**: Select and copy text manually

### Slow Performance
**Problem**: App is slow or unresponsive

**Solutions:**
1. **Check internet speed**: Ensure good connection
2. **Close other apps**: Free up system resources
3. **Restart app**: Close and reopen
4. **Check vault size**: Large vaults may be slower
5. **Contact admin**: May be a vault configuration issue

## 🔍 Diagnostic Steps

### Step 1: Basic Checks
1. **Internet connection**: Can you browse other websites?
2. **Azure Portal access**: Can you access portal.azure.com?
3. **Company network**: Are you on corporate network?
4. **Device compliance**: Is your device compliant?

### Step 2: App-Specific Checks
1. **App version**: Is it the latest version?
2. **Sign-in status**: Are you properly signed in?
3. **Vault connection**: Can you see the vault in the list?
4. **Permissions**: Do you have the right access level?

### Step 3: Network Checks
1. **VPN connection**: Are you connected to corporate VPN?
2. **Firewall rules**: Are there any blocking rules?
3. **DNS resolution**: Can you resolve the vault URL?
4. **Proxy settings**: Are proxy settings correct?

## 📞 Escalation Process

### Level 1: Self-Service
- **Check this guide**: Most issues covered here
- **Try basic troubleshooting**: Follow steps above
- **Ask colleagues**: Other team members may know

### Level 2: IT Support
- **Email**: it-servicedesk@company.com
- **Include**: Error message, steps taken, vault name
- **Response time**: 1-2 business days

### Level 3: Platform Team
- **Email**: platform-team@company.com
- **For**: Technical issues, vault problems
- **Response time**: 4-8 hours

### Level 4: Emergency
- **Phone**: +1-XXX-XXX-XXXX
- **For**: Critical business impact
- **Response time**: 1-2 hours

## 📋 Information to Provide

When contacting support, include:

### Basic Information
- **Your name and team**
- **Vault name you're trying to access**
- **Error message (exact text)**
- **Steps you've already tried**

### Technical Details
- **App version**: Check in app settings
- **Operating system**: Windows version
- **Network location**: Office/home/remote
- **Time of issue**: When did it start?

### Screenshots
- **Error messages**: Screenshot of any errors
- **App state**: What you see in the app
- **Network status**: Connection indicators

## 🔧 Quick Fixes

### Reset App
1. **Sign out** of the app
2. **Close** the app completely
3. **Wait 30 seconds**
4. **Reopen** and sign back in

### Clear Cache
1. **Sign out** of the app
2. **Close** the app
3. **Clear browser cache** (if using web version)
4. **Restart** the app

### Check Permissions
1. **Verify group membership** with admin
2. **Wait 15 minutes** for changes to propagate
3. **Sign out and back in**
4. **Try again**

## 📚 Additional Resources

### Documentation
- **User Guide**: Complete user documentation
- **Admin Setup**: For IT administrators
- **Access Request**: How to request access

### Training
- **Video Tutorials**: Step-by-step walkthroughs
- **Live Training**: Scheduled training sessions
- **FAQ**: Frequently asked questions

### Support
- **IT Service Desk**: it-servicedesk@company.com
- **Platform Team**: platform-team@company.com
- **Emergency**: +1-XXX-XXX-XXXX

---

*Still having issues? Contact IT Service Desk with the information above.*
