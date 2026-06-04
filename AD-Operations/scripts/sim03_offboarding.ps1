# SIMULATION 03 — Employee Offboarding
# Employee: Paula Scott (pscott) — Payment Processor, Billing
# Date: 6/3/2026
# Performed by: Will Turner (wturner) — IT Administrator
# Reason: Voluntary resignation

Write-Host "=== PINNACLE HEALTH CLINIC ===" -ForegroundColor Cyan
Write-Host "=== Simulation 03: Employee Offboarding ===" -ForegroundColor Cyan
Write-Host "=== Employee: Paula Scott (pscott) ===" -ForegroundColor Cyan
Write-Host ""

# Step 1 - Document current state before changes
Write-Host "STEP 1: Documenting current account state..." -ForegroundColor Yellow
$user = Get-ADUser -Identity "pscott" -Properties Department,Title,Enabled,DistinguishedName,LastLogonDate,MemberOf
Write-Host "Name: $($user.Name)" -ForegroundColor White
Write-Host "Username: $($user.SamAccountName)" -ForegroundColor White
Write-Host "Department: $($user.Department)" -ForegroundColor White
Write-Host "Title: $($user.Title)" -ForegroundColor White
Write-Host "Account Enabled: $($user.Enabled)" -ForegroundColor White
Write-Host "Last Logon: $($user.LastLogonDate)" -ForegroundColor White
Write-Host "OU: $($user.DistinguishedName)" -ForegroundColor White
Write-Host ""

# Step 2 - Document group memberships before removal
Write-Host "STEP 2: Documenting group memberships before removal..." -ForegroundColor Yellow
$groups = Get-ADPrincipalGroupMembership -Identity "pscott" | 
    Where-Object {$_.Name -ne "Domain Users"} | 
    Select-Object -ExpandProperty Name
Write-Host "Groups to remove: $($groups -join ', ')" -ForegroundColor White
Write-Host ""

# Step 3 - Disable account immediately
Write-Host "STEP 3: Disabling account..." -ForegroundColor Yellow
Disable-ADAccount -Identity "pscott"
$check = Get-ADUser -Identity "pscott" -Properties Enabled
Write-Host "Account Enabled: $($check.Enabled)" -ForegroundColor White
if ($check.Enabled -eq $false) {
    Write-Host "Account disabled successfully" -ForegroundColor Green
}
Write-Host ""

# Step 4 - Remove from all security groups
Write-Host "STEP 4: Removing from all security groups..." -ForegroundColor Yellow
foreach ($group in $groups) {
    Remove-ADGroupMember -Identity $group -Members "pscott" -Confirm:$false
    Write-Host "Removed from: $group" -ForegroundColor Green
}
Write-Host ""

# Step 5 - Verify group removal
Write-Host "STEP 5: Verifying group removal..." -ForegroundColor Yellow
$remaining = Get-ADPrincipalGroupMembership -Identity "pscott" | 
    Select-Object -ExpandProperty Name
Write-Host "Remaining groups: $($remaining -join ', ')" -ForegroundColor White
Write-Host ""

# Step 6 - Move account to disabled users OU
Write-Host "STEP 6: Moving account to disabled state documentation..." -ForegroundColor Yellow
Set-ADUser -Identity "pscott" -Description "DISABLED - Resigned 06/03/2026 - Offboarded by wturner"
Write-Host "Account description updated with offboard date" -ForegroundColor Green
Write-Host ""

# Step 7 - Reset password to prevent any access
Write-Host "STEP 7: Resetting password to prevent unauthorized access..." -ForegroundColor Yellow
$newPass = ConvertTo-SecureString "Offboard@$(Get-Date -Format 'MMddyyyy')!" -AsPlainText -Force
Set-ADAccountPassword -Identity "pscott" -NewPassword $newPass -Reset
Write-Host "Password reset — access revoked" -ForegroundColor Green
Write-Host ""

# Step 8 - Create archive record
Write-Host "STEP 8: Documenting archive requirements..." -ForegroundColor Yellow
Write-Host "Data locations to archive:" -ForegroundColor White
Write-Host "  - Home folder: \\SRV-DC01\Billing\pscott" -ForegroundColor Gray
Write-Host "  - Desktop files on PC-BILL04" -ForegroundColor Gray
Write-Host "  - Email archive: contact Exchange admin" -ForegroundColor Gray
Write-Host "  - Shared billing documents: confirm with manager dfoster" -ForegroundColor Gray
Write-Host ""

# Final verification
Write-Host "=== OFFBOARDING VERIFICATION ===" -ForegroundColor Yellow
$final = Get-ADUser -Identity "pscott" -Properties Enabled,Description,MemberOf
Write-Host "Account Enabled: $($final.Enabled)" -ForegroundColor White
Write-Host "Description: $($final.Description)" -ForegroundColor White
$finalGroups = Get-ADPrincipalGroupMembership -Identity "pscott" | Select -ExpandProperty Name
Write-Host "Groups remaining: $($finalGroups -join ', ')" -ForegroundColor White
Write-Host ""

Write-Host "=== OFFBOARDING COMPLETE ===" -ForegroundColor Green
Write-Host "Employee: Paula Scott (pscott)" -ForegroundColor White
Write-Host "Account disabled: Yes" -ForegroundColor White
Write-Host "Groups removed: $($groups -join ', ')" -ForegroundColor White
Write-Host "Password reset: Yes" -ForegroundColor White
Write-Host "Description updated: Yes" -ForegroundColor White
Write-Host "Archive follow-up: Required — see Step 8" -ForegroundColor Yellow
Write-Host ""
Write-Host "Ticket closed: $(Get-Date -Format 'MM/dd/yyyy HH:mm')" -ForegroundColor Cyan
Write-Host "NOTE: Account retained for 30 days before permanent deletion per policy" -ForegroundColor Yellow