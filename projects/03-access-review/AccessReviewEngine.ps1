Import-Module ActiveDirectory

$outDir = "C:\IAM-Lab\Reports"
$today  = Get-Date
$csvOut = "$outDir\AccessReview-$(Get-Date -Format 'yyyy-MM-dd').csv"
$findings = @()

function Add-Finding {
    param($User, $Check, $Detail, $Severity, $Control)
    $script:findings += [PSCustomObject]@{
        SamAccountName = $User.SamAccountName
        Name           = $User.Name
        Check          = $Check
        Detail         = $Detail
        Severity       = $Severity
        SOC2Control    = $Control
    }
}

$users = Get-ADUser -Filter * -Properties SamAccountName, Department, Enabled, LastLogonDate, MemberOf, DistinguishedName

foreach ($u in $users) {

    # Skip built-in system accounts
    if ($u.SamAccountName -in @("krbtgt","Guest")) { continue }

    # CHECK 1: Stale enabled account (no logon in 90+ days)
    if ($u.Enabled -and ($u.LastLogonDate -eq $null -or $u.LastLogonDate -lt $today.AddDays(-90))) {
        Add-Finding $u "StaleAccount" "No logon in 90+ days (LastLogon: $($u.LastLogonDate))" "Medium" "CC6.1"
    }

    # CHECK 2: Disabled account still in non-default groups
    if (-not $u.Enabled -and $u.MemberOf.Count -gt 0) {
        $nonDefault = $u.MemberOf | Where-Object { $_ -notlike "*CN=Domain Users,*" }
        if ($nonDefault.Count -gt 0) {
            Add-Finding $u "DisabledWithAccess" "Disabled but member of $($nonDefault.Count) group(s)" "High" "CC6.3"
        }
    }

    # CHECK 3: Privileged user (IT_Admins)
    if ($u.MemberOf -match "CN=IT_Admins,") {
        Add-Finding $u "PrivilegedUser" "Member of IT_Admins" "High" "CC6.1"
    }

    # CHECK 4: Orphaned account (enabled, no department)
    if ($u.Enabled -and [string]::IsNullOrWhiteSpace($u.Department)) {
        Add-Finding $u "OrphanedAccount" "Enabled with no Department attribute" "Medium" "CC6.2"
    }

    # CHECK 5: Non-default group memberships (inventory)
    $nonDefaultGroups = $u.MemberOf | Where-Object { $_ -notlike "*CN=Domain Users,*" }
    if ($nonDefaultGroups.Count -gt 0) {
        $groupNames = $nonDefaultGroups | ForEach-Object { ($_ -split ",")[0] -replace "CN=","" }
        Add-Finding $u "GroupMembership" "In groups: $($groupNames -join ', ')" "Info" "CC6.1"
    }
}

$findings | Export-Csv -Path $csvOut -NoTypeInformation

Write-Host ""
Write-Host "=== ACCESS REVIEW FINDINGS ===" -ForegroundColor Cyan
Write-Host ""
$findings | Format-Table SamAccountName, Check, Severity, SOC2Control -AutoSize

Write-Host "Total findings: $($findings.Count)" -ForegroundColor Yellow
Write-Host "CSV exported: $csvOut" -ForegroundColor Green
Import-Module ActiveDirectory

$outDir = "C:\IAM-Lab\Reports"
$today  = Get-Date
$csvOut = "$outDir\AccessReview-$(Get-Date -Format 'yyyy-MM-dd').csv"
$findings = @()

function Add-Finding {
    param($User, $Check, $Detail, $Severity, $Control)
    $script:findings += [PSCustomObject]@{
        SamAccountName = $User.SamAccountName
        Name           = $User.Name
        Check          = $Check
        Detail         = $Detail
        Severity       = $Severity
        SOC2Control    = $Control
    }
}

$users = Get-ADUser -Filter * -Properties SamAccountName, Department, Enabled, LastLogonDate, MemberOf, DistinguishedName

foreach ($u in $users) {

    # Skip built-in system accounts
    if ($u.SamAccountName -in @("krbtgt","Guest")) { continue }

    # CHECK 1: Stale enabled account (no logon in 90+ days)
    if ($u.Enabled -and ($u.LastLogonDate -eq $null -or $u.LastLogonDate -lt $today.AddDays(-90))) {
        Add-Finding $u "StaleAccount" "No logon in 90+ days (LastLogon: $($u.LastLogonDate))" "Medium" "CC6.1"
    }

    # CHECK 2: Disabled account still in non-default groups
    if (-not $u.Enabled -and $u.MemberOf.Count -gt 0) {
        $nonDefault = $u.MemberOf | Where-Object { $_ -notlike "*CN=Domain Users,*" }
        if ($nonDefault.Count -gt 0) {
            Add-Finding $u "DisabledWithAccess" "Disabled but member of $($nonDefault.Count) group(s)" "High" "CC6.3"
        }
    }

    # CHECK 3: Privileged user (IT_Admins)
    if ($u.MemberOf -match "CN=IT_Admins,") {
        Add-Finding $u "PrivilegedUser" "Member of IT_Admins" "High" "CC6.1"
    }

    # CHECK 4: Orphaned account (enabled, no department)
    if ($u.Enabled -and [string]::IsNullOrWhiteSpace($u.Department)) {
        Add-Finding $u "OrphanedAccount" "Enabled with no Department attribute" "Medium" "CC6.2"
    }

    # CHECK 5: Non-default group memberships (inventory)
    $nonDefaultGroups = $u.MemberOf | Where-Object { $_ -notlike "*CN=Domain Users,*" }
    if ($nonDefaultGroups.Count -gt 0) {
        $groupNames = $nonDefaultGroups | ForEach-Object { ($_ -split ",")[0] -replace "CN=","" }
        Add-Finding $u "GroupMembership" "In groups: $($groupNames -join ', ')" "Info" "CC6.1"
    }
}

$findings | Export-Csv -Path $csvOut -NoTypeInformation

Write-Host ""
Write-Host "=== ACCESS REVIEW FINDINGS ===" -ForegroundColor Cyan
Write-Host ""
$findings | Format-Table SamAccountName, Check, Severity, SOC2Control -AutoSize

Write-Host "Total findings: $($findings.Count)" -ForegroundColor Yellow
Write-Host "CSV exported: $csvOut" -ForegroundColor Green
