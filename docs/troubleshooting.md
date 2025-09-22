# Troubleshooting Guide

## Common Issues

### 1. Access Denied Errors

#### Symptoms

- User cannot access secrets despite being in correct group
- "Access denied" error messages
- Empty secret list when user should have access

#### Solutions

1. **Verify Group Membership**:

   ```bash
   # Check if user is in the correct group
   az ad group member list --group "GG-AKV-PROD-SECRETS-USERS-DATA" --query "[?displayName=='User Name']"
   ```

2. **Check RBAC Role Assignments**:

   ```bash
   # List role assignments for the vault
   az role assignment list --scope $(az keyvault show --name "{vault-name}" --query id -o tsv) --output table
   ```

3. **Confirm Vault Firewall Rules**:

   ```bash
   # Check firewall rules
   az keyvault show --name "{vault-name}" --query "properties.networkAcls"
   ```

4. **Validate Conditional Access Policies**:
   - Check Azure Portal > Conditional Access
   - Verify user's device compliance
   - Check MFA requirements

#### Prevention

- Regular access reviews
- Automated group membership validation
- Clear documentation of access requirements

### 2. Network Connectivity Issues

#### Symptoms

- Cannot connect to vault from application
- Timeout errors
- DNS resolution failures

#### Solutions

1. **Verify Private Endpoint Configuration**:

   ```bash
   # Check private endpoint status
   az network private-endpoint show --name "kv-pe-{vault-name}" --resource-group "{rg}"
   ```

2. **Check DNS Resolution**:

   ```bash
   # Test DNS resolution
   nslookup {vault-name}.vault.azure.net
   ```

3. **Confirm Firewall Rules**:

   ```bash
   # Check network rules
   az keyvault show --name "{vault-name}" --query "properties.networkAcls.ipRules"
   ```

4. **Test from Different Network Location**:
   - Try from corporate network
   - Test from VPN connection
   - Verify public network access if configured

#### Prevention

- Proper DNS configuration
- Regular network connectivity testing
- Documented network requirements

### 3. Performance Issues

#### Symptoms

- Slow secret retrieval
- Timeout errors
- High latency

#### Solutions

1. **Check Vault SKU and Limits**:

   ```bash
   # Check vault SKU
   az keyvault show --name "{vault-name}" --query "properties.sku"
   ```

2. **Review Network Latency**:

   ```bash
   # Test connectivity
   ping {vault-name}.vault.azure.net
   ```

3. **Optimize Secret Naming**:
   - Use shorter secret names
   - Avoid special characters
   - Follow naming conventions

4. **Consider Caching Strategies**:
   - Implement application-level caching
   - Use Azure Cache for Redis
   - Cache frequently accessed secrets

#### Prevention

- Performance monitoring
- Regular capacity planning
- Optimized secret naming

### 4. Authentication Problems

#### Symptoms

- MFA prompt loops
- Authentication failures
- Token expiration errors

#### Solutions

1. **Clear Browser Cache and Cookies**:
   - Clear browser data
   - Try incognito/private mode
   - Use different browser

2. **Check Device Compliance Status**:
   - Verify device is enrolled in MDM
   - Check compliance policies
   - Update device if needed

3. **Verify Conditional Access Policies**:
   - Check policy requirements
   - Verify location-based policies
   - Review device compliance requirements

4. **Test with Different Authentication Method**:
   - Try different MFA method
   - Use mobile app instead of SMS
   - Test with different account

#### Prevention

- Regular device compliance checks
- Clear authentication documentation
- User training on MFA

### 5. Secret Not Found Errors

#### Symptoms

- "Secret not found" error messages
- Empty search results
- Application cannot find secret

#### Solutions

1. **Verify Secret Name**:

   ```bash
   # List all secrets
   az keyvault secret list --vault-name "{vault-name}" --output table
   ```

2. **Check Secret Permissions**:

   ```bash
   # Test secret access
   az keyvault secret show --vault-name "{vault-name}" --name "{secret-name}"
   ```

3. **Verify Secret Exists**:

   ```bash
   # Check if secret was deleted
   az keyvault secret list-deleted --vault-name "{vault-name}"
   ```

4. **Check Vault Name**:
   - Verify correct vault name
   - Check vault region
   - Confirm vault is accessible

#### Prevention

- Consistent naming conventions
- Regular secret inventory
- Clear documentation

## Diagnostic Commands

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

### Network Diagnostics

```bash
# Test DNS resolution
nslookup {vault-name}.vault.azure.net

# Test connectivity
telnet {vault-name}.vault.azure.net 443

# Check firewall rules
az keyvault show --name "{vault-name}" --query "properties.networkAcls"
```

### Authentication Diagnostics

```bash
# Check user's group memberships
az ad user get-member-groups --upn "user@company.com" --output table

# Check role assignments
az role assignment list --assignee "user@company.com" --scope "{vault-id}" --output table

# Check conditional access policies
az ad user show --id "user@company.com" --query "assignedPlans"
```

## Log Analysis

### Access Logs

```kusto
// Failed authentication attempts
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where OperationName == "Authentication"
| where ResultType == "Failure"
| where TimeGenerated > ago(1h)
| summarize count() by CallerIPAddress, bin(TimeGenerated, 5m)
| where count_ > 10
```

### Secret Access Patterns

```kusto
// Most accessed secrets
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where OperationName == "SecretGet"
| where TimeGenerated > ago(7d)
| summarize count() by SecretName
| order by count_ desc
```

### Error Analysis

```kusto
// Common errors
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where ResultType == "Failure"
| where TimeGenerated > ago(24h)
| summarize count() by OperationName, ResultType
| order by count_ desc
```

## Performance Troubleshooting

### Response Time Analysis

```kusto
// Slow operations
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where OperationName == "SecretGet"
| where TimeGenerated > ago(1h)
| where DurationMs > 2000
| summarize count() by SecretName, DurationMs
| order by DurationMs desc
```

### Throttling Issues

```kusto
// Throttled requests
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where ResultType == "Throttled"
| where TimeGenerated > ago(1h)
| summarize count() by CallerIPAddress, OperationName
| order by count_ desc
```

## Recovery Procedures

### Secret Recovery

```bash
# List deleted secrets
az keyvault secret list-deleted --vault-name "{vault-name}"

# Restore deleted secret
az keyvault secret restore --vault-name "{vault-name}" --name "{secret-name}"
```

### Vault Recovery

```bash
# Restore from backup
az keyvault restore \
  --vault-name "{vault-name}" \
  --blob-container-name "kv-backups" \
  --storage-account-name "stgkvbackups" \
  --backup-folder "2024-01-15T10-30-00"
```

### Access Recovery

```bash
# Emergency access for admin
az role assignment create \
  --role "Key Vault Administrator" \
  --assignee "admin@company.com" \
  --scope "{vault-id}"
```

## Escalation Procedures

### Level 1: Self-Service

- Check documentation
- Use diagnostic commands
- Review common issues

### Level 2: IT Support

- Contact IT Service Desk
- Provide diagnostic information
- Follow troubleshooting steps

### Level 3: Platform Team

- Escalate to platform team
- Provide detailed logs
- Coordinate with security team

### Level 4: Security Team

- Security-related issues
- Access control problems
- Compliance concerns

## Prevention Strategies

### Proactive Monitoring

- Set up comprehensive alerts
- Monitor performance metrics
- Regular health checks

### Documentation

- Keep documentation updated
- Document common issues
- Maintain troubleshooting guides

### Training

- Regular user training
- Admin training updates
- Incident response training

### Testing

- Regular disaster recovery testing
- Performance testing
- Security testing

## Contact Information

### Support Contacts

- **IT Service Desk**: <it-servicedesk@company.com>
- **Platform Team**: <platform-team@company.com>
- **Security Team**: <security-team@company.com>

### Emergency Contacts

- **On-Call Engineer**: +1-XXX-XXX-XXXX
- **Security Incident**: <security-incident@company.com>
- **Management Escalation**: <it-director@company.com>
