# Naming Conventions

This document provides detailed examples and guidelines for naming secrets, keys, and certificates in Azure Key Vault.

## Secret Naming

### Format

```
{team}/{system}/{purpose}[/{environment}]
```

### Examples

#### Database Credentials

```
data/etl/database/password/prod
data/etl/database/password/dev
data/etl/database/password/staging
data/warehouse/connection-string/prod
data/warehouse/connection-string/dev
```

#### API Keys

```
web/api/external-service/key/prod
web/api/external-service/key/dev
mobile/api/push-notification/key/prod
mobile/api/push-notification/key/dev
```

#### Certificates

```
web/ssl/certificate/prod
web/ssl/certificate/dev
mobile/app/push-notification/cert/prod
mobile/app/push-notification/cert/dev
```

#### Connection Strings

```
data/etl/database/connection-string/prod
data/etl/database/connection-string/dev
web/api/external-service/connection-string/prod
web/api/external-service/connection-string/dev
```

#### Service Account Credentials

```
data/etl/service-account/password/prod
data/etl/service-account/password/dev
web/api/service-account/password/prod
web/api/service-account/password/dev
```

## Key Naming

### Format

```
keys/{team}/{system}/{purpose}[/{environment}]
```

### Examples

#### Encryption Keys

```
keys/data/encryption/tenant-signing/prod
keys/data/encryption/tenant-signing/dev
keys/payment/encryption/processor/prod
keys/payment/encryption/processor/dev
```

#### JWT Signing Keys

```
keys/web/api/jwt-signing/prod
keys/web/api/jwt-signing/dev
keys/mobile/app/jwt-signing/prod
keys/mobile/app/jwt-signing/dev
```

#### Data Encryption Keys

```
keys/data/encryption/field-level/prod
keys/data/encryption/field-level/dev
keys/payment/encryption/card-data/prod
keys/payment/encryption/card-data/dev
```

## Certificate Naming

### Format

```
certs/{team}/{system}/{purpose}[/{environment}]
```

### Examples

#### SSL Certificates

```
certs/web/ssl/domain/prod
certs/web/ssl/domain/dev
certs/api/ssl/domain/prod
certs/api/ssl/domain/dev
```

#### Code Signing Certificates

```
certs/mobile/app/code-signing/prod
certs/mobile/app/code-signing/dev
certs/desktop/app/code-signing/prod
certs/desktop/app/code-signing/dev
```

## Team Names

### Standard Team Names

- `data` - Data Engineering, Analytics, BI
- `web` - Web Development, Frontend
- `api` - API Development, Backend Services
- `mobile` - Mobile Development
- `desktop` - Desktop Applications
- `infrastructure` - Infrastructure, DevOps
- `security` - Security Team
- `platform` - Platform Team
- `payment` - Payment Systems
- `integration` - Integration Services

### Examples

```
data/etl/database/password/prod
web/api/external-service/key/prod
mobile/app/push-notification/cert/prod
infrastructure/monitoring/api-key/prod
security/audit/logging-key/prod
platform/automation/service-account/prod
```

## System Names

### Common System Names

- `etl` - ETL processes
- `api` - API services
- `database` - Database systems
- `warehouse` - Data warehouse
- `monitoring` - Monitoring systems
- `logging` - Logging systems
- `automation` - Automation scripts
- `integration` - Integration services
- `payment` - Payment processing
- `notification` - Notification services

### Examples

```
data/etl/database/password/prod
web/api/external-service/key/prod
infrastructure/monitoring/api-key/prod
platform/automation/service-account/prod
```

## Purpose Names

### Common Purposes

- `password` - Passwords
- `key` - API keys, access keys
- `certificate` - SSL certificates, code signing
- `connection-string` - Database connection strings
- `service-account` - Service account credentials
- `encryption` - Encryption keys
- `signing` - Signing keys
- `jwt` - JWT signing keys
- `api-key` - API keys
- `access-token` - Access tokens

### Examples

```
data/etl/database/password/prod
web/api/external-service/key/prod
mobile/app/push-notification/cert/prod
keys/data/encryption/tenant-signing/prod
```

## Environment Names

### Standard Environments

- `prod` - Production
- `dev` - Development
- `staging` - Staging
- `test` - Testing
- `uat` - User Acceptance Testing
- `preprod` - Pre-production

### Examples

```
data/etl/database/password/prod
data/etl/database/password/dev
data/etl/database/password/staging
data/etl/database/password/test
```

## Special Cases

### Versioned Secrets

```
data/etl/database/password/prod/v1
data/etl/database/password/prod/v2
web/api/external-service/key/prod/v1
web/api/external-service/key/prod/v2
```

### Regional Secrets

```
data/etl/database/password/prod/us-east
data/etl/database/password/prod/us-west
web/api/external-service/key/prod/eu-west
web/api/external-service/key/prod/asia-pacific
```

### Feature-Specific Secrets

```
data/etl/database/password/prod/feature-xyz
web/api/external-service/key/prod/feature-abc
mobile/app/push-notification/cert/prod/feature-123
```

## Naming Rules

### Do's

- ✅ Use lowercase letters only
- ✅ Use forward slashes (/) as separators
- ✅ Be descriptive and specific
- ✅ Include environment when applicable
- ✅ Use consistent team names
- ✅ Use consistent system names
- ✅ Use consistent purpose names

### Don'ts

- ❌ Don't use spaces
- ❌ Don't use special characters except forward slashes
- ❌ Don't use uppercase letters
- ❌ Don't use underscores
- ❌ Don't use hyphens
- ❌ Don't be too generic
- ❌ Don't use abbreviations unless standard

## Validation

### Secret Name Validation

```powershell
# Validate secret name format
function Test-SecretName {
    param([string]$Name)

    $pattern = '^[a-z]+/[a-z-]+/[a-z-]+(/[a-z]+)?$'
    return $Name -match $pattern
}

# Test examples
Test-SecretName "data/etl/database/password/prod"  # True
Test-SecretName "web/api/external-service/key/dev"  # True
Test-SecretName "data/etl/database/password"  # True
Test-SecretName "Data/ETL/Database/Password/Prod"  # False (uppercase)
Test-SecretName "data_etl_database_password_prod"  # False (underscores)
```

### Key Name Validation

```powershell
# Validate key name format
function Test-KeyName {
    param([string]$Name)

    $pattern = '^keys/[a-z]+/[a-z-]+/[a-z-]+(/[a-z]+)?$'
    return $Name -match $pattern
}

# Test examples
Test-KeyName "keys/data/encryption/tenant-signing/prod"  # True
Test-KeyName "keys/web/api/jwt-signing/dev"  # True
Test-KeyName "data/encryption/tenant-signing/prod"  # False (missing 'keys/')
```

## Migration Examples

### From Old Naming

```
# Old naming (don't use)
database_password_prod
api_key_web_prod
ssl_certificate_domain_prod

# New naming (use this)
data/database/password/prod
web/api/key/prod
web/ssl/certificate/prod
```

### From Environment Variables

```
# Environment variable names
DATABASE_PASSWORD_PROD
API_KEY_WEB_PROD
SSL_CERTIFICATE_DOMAIN_PROD

# Key Vault secret names
data/database/password/prod
web/api/key/prod
web/ssl/certificate/prod
```

## Best Practices

1. **Consistency**: Use the same naming pattern across all secrets
2. **Descriptiveness**: Names should clearly indicate what the secret is for
3. **Hierarchy**: Use the team/system/purpose structure for organization
4. **Environment**: Always include environment when applicable
5. **Validation**: Use scripts to validate naming conventions
6. **Documentation**: Document any special naming rules for your organization
7. **Review**: Regularly review naming conventions for consistency
