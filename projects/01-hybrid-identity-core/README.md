# Project 1: Hybrid Identity Core

## Objective
Build a Windows Server 2022 domain controller and sync on-prem Active Directory users to Microsoft Entra ID using password hash synchronization.

## Architecture
- VM: VirtualBox on Intel MacBook Air
- Domain controller: Windows Server 2022, hostname DC01
- IP: 10.0.2.10 (static), Gateway 10.0.2.2
- Domain: corp.local
- NetBIOS: CORP
- Sync tool: Microsoft Entra Connect
- Cloud tenant: Microsoft Entra ID (Azure for Students)

## Active Directory Structure

| Object | Type | Distinguished Name |
| :--- | :--- | :--- |
| Employees | OU | OU=Employees,DC=corp,DC=local |
| IT | OU | OU=IT,OU=Employees,DC=corp,DC=local |
| HR | OU | OU=HR,OU=Employees,DC=corp,DC=local |
| Groups | OU | OU=Groups,DC=corp,DC=local |
| Test User (tuser) | User | CN=Test User,OU=IT,OU=Employees,DC=corp,DC=local |
| IT_Admins | Group | OU=Groups,DC=corp,DC=local |

## Password Policy
- MinPasswordLength: 12
- ComplexityEnabled: True
- MaxPasswordAge: 90 days
- GPO: Password Policy linked to DC=corp,DC=local

## Progress
- [x] VM created (DC01)
- [x] Windows Server 2022 installed
- [x] Static IP configured
- [x] AD DS installed and promoted to Domain Controller
- [x] OUs, users, groups created
- [x] GPO configured
- [ ] Microsoft Entra Connect installed
- [ ] Password hash sync enabled

## Screenshots

### AD Structure
![AD Structure](screenshots/ad-structure.png)

### Password Policy
![Password Policy](screenshots/password-policy.png)

## Status
DC operational. AD structure built. Next: Entra Connect + password hash sync.
