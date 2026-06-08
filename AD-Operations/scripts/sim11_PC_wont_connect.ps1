# SIMULATION 11 - New Hire Onboarding
# Employee: Marcus Webb (mwebb)
# Department: Admin
# Date: 6/7/2026
# Performed by: Will Turner (wturner) - IT Administrator

Write-Host "=== PINNACLE HEALTH CLINIC ===" -ForegroundColor Cyan
Write-Host "=== Simulation 11: New Hire Onboarding ===" -ForegroundColor Cyan
Write-Host "=== Employee: Marcus Webb (mwebb) ===" -ForegroundColor Cyan
Write-Host ""

# Step 1 - Create the AD account
Write-Host "STEP 1: Creating AD account for Marcus Webb..." -ForegroundColor Yellow
$password = ConvertTo-SecureString "Pinnacle2024!" -AsPlainText -Force
New-ADUser `
    -SamAccountName "mwebb" `
    -UserPrincipalName "mwebb@pinnacle.local" `
    -GivenName "Marcus" `
    -Surname "Webb" `
    -Name "Marcus Webb" `
    -DisplayName "Marcus Webb" `
    -Department "Admin" `
    -Title "Administrative Staff" `
    -Path "OU=Users,OU=Admin,OU=Pinnacle,DC=pinnacle,DC=local" `
    -AccountPassword $password `
    -Enabled $true `
    -ChangePasswordAtLogon $true
Write-Host "Account created: mwebb" -ForegroundColor White
Write-Host ""

# Step 2 - Add to Admin group
Write-Host "STEP 2: Adding mwebb to Admin_Staff group..." -ForegroundColor Yellow
Add-ADGroupMember -Identity "Admin_Staff" -Members "mwebb"
Write-Host "Added to Admin_Staff group" -ForegroundColor White
Write-Host ""

# Step 3 - Verify account exists and is in correct OU
Write-Host "STEP 3: Verifying AD account..." -ForegroundColor Yellow
$user = Get-ADUser -Identity "mwebb" -Properties Department,Title,DistinguishedName,Enabled,MemberOf
Write-Host "Name: $($user.Name)" -ForegroundColor White
Write-Host "Username: $($user.SamAccountName)" -ForegroundColor White
Write-Host "Department: $($user.Department)" -ForegroundColor White
Write-Host "Title: $($user.Title)" -ForegroundColor White
Write-Host "Enabled: $($user.Enabled)" -ForegroundColor White
Write-Host "OU: $($user.DistinguishedName)" -ForegroundColor White
Write-Host ""

# Step 4 - Verify group membership
Write-Host "STEP 4: Verifying group membership..." -ForegroundColor Yellow
$groups = Get-ADPrincipalGroupMembership -Identity "mwebb" | Select-Object -ExpandProperty Name
Write-Host "Groups: $($groups -join ', ')" -ForegroundColor White
Write-Host ""

# Step 5 - Verify Admin_Policy GPO linked to Admin OU
Write-Host "STEP 5: Verifying Admin_Policy GPO linked to Admin OU..." -ForegroundColor Yellow
$gpo = Get-GPInheritance -Target "OU=Users,OU=Admin,OU=Pinnacle,DC=pinnacle,DC=local"
$links = $gpo.GpoLinks | Select-Object -ExpandProperty DisplayName
Write-Host "GPOs applied to Admin OU: $($links -join ', ')" -ForegroundColor White
Write-Host ""

# Step 6 - Confirm account ready for first login
Write-Host "STEP 6: Confirming account ready for first login..." -ForegroundColor Yellow
Enable-ADAccount -Identity "mwebb"
Set-ADUser -Identity "mwebb" -ChangePasswordAtLogon $true
Write-Host "Account enabled and set to require password change on first login" -ForegroundColor White
Write-Host ""

# Summary
Write-Host "=== ONBOARDING COMPLETE ===" -ForegroundColor Green
Write-Host "mwebb is ready to log into Admin workstation" -ForegroundColor Green
Write-Host "Instruct Marcus Webb to log in with temporary password: Pinnacle2024!" -ForegroundColor Green
Write-Host "He will be prompted to set a new password on first login." -ForegroundColor Green
Write-Host ""
Write-Host "NOTE: PC has been assigned to Admin VLAN (VLAN 20) - verify network" -ForegroundColor Yellow
Write-Host "connectivity after first login. Escalate to NOC if PC cannot reach" -ForegroundColor Yellow
Write-Host "shared drives or scheduling system." -ForegroundColor Yellow
Write-Host ""
Write-Host "Ticket closed: $(Get-Date -Format 'MM/dd/yyyy HH:mm')" -ForegroundColor Cyan