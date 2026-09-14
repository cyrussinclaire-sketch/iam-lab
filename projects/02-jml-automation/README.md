# Project 2: JML Automation Engine

## Objective
Automate the Joiner-Mover-Leaver (JML) identity lifecycle in Active Directory using PowerShell with a CSV HR feed.

## Architecture
- Input: C:\IAM-Lab\HR-Feed\employees.csv
- Script: C:\IAM-Lab\JML\JML-Automation.ps1
- Logs: C:\IAM-Lab\Logs\JML-YYYY-MM-DD.log
- Target: corp.local AD on DC01

## HR Feed Format

| Column | Purpose |
| :--- | :--- |
| FirstName | User first name |
| LastName | User last name |
| Department | IT or HR (drives OU placement) |
| Title | Job title |
| Action | Joiner, Mover, or Leaver |

## Actions

### Joiner
- Creates AD user in correct OU based on Department
- SamAccountName = first initial + last name (lowercase)
- Sets UserPrincipalName, Department, Title
- Sets password: P@ssw0rd123!
- Enables account
- Skips if user already exists

### Mover
- Updates Department and Title attributes
- Removes user from all non-default groups
- Adds user to correct group (IT_Admins for IT, HR_Users for HR)
- Moves user object to correct OU

### Leaver
- Disables AD account
- Sets Description to "Disabled YYYY-MM-DD"
- Removes user from all non-default groups

## Error Handling
- All actions wrapped in try/catch
- Failures logged with timestamp and error message
- Script continues to next row on failure

## Test Results

| User | Action | Result |
| :--- | :--- | :--- |
| jsmith | Joiner | Created in OU=IT, Department=IT |
| jdoe | Joiner | Created in OU=HR, Department=HR |
| mjohnson | Joiner | Created in OU=IT, Department=IT |
| swilliams | Mover | Moved to OU=HR, added to HR_Users, removed from IT_Admins |
| dbrown | Leaver | Disabled, removed from IT_Admins, Description set |

## Verification Screenshots

### JML Script Run
![JML Script Run](screenshots/jml-script-run.png)

### Mover Result
![Mover Result](screenshots/mover-result.png)

### Leaver Result
![Leaver Result](screenshots/leaver-result.png)

### Audit Log
![Audit Log](screenshots/jml-log.png)

### Final State
![Final State](screenshots/jml-final-state.png)

## Known Limitations
- Group removal inside the Mover block occasionally fails silently on PowerShell 5.1 when passing a group object instead of the SamAccountName string. Fix: pass $g.SamAccountName to Remove-ADGroupMember.

## Files
- JML-Automation.ps1 - main automation script
- employees.csv - sample HR feed (in repo)

## Status
Complete. Tested with a 5-row HR feed covering all three JML actions.
