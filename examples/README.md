# Examples

This folder contains practical examples and templates for Azure Key Vault implementation.

## 📁 Contents

| File                                                     | Description                         |
| -------------------------------------------------------- | ----------------------------------- |
| [secrets.csv](secrets.csv)                               | Sample secrets for bulk import      |
| [keys.csv](keys.csv)                                     | Sample keys for bulk import         |
| [access-request-template.md](access-request-template.md) | Email template for access requests  |
| [naming-conventions.md](naming-conventions.md)           | Detailed naming convention examples |
| [tags-reference.md](tags-reference.md)                   | Complete tagging strategy reference |
| [scripts/](scripts/)                                     | Example scripts and automation      |
| [templates/](templates/)                                 | Configuration templates             |

## 🚀 Quick Start

1. **Review Naming Conventions**: Start with [naming-conventions.md](naming-conventions.md)
2. **Bulk Import Secrets**: Use [secrets.csv](secrets.csv) as a template
3. **Request Access**: Use [access-request-template.md](access-request-template.md)
4. **Configure Tags**: Follow [tags-reference.md](tags-reference.md)

## 📋 Usage

### Bulk Import

```powershell
# Import secrets from CSV
.\scripts\import-secrets.ps1 -CsvPath "secrets.csv"

# Import keys from CSV
.\scripts\import-keys.ps1 -CsvPath "keys.csv"
```

### Access Request

Copy the template from [access-request-template.md](access-request-template.md) and customize for your needs.

### Naming Standards

Follow the examples in [naming-conventions.md](naming-conventions.md) for consistent naming.

## 🔧 Customization

All examples use placeholder values that should be replaced with your organization's actual values:

- `{company}` → Your organization name
- `{team}` → Your team name
- `{environment}` → dev/staging/prod
- `{owner}` → Your email address
- `{ticket}` → Related ticket ID

## 📞 Support

For questions about these examples, contact:

- **Platform Team**: platform-team@company.com
- **IT Service Desk**: it-servicedesk@company.com
