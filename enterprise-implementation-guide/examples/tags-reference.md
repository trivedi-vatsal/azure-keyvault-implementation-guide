# Tags Reference

This document provides a comprehensive reference for tagging secrets, keys, and certificates in Azure Key Vault.

## Required Tags

### team

**Description**: The team or department that owns the secret
**Values**: Standard team names
**Examples**: `data`, `web`, `api`, `mobile`, `infrastructure`, `security`, `platform`

```json
{
  "team": "data"
}
```

### environment

**Description**: The environment where the secret is used
**Values**: `prod`, `dev`, `staging`, `test`, `uat`, `preprod`
**Examples**: `prod`, `dev`, `staging`

```json
{
  "environment": "prod"
}
```

### owner

**Description**: The UPN of the person responsible for the secret
**Format**: Email address
**Examples**: `john.doe@company.com`, `jane.smith@company.com`

```json
{
  "owner": "john.doe@company.com"
}
```

### ticket

**Description**: Related ticket or request ID
**Format**: Ticket number or reference
**Examples**: `IT-12345`, `REQ-67890`, `INC-11111`

```json
{
  "ticket": "IT-12345"
}
```

### pii

**Description**: Indicates if the secret contains personally identifiable information
**Values**: `yes`, `no`
**Examples**: `no`, `yes`

```json
{
  "pii": "no"
}
```

### decommission_date

**Description**: When the secret should be removed
**Format**: ISO 8601 date
**Examples**: `2024-12-31`, `2025-06-30`

```json
{
  "decommission_date": "2024-12-31"
}
```

## Optional Tags

### project

**Description**: Associated project or initiative
**Values**: Project names or codes
**Examples**: `data-migration`, `web-redesign`, `mobile-app-v2`

```json
{
  "project": "data-migration"
}
```

### cost_center

**Description**: Financial tracking code
**Values**: Cost center codes
**Examples**: `IT-001`, `ENG-002`, `SEC-003`

```json
{
  "cost_center": "IT-001"
}
```

### compliance

**Description**: Compliance requirements
**Values**: Compliance standards
**Examples**: `SOC2`, `GDPR`, `HIPAA`, `PCI-DSS`

```json
{
  "compliance": "SOC2"
}
```

### rotation_schedule

**Description**: How often the secret should be rotated
**Values**: Rotation frequency
**Examples**: `30-days`, `90-days`, `180-days`, `1-year`, `manual`

```json
{
  "rotation_schedule": "90-days"
}
```

### classification

**Description**: Data classification level
**Values**: Classification levels
**Examples**: `public`, `internal`, `confidential`, `secret`

```json
{
  "classification": "confidential"
}
```

### region

**Description**: Geographic region
**Values**: Region codes
**Examples**: `us-east`, `us-west`, `eu-west`, `asia-pacific`

```json
{
  "region": "us-east"
}
```

### application

**Description**: Associated application
**Values**: Application names
**Examples**: `etl-pipeline`, `web-api`, `mobile-app`, `desktop-app`

```json
{
  "application": "etl-pipeline"
}
```

### service

**Description**: Associated service
**Values**: Service names
**Examples**: `database`, `api-gateway`, `message-queue`, `cache`

```json
{
  "service": "database"
}
```

### version

**Description**: Secret version
**Values**: Version numbers
**Examples**: `v1`, `v2`, `1.0`, `2.0`

```json
{
  "version": "v1"
}
```

### created_by

**Description**: Who created the secret
**Values**: UPN of creator
**Examples**: `admin@company.com`, `automation@company.com`

```json
{
  "created_by": "admin@company.com"
}
```

### last_rotated

**Description**: When the secret was last rotated
**Format**: ISO 8601 date
**Examples**: `2024-01-15`, `2024-06-30`

```json
{
  "last_rotated": "2024-01-15"
}
```

### next_rotation

**Description**: When the secret should be rotated next
**Format**: ISO 8601 date
**Examples**: `2024-04-15`, `2024-09-30`

```json
{
  "next_rotation": "2024-04-15"
}
```

## Tag Examples

### Database Password

```json
{
  "team": "data",
  "environment": "prod",
  "owner": "john.doe@company.com",
  "ticket": "IT-12345",
  "pii": "no",
  "decommission_date": "2024-12-31",
  "project": "data-migration",
  "cost_center": "IT-001",
  "compliance": "SOC2",
  "rotation_schedule": "90-days",
  "classification": "confidential",
  "application": "etl-pipeline",
  "service": "database"
}
```

### API Key

```json
{
  "team": "web",
  "environment": "prod",
  "owner": "jane.smith@company.com",
  "ticket": "REQ-67890",
  "pii": "no",
  "decommission_date": "2025-06-30",
  "project": "web-redesign",
  "cost_center": "ENG-002",
  "compliance": "SOC2",
  "rotation_schedule": "180-days",
  "classification": "internal",
  "application": "web-api",
  "service": "api-gateway"
}
```

### Encryption Key

```json
{
  "team": "security",
  "environment": "prod",
  "owner": "bob.wilson@company.com",
  "ticket": "SEC-11111",
  "pii": "yes",
  "decommission_date": "2026-12-31",
  "project": "encryption-upgrade",
  "cost_center": "SEC-003",
  "compliance": "GDPR",
  "rotation_schedule": "1-year",
  "classification": "secret",
  "application": "payment-system",
  "service": "encryption"
}
```

### SSL Certificate

```json
{
  "team": "infrastructure",
  "environment": "prod",
  "owner": "alice.johnson@company.com",
  "ticket": "INF-22222",
  "pii": "no",
  "decommission_date": "2024-12-31",
  "project": "ssl-renewal",
  "cost_center": "IT-001",
  "compliance": "SOC2",
  "rotation_schedule": "1-year",
  "classification": "internal",
  "application": "web-site",
  "service": "ssl"
}
```

## Tag Validation

### PowerShell Validation

```powershell
# Validate required tags
function Test-RequiredTags {
    param([hashtable]$Tags)

    $required = @('team', 'environment', 'owner', 'ticket', 'pii', 'decommission_date')
    $missing = @()

    foreach ($tag in $required) {
        if (-not $Tags.ContainsKey($tag)) {
            $missing += $tag
        }
    }

    return $missing
}

# Validate tag values
function Test-TagValues {
    param([hashtable]$Tags)

    $errors = @()

    # Validate environment
    if ($Tags.ContainsKey('environment')) {
        $validEnvs = @('prod', 'dev', 'staging', 'test', 'uat', 'preprod')
        if ($Tags.environment -notin $validEnvs) {
            $errors += "Invalid environment: $($Tags.environment)"
        }
    }

    # Validate PII
    if ($Tags.ContainsKey('pii')) {
        if ($Tags.pii -notin @('yes', 'no')) {
            $errors += "Invalid pii value: $($Tags.pii)"
        }
    }

    # Validate owner email
    if ($Tags.ContainsKey('owner')) {
        if ($Tags.owner -notmatch '^[^@]+@[^@]+\.[^@]+$') {
            $errors += "Invalid owner email: $($Tags.owner)"
        }
    }

    return $errors
}
```

### Azure CLI Validation

```bash
# Check if secret has required tags
az keyvault secret show --vault-name "contoso-prod-secrets" --name "data/etl/database/password/prod" --query "tags" --output json

# Validate specific tag
az keyvault secret show --vault-name "contoso-prod-secrets" --name "data/etl/database/password/prod" --query "tags.environment" --output tsv
```

## Tag Management

### Adding Tags

```bash
# Add tags when creating secret
az keyvault secret set \
  --vault-name "contoso-prod-secrets" \
  --name "data/etl/database/password/prod" \
  --value "SecurePassword123!" \
  --tags team="data" env="prod" owner="john.doe@company.com" ticket="IT-12345" pii="no" decommission_date="2024-12-31"
```

### Updating Tags

```bash
# Update tags
az keyvault secret set \
  --vault-name "contoso-prod-secrets" \
  --name "data/etl/database/password/prod" \
  --value "SecurePassword123!" \
  --tags team="data" env="prod" owner="john.doe@company.com" ticket="IT-12345" pii="no" decommission_date="2024-12-31" last_rotated="2024-01-15"
```

### Querying by Tags

```bash
# Find secrets by team
az keyvault secret list --vault-name "contoso-prod-secrets" --query "[?tags.team=='data']" --output table

# Find secrets by environment
az keyvault secret list --vault-name "contoso-prod-secrets" --query "[?tags.environment=='prod']" --output table

# Find secrets by owner
az keyvault secret list --vault-name "contoso-prod-secrets" --query "[?tags.owner=='john.doe@company.com']" --output table
```

## Best Practices

1. **Consistency**: Use the same tag values across all secrets
2. **Completeness**: Always include required tags
3. **Validation**: Use scripts to validate tag values
4. **Documentation**: Document any custom tag values
5. **Review**: Regularly review tags for accuracy
6. **Automation**: Use automation to add standard tags
7. **Governance**: Implement tag governance policies
