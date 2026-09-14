# IAM Lab Portfolio

Hands-on identity and access management labs. Built on an Intel MacBook Air using VirtualBox and Microsoft Entra ID.

## Projects

| # | Project | Status |
| :--- | :--- | :--- |
| 01 | [Hybrid Identity Core](projects/01-hybrid-identity-core/README.md) | On-prem complete, cloud sync blocked |
| 02 | [JML Automation Engine](projects/02-jml-automation/README.md) | Complete |
| 03 | [Access Review & Compliance](projects/03-access-review/README.md) | Not started |
| 04 | [Zero Trust Identity Layer](projects/04-zero-trust/README.md) | Not started |
| 05 | [PowerShell & Graph API Hub](projects/05-powershell-hub/README.md) | Not started |

## Tools

- VirtualBox
- Windows Server 2022 Evaluation
- Active Directory Domain Services
- Microsoft Entra ID
- Microsoft Entra Connect
- PowerShell
- Microsoft Graph API
- Conditional Access
- Privileged Identity Management

## Environment

| Item | Value |
| :--- | :--- |
| Host | MacBook Air (Intel i5, 16 GB RAM) |
| Hypervisor | VirtualBox |
| Domain Controller | DC01, Windows Server 2022 |
| Forest | corp.local |
| NetBIOS | CORP |
| Static IP | 10.0.2.10 |
| Cloud Tenant | Blocked (pending personal Entra tenant with Global Admin) |

## Purpose

This repo documents the build steps, configuration, and scripts for each lab. Each project README contains architecture, setup steps, screenshots, and interview notes.

## Progress Summary

| Phase | Status |
| :--- | :--- |
| On-prem Active Directory (Project 1) | Complete |
| JML Automation (Project 2) | Complete |
| Entra Connect / Cloud Sync (Project 1 Block 5) | Blocked — needs personal Entra ID tenant |
| Access Review (Project 3) | Not started |
| Zero Trust / Conditional Access (Project 4) | Blocked — needs Entra ID Global Admin |
| Graph API Hub (Project 5) | Not started |

## Notes

- Projects 1 and 2 are fully functional against the on-prem `corp.local` domain.
- Cloud-dependent tasks (Entra Connect, Conditional Access, PIM, Graph API) are blocked until a personal Microsoft Entra tenant with Global Administrator rights is available.
- All scripts use PowerShell 5.1 compatible syntax.
