Import-Module ActiveDirectory

$csv = Import-Csv "C:\IAM-Lab\HR-Feed\employees.csv"
$log = "C:\IAM-Lab\Logs\JML-$(Get-Date -Format "yyyy-MM-dd").log"

foreach ($row in $csv) {
    $sam = ($row.FirstName.Substring(0,1) + $row.LastName).ToLower()
    $upn = "$sam@corp.local"

    if ($row.Department -eq "IT") { $ou = "OU=IT,OU=Employees,DC=corp,DC=local" }
    elseif ($row.Department -eq "HR") { $ou = "OU=HR,OU=Employees,DC=corp,DC=local" }
    else { $ou = "OU=Employees,DC=corp,DC=local" }

    if ($row.Action -eq "Joiner") {
        try {
            if (Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue) {
                "$(Get-Date) - JOINER SKIP: $sam already exists" | Add-Content $log
                Write-Host "SKIP: $sam already exists" -ForegroundColor DarkGray
            } else {
                New-ADUser -Name "$($row.FirstName) $($row.LastName)" -SamAccountName $sam -UserPrincipalName $upn -Department $row.Department -Title $row.Title -Path $ou -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) -Enabled $true -ErrorAction Stop
                "$(Get-Date) - JOINER: Created $sam in $ou" | Add-Content $log
                Write-Host "JOINER: Created $sam" -ForegroundColor Green
            }
        } catch {
            "$(Get-Date) - JOINER FAILED: $sam - $($_.Exception.Message)" | Add-Content $log
            Write-Host "FAILED: $sam - $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    if ($row.Action -eq "Mover") {
        try {
            $user = Get-ADUser -Identity $sam -ErrorAction Stop
            Set-ADUser -Identity $sam -Department $row.Department -Title $row.Title -ErrorAction Stop
            Get-ADPrincipalGroupMembership -Identity $sam | Where-Object { $_.Name -ne "Domain Users" } | ForEach-Object { Remove-ADGroupMember -Identity $_ -Members $sam -Confirm:$false }
            if ($row.Department -eq "IT") { Add-ADGroupMember -Identity "IT_Admins" -Members $sam }
            elseif ($row.Department -eq "HR") { Add-ADGroupMember -Identity "HR_Users" -Members $sam }
            Move-ADObject -Identity $user.DistinguishedName -TargetPath $ou
            "$(Get-Date) - MOVER: $sam moved to $ou, department $($row.Department)" | Add-Content $log
            Write-Host "MOVER: $sam -> $($row.Department)" -ForegroundColor Yellow
        } catch {
            "$(Get-Date) - MOVER FAILED: $sam - $($_.Exception.Message)" | Add-Content $log
            Write-Host "FAILED: $sam - $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    if ($row.Action -eq "Leaver") {
        try {
            Disable-ADAccount -Identity $sam -ErrorAction Stop
            Set-ADUser -Identity $sam -Description "Disabled $(Get-Date -Format yyyy-MM-dd)" -ErrorAction Stop
            Get-ADPrincipalGroupMembership -Identity $sam | Where-Object { $_.Name -ne "Domain Users" } | ForEach-Object { Remove-ADGroupMember -Identity $_ -Members $sam -Confirm:$false }
            "$(Get-Date) - LEAVER: Disabled $sam, removed from all groups" | Add-Content $log
            Write-Host "LEAVER: Disabled $sam" -ForegroundColor Magenta
        } catch {
            "$(Get-Date) - LEAVER FAILED: $sam - $($_.Exception.Message)" | Add-Content $log
            Write-Host "FAILED: $sam - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}
Import-Module ActiveDirectory

$csv = Import-Csv "C:\IAM-Lab\HR-Feed\employees.csv"
$log = "C:\IAM-Lab\Logs\JML-$(Get-Date -Format "yyyy-MM-dd").log"

foreach ($row in $csv) {
    $sam = ($row.FirstName.Substring(0,1) + $row.LastName).ToLower()
    $upn = "$sam@corp.local"

    if ($row.Department -eq "IT") { $ou = "OU=IT,OU=Employees,DC=corp,DC=local" }
    elseif ($row.Department -eq "HR") { $ou = "OU=HR,OU=Employees,DC=corp,DC=local" }
    else { $ou = "OU=Employees,DC=corp,DC=local" }

    if ($row.Action -eq "Joiner") {
        try {
            if (Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue) {
                "$(Get-Date) - JOINER SKIP: $sam already exists" | Add-Content $log
                Write-Host "SKIP: $sam already exists" -ForegroundColor DarkGray
            } else {
                New-ADUser -Name "$($row.FirstName) $($row.LastName)" -SamAccountName $sam -UserPrincipalName $upn -Department $row.Department -Title $row.Title -Path $ou -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) -Enabled $true -ErrorAction Stop
                "$(Get-Date) - JOINER: Created $sam in $ou" | Add-Content $log
                Write-Host "JOINER: Created $sam" -ForegroundColor Green
            }
        } catch {
            "$(Get-Date) - JOINER FAILED: $sam - $($_.Exception.Message)" | Add-Content $log
            Write-Host "FAILED: $sam - $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    if ($row.Action -eq "Mover") {
        try {
            $user = Get-ADUser -Identity $sam -ErrorAction Stop
            Set-ADUser -Identity $sam -Department $row.Department -Title $row.Title -ErrorAction Stop
            Get-ADPrincipalGroupMembership -Identity $sam | Where-Object { $_.Name -ne "Domain Users" } | ForEach-Object { Remove-ADGroupMember -Identity $_ -Members $sam -Confirm:$false }
            if ($row.Department -eq "IT") { Add-ADGroupMember -Identity "IT_Admins" -Members $sam }
            elseif ($row.Department -eq "HR") { Add-ADGroupMember -Identity "HR_Users" -Members $sam }
            Move-ADObject -Identity $user.DistinguishedName -TargetPath $ou
            "$(Get-Date) - MOVER: $sam moved to $ou, department $($row.Department)" | Add-Content $log
            Write-Host "MOVER: $sam -> $($row.Department)" -ForegroundColor Yellow
        } catch {
            "$(Get-Date) - MOVER FAILED: $sam - $($_.Exception.Message)" | Add-Content $log
            Write-Host "FAILED: $sam - $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    if ($row.Action -eq "Leaver") {
        try {
            Disable-ADAccount -Identity $sam -ErrorAction Stop
            Set-ADUser -Identity $sam -Description "Disabled $(Get-Date -Format yyyy-MM-dd)" -ErrorAction Stop
            Get-ADPrincipalGroupMembership -Identity $sam | Where-Object { $_.Name -ne "Domain Users" } | ForEach-Object { Remove-ADGroupMember -Identity $_ -Members $sam -Confirm:$false }
            "$(Get-Date) - LEAVER: Disabled $sam, removed from all groups" | Add-Content $log
            Write-Host "LEAVER: Disabled $sam" -ForegroundColor Magenta
        } catch {
            "$(Get-Date) - LEAVER FAILED: $sam - $($_.Exception.Message)" | Add-Content $log
            Write-Host "FAILED: $sam - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}
