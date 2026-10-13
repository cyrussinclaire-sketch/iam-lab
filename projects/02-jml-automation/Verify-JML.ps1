$ScriptPath = "C:\IAM-Lab\JML\JML-Automation.ps1"
$FeedPath   = "C:\IAM-Lab\HR-Feed\employees.csv"
$Script:Passed = 0
$Script:Failed = 0

function Test-Result {
    param([string]$Name, [bool]$Result)
    if ($Result) { Write-Host "[PASS] $Name" -ForegroundColor Green; $Script:Passed++ }
    else         { Write-Host "[FAIL] $Name" -ForegroundColor Red;   $Script:Failed++ }
}

function Remove-TestUser {
    param([string]$Sam)
    Get-ADUser -Filter "SamAccountName -eq '$Sam'" | Remove-ADUser -Confirm:$false
}

function Invoke-JML {
    param([string]$Csv)
    Set-Content -Path $FeedPath -Value $Csv -Encoding UTF8 -Force
    Start-Sleep -Milliseconds 500
    & powershell.exe -ExecutionPolicy Bypass -File $ScriptPath | Out-Null
    Start-Sleep -Seconds 3
}

Clear-Host
Write-Host "=== JML Automation Verification ===" -ForegroundColor Cyan
Write-Host ""

Test-Result "Script file exists" (Test-Path $ScriptPath)
Test-Result "HR feed exists" (Test-Path $FeedPath)

Remove-TestUser "tsmith"
Invoke-JML "FirstName,LastName,Department,Title,Action`nTest,Smith,IT,QA Analyst,Joiner"
$u = Get-ADUser -Filter "SamAccountName -eq 'tsmith'" -Properties Department
Test-Result "Joiner created tsmith" ($u -ne $null)
Test-Result "Joiner placed in IT OU" ($u.DistinguishedName -like "*OU=IT,OU=Employees,DC=corp,DC=local")
Test-Result "Joiner set Department=IT" ($u.Department -eq "IT")
Test-Result "Joiner enabled account" ($u.Enabled -eq $true)
Remove-TestUser "tsmith"

Remove-TestUser "tmover"
New-ADUser -Name "Test Mover" -SamAccountName "tmover" -UserPrincipalName "tmover@corp.local" -Path "OU=IT,OU=Employees,DC=corp,DC=local" -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) -Enabled $true
Add-ADGroupMember -Identity "IT_Admins" -Members "tmover"
Invoke-JML "FirstName,LastName,Department,Title,Action`nTest,Mover,HR,HR Analyst,Mover"
$u = Get-ADUser -Filter "SamAccountName -eq 'tmover'" -Properties Department
Test-Result "Mover moved to HR OU" ($u.DistinguishedName -like "*OU=HR,OU=Employees,DC=corp,DC=local")
Test-Result "Mover updated Department=HR" ($u.Department -eq "HR")
$members = Get-ADGroupMember -Identity "IT_Admins" | Select-Object -ExpandProperty SamAccountName
Test-Result "Mover removed from IT_Admins" ($members -notcontains "tmover")
Remove-TestUser "tmover"

Remove-TestUser "tleaver"
New-ADUser -Name "Test Leaver" -SamAccountName "tleaver" -UserPrincipalName "tleaver@corp.local" -Path "OU=IT,OU=Employees,DC=corp,DC=local" -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) -Enabled $true
Add-ADGroupMember -Identity "IT_Admins" -Members "tleaver"
Invoke-JML "FirstName,LastName,Department,Title,Action`nTest,Leaver,IT,Engineer,Leaver"
$u = Get-ADUser -Filter "SamAccountName -eq 'tleaver'" -Properties Description
Test-Result "Leaver disabled account" ($u.Enabled -eq $false)
Test-Result "Leaver set Description" ($u.Description -like "Disabled *")
$members = Get-ADGroupMember -Identity "IT_Admins" | Select-Object -ExpandProperty SamAccountName
Test-Result "Leaver removed from IT_Admins" ($members -notcontains "tleaver")
Remove-TestUser "tleaver"

try {
    Invoke-JML "FirstName,LastName,Department,Title,Action`nJohn,Smith,IT,Help Desk Analyst,Joiner"
    Test-Result "Duplicate Joiner does not crash" $true
} catch {
    Test-Result "Duplicate Joiner does not crash" $false
}

Write-Host ""
Write-Host "=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Passed: $Script:Passed" -ForegroundColor Green
Write-Host "Failed: $Script:Failed" -ForegroundColor Red

@"
FirstName,LastName,Department,Title,Action
John,Smith,IT,Help Desk Analyst,Joiner
Jane,Doe,HR,HR Generalist,Joiner
Mark,Johnson,IT,Systems Engineer,Joiner
Sarah,Williams,HR,HR Manager,Mover
David,Brown,IT,IT Manager,Leaver
"@ | Out-File $FeedPath -Encoding UTF8

Write-Host ""
Write-Host "HR feed restored."
