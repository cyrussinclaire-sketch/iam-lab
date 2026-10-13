## Project 3: Access Review & Compliance Engine

## Scenario

An IAM analyst at a small company is asked to run a quarterly access review before a SOC 2 audit. They have no tools, no budget, and a domain controller full of users. They need to find accounts that violate least privilege and produce evidence for the auditor.

## Problem

Manual access reviews are slow and inconsistent. There is no visibility into stale accounts, orphaned accounts, disabled users with active group memberships, or privileged users that have not been certified in months. Auditors want evidence in a specific format that maps to controls.

## Risk

- **Stale accounts** allow credential compromise to go unnoticed
- **Disabled accounts with access** fail termination controls
- **Uncertified privileged users** violate separation of duties
- **Orphaned accounts** indicate identity data quality failure
- **No audit evidence** fails SOC 2 CC6.1, CC6.2, CC6.3

## Built

PowerShell access review engine that runs against Active Directory (`corp.local`) and performs five checks:

| Check | Logic | SOC 2 Control | Severity |
| :--- | :--- | :--- | :--- |
| StaleAccount | Enabled, no logon in 90+ days | CC6.1 | Medium |
| DisabledWithAccess | Disabled but still in non-default groups | CC6.3 | High |
| PrivilegedUser | Member of IT_Admins | CC6.1 | High |
| OrphanedAccount | Enabled, no Department attribute | CC6.2 | Medium |
| GroupMembership | Inventory of non-default group memberships | CC6.1 | Info |

### Components

- **AccessReviewEngine.ps1** — scans AD, classifies findings, exports CSV
- **Generate-HtmlReport.ps1** — converts findings CSV into auditor-ready HTML
- Output: `AccessReview-YYYY-MM-DD.csv` and `.html`

## Evidence

### Test Run — 2026-10-13

Total findings: 11
- High: 1
- Medium: 7
- Info: 3
- Unique users reviewed: 6

Sample findings from `corp.local`:

| Sam | Check | Severity | SOC 2 |
| :--- | :--- | :--- | :--- |
| tuser | PrivilegedUser | High | CC6.1 |
| tuser | OrphanedAccount | Medium | CC6.2 |
| tuser | StaleAccount | Medium | CC6.1 |
| Administrator | OrphanedAccount | Medium | CC6.2 |
| jdoe | StaleAccount | Medium | CC6.1 |
| jsmith | StaleAccount | Medium | CC6.1 |
| mjohnson | StaleAccount | Medium | CC6.1 |
| swilliams | StaleAccount | Medium | CC6.1 |
| Administrator | GroupMembership | Info | CC6.1 |
| swilliams | GroupMembership | Info | CC6.1 |
| tuser | GroupMembership | Info | CC6.1 |

### Screenshots

**Report Summary:**
![Report Top](screenshots/access-review-report-top.png)

**Findings Table:**
![Report Table](screenshots/access-review-report-table.png)

## Recommendation

1. Disable or delete stale accounts after 90 days of inactivity
2. Remove disabled accounts from all non-default groups on termination
3. Certify privileged users quarterly
4. Enforce Department attribute at provisioning
5. Automate the review to run monthly and email the HTML report to the security team

## Lessons

- PowerShell 5.1 `Where-Object` returns a single object when only one match exists, which breaks `.Count`. Always wrap in `@()` to force an array.
- `LastLogonDate` is blank until a user logs in — a real environment will have data, a lab will not.
- SOC 2 mapping belongs in the report, not in a separate spreadsheet. Auditors want it inline.
- Test data with 6 users is enough to prove the engine works. Scaling to 500 is a data problem, not a logic problem.

## Files

- `AccessReviewEngine.ps1` — main engine
- `Generate-HtmlReport.ps1` — report generator
- `samples/AccessReview-Sample.csv` — sample output from test run

## Status

Complete. Tested against `corp.local` with 6 users and 11 findings.
