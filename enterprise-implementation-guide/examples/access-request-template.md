# Access Request Email Template

Use this template when requesting access to Azure Key Vault resources.

## Email Template

```
Subject: AKV Access Request - {Team} - {Resource} - {Your Name}

To: it-servicedesk@company.com
CC: {Your Manager Email}

Dear IT Service Desk,

I am requesting access to Azure Key Vault resources for the following:

**Request Details:**
- Team: {Team Name}
- Resource: {Secret/Key Name}
- Permission Level: {User/Officer/Admin}
- Justification: {Business Need - be specific}
- Duration: {Permanent/Temporary with end date}
- Manager Approval: {Attached/Reference}

**Business Justification:**
{Provide detailed explanation of why you need access, what you'll use it for, and how it supports business objectives}

**Security Acknowledgment:**
I understand that:
- All access is logged and monitored
- I will follow company security policies
- I will not share secrets via insecure channels
- I will report any security incidents immediately

**Manager Approval:**
{Manager Name} has approved this request.
{Attach approval email or reference ticket}

Please let me know if you need any additional information.

Best regards,
{Your Name}
{Your Title}
{Your Contact Information}
```

## Field Descriptions

| Field                | Description                   | Example                                                                  |
| -------------------- | ----------------------------- | ------------------------------------------------------------------------ |
| **Team**             | Your team or department       | Data Engineering                                                         |
| **Resource**         | Specific secret/key name      | `data/etl/database/password/prod`                                        |
| **Permission Level** | Required access level         | Secrets User, Secrets Officer, Admin                                     |
| **Justification**    | Business reason for access    | "Need to access production database credentials for ETL job maintenance" |
| **Duration**         | How long access is needed     | Permanent, Until 2024-12-31, 6 months                                    |
| **Manager Approval** | Reference to manager approval | "Attached approval from John Smith"                                      |

## Permission Levels

### Secrets User

- Read and list secrets
- Use secrets in applications
- Cannot create, update, or delete secrets

### Secrets Officer

- All Secrets User permissions
- Create, update, and delete secrets
- Manage secret lifecycle
- Assign to team leads and security officers

### Crypto User

- Use keys for cryptographic operations
- Sign and verify data
- Wrap and unwrap keys
- Cannot create, update, or delete keys

### Crypto Officer

- All Crypto User permissions
- Create, update, and delete keys
- Manage key lifecycle
- Assign to security team

### Administrator

- Full management access
- Manage RBAC assignments
- Configure vault settings
- Assign to platform and security teams only

## Examples

### Example 1: Developer Request

```
Subject: AKV Access Request - Data Engineering - data/etl/database/password/prod - Jane Smith

Dear IT Service Desk,

I am requesting access to Azure Key Vault resources for the following:

**Request Details:**
- Team: Data Engineering
- Resource: data/etl/database/password/prod
- Permission Level: Secrets User
- Justification: Need to access production database credentials for ETL job maintenance and troubleshooting
- Duration: Permanent
- Manager Approval: Attached approval from John Doe

**Business Justification:**
I need access to the production database password to maintain and troubleshoot our ETL jobs. This is critical for our data pipeline operations and business continuity.

**Security Acknowledgment:**
I understand that all access is logged and monitored, and I will follow company security policies.

Best regards,
Jane Smith
Senior Data Engineer
jane.smith@company.com
```

### Example 2: Team Lead Request

```
Subject: AKV Access Request - Web Development - web/api/* - Bob Wilson

Dear IT Service Desk,

I am requesting access to Azure Key Vault resources for the following:

**Request Details:**
- Team: Web Development
- Resource: web/api/* (all web API secrets)
- Permission Level: Secrets Officer
- Justification: Need to manage API keys and secrets for our web applications
- Duration: Permanent
- Manager Approval: Reference ticket #IT-12345

**Business Justification:**
As team lead, I need to manage API keys and secrets for our web applications. This includes rotating keys, updating secrets, and managing access for my team members.

Best regards,
Bob Wilson
Web Development Team Lead
bob.wilson@company.com
```

## Approval Process

1. **Submit Request**: Send email using this template
2. **Manager Approval**: Your manager must approve the request
3. **Security Review**: IT Security will review the request
4. **Access Provisioning**: You'll be added to the appropriate security group
5. **Notification**: You'll receive confirmation when access is granted

## Response Times

- **Standard Requests**: 1-2 business days
- **Urgent Requests**: 4-8 hours (with manager approval)
- **Emergency Requests**: 1-2 hours (with IT Director approval)

## Contact Information

- **IT Service Desk**: it-servicedesk@company.com
- **Platform Team**: platform-team@company.com
- **Security Team**: security-team@company.com
- **Emergency**: +1-XXX-XXX-XXXX
