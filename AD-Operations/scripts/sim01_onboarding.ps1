# SIMULATION 01 - New Hire Onboarding
# Employee: Dr. James Carter (jcarter)
# Department: Clinical
# Date: 6/3/2026
# Performed by: Will Turner (wturner) - IT Administrator

Write-Host "=== PINNACLE HEALTH CLINIC ===" -ForegroundColor Cyan
Write-Host "=== Simulation 01: New Hire Onboarding ===" -ForegroundColor Cyan
Write-Host "=== Employee: Dr. James Carter (jcarter) ===" -ForegroundColor Cyan
Write-Host ""

# Step 1 - Verify account exists and is in correct OU
Write-Host "STEP 1: Verifying AD account..." -ForegroundColor Yellow
$user = Get-ADUser -Identity "jcarter" -Properties Department,Title,DistinguishedName,Enabled,MemberOf
Write-Host "Name: $($user.Name)" -ForegroundColor White
Write-Host "Username: $($user.SamAccountName)" -ForegroundColor White
Write-Host "Department: $($user.Department)" -ForegroundColor White
Write-Host "Title: $($user.Title)" -ForegroundColor White
Write-Host "Enabled: $($user.Enabled)" -ForegroundColor White
Write-Host "OU: $($user.DistinguishedName)" -ForegroundColor White
Write-Host ""

# Step 2 - Verify group membership
Write-Host "STEP 2: Verifying group membership..." -ForegroundColor Yellow
$groups = Get-ADPrincipalGroupMembership -Identity "jcarter" | Select-Object -ExpandProperty Name
Write-Host "Groups: $($groups -join ', ')" -ForegroundColor White
Write-Host ""

# Step 3 - Verify computer account exists in correct OU
Write-Host "STEP 3: Verifying PC-CLIN01 in Clinical Computers OU..." -ForegroundColor Yellow
$computer = Get-ADComputer -Identity "PC-CLIN01" | Select Name,DistinguishedName
Write-Host "Computer: $($computer.Name)" -ForegroundColor White
Write-Host "OU: $($computer.DistinguishedName)" -ForegroundColor White
Write-Host ""

# Step 4 - Verify GPO linked to Clinical OU
Write-Host "STEP 4: Verifying Clinical_Policy GPO linked..." -ForegroundColor Yellow
$gpo = Get-GPInheritance -Target "OU=Clinical,OU=Pinnacle,DC=pinnacle,DC=local"
$links = $gpo.GpoLinks | Select-Object -ExpandProperty DisplayName
Write-Host "GPOs applied to Clinical OU: $($links -join ', ')" -ForegroundColor White
Write-Host ""

# Step 5 - Unlock account and set password ready for first login
Write-Host "STEP 5: Preparing account for first login..." -ForegroundColor Yellow
Enable-ADAccount -Identity "jcarter"
Set-ADUser -Identity "jcarter" -ChangePasswordAtLogon $true
Write-Host "Account enabled and set to require password change on first login" -ForegroundColor White
Write-Host ""

# Summary
Write-Host "=== ONBOARDING VERIFICATION COMPLETE ===" -ForegroundColor Green
Write-Host "jcarter is ready to log into PC-CLIN01" -ForegroundColor Green
Write-Host "Instruct Dr. Carter to log in with temporary password: Pinnacle2024!" -ForegroundColor Green
Write-Host "He will be prompted to set a new password on first login." -ForegroundColor Green
Write-Host ""
Write-Host "Ticket closed: $(Get-Date -Format 'MM/dd/yyyy HH:mm')" -ForegroundColor Cyan
