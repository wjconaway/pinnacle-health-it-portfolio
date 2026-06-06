# SIMULATION 07 - Computer Reassignment
# Workstation: PC-CLIN01 (representing PC-ADMIN01 in scenario)
# Previous user: Rachel Green (rgreen)
# New user: Nina Torres (ntorres)
# Date: 6/5/2026
# Performed by: Will Turner (wturner) - IT Administrator

Write-Host "=== PINNACLE HEALTH CLINIC ===" -ForegroundColor Cyan
Write-Host "=== Simulation 07: Computer Reassignment ===" -ForegroundColor Cyan
Write-Host "=== PC-CLIN01 - rgreen to ntorres ===" -ForegroundColor Cyan
Write-Host ""

# Step 1 - Document current computer state
Write-Host "STEP 1: Documenting current computer state..." -ForegroundColor Yellow
$computer = Get-ADComputer -Identity "PC-CLIN01" -Properties Description,DistinguishedName,LastLogonDate
Write-Host "Computer Name: $($computer.Name)" -ForegroundColor White
Write-Host "Current Description: $($computer.Description)" -ForegroundColor White
Write-Host "OU: $($computer.DistinguishedName)" -ForegroundColor White
Write-Host "Last Logon: $($computer.LastLogonDate)" -ForegroundColor White
Write-Host ""

# Step 2 - Document previous user account
Write-Host "STEP 2: Documenting previous assigned user..." -ForegroundColor Yellow
$oldUser = Get-ADUser -Identity "rgreen" -Properties Department,Title,Enabled
Write-Host "Previous User: $($oldUser.Name)" -ForegroundColor White
Write-Host "Username: $($oldUser.SamAccountName)" -ForegroundColor White
Write-Host "Department: $($oldUser.Department)" -ForegroundColor White
Write-Host "Title: $($oldUser.Title)" -ForegroundColor White
Write-Host "Account Enabled: $($oldUser.Enabled)" -ForegroundColor White
Write-Host ""

# Step 3 - Document new user account
Write-Host "STEP 3: Documenting new assigned user..." -ForegroundColor Yellow
$newUser = Get-ADUser -Identity "ntorres" -Properties Department,Title,Enabled
Write-Host "New User: $($newUser.Name)" -ForegroundColor White
Write-Host "Username: $($newUser.SamAccountName)" -ForegroundColor White
Write-Host "Department: $($newUser.Department)" -ForegroundColor White
Write-Host "Title: $($newUser.Title)" -ForegroundColor White
Write-Host "Account Enabled: $($newUser.Enabled)" -ForegroundColor White
Write-Host ""

# Step 4 - Verify new user is in correct OU for GPO
Write-Host "STEP 4: Verifying ntorres OU placement and group membership..." -ForegroundColor Yellow
$ntorres = Get-ADUser -Identity "ntorres" -Properties DistinguishedName
Write-Host "OU: $($ntorres.DistinguishedName)" -ForegroundColor White
$groups = Get-ADPrincipalGroupMembership -Identity "ntorres" | Select -ExpandProperty Name
Write-Host "Groups: $($groups -join ', ')" -ForegroundColor White
Write-Host ""

# Step 5 - Update computer description in AD
Write-Host "STEP 5: Updating computer account description in AD..." -ForegroundColor Yellow
Set-ADComputer -Identity "PC-CLIN01" -Description "Assigned to ntorres (Nina Torres) - Reassigned 06/05/2026 - Previously rgreen"
$verify = Get-ADComputer -Identity "PC-CLIN01" -Properties Description
Write-Host "Updated Description: $($verify.Description)" -ForegroundColor Green
Write-Host ""

# Step 6 - Verify computer is in correct OU
Write-Host "STEP 6: Verifying PC-CLIN01 OU placement..." -ForegroundColor Yellow
$comp = Get-ADComputer -Identity "PC-CLIN01" -Properties DistinguishedName
Write-Host "Computer OU: $($comp.DistinguishedName)" -ForegroundColor White
if ($comp.DistinguishedName -like "*OU=Clinical*") {
    Write-Host "Computer is in Clinical Computers OU - correct" -ForegroundColor Green
} else {
    Write-Host "Computer is not in expected OU - review placement" -ForegroundColor Red
}
Write-Host ""

# Step 7 - Document profile removal requirement
Write-Host "STEP 7: Profile removal documentation..." -ForegroundColor Yellow
Write-Host "Action required on PC-CLIN01:" -ForegroundColor White
Write-Host "  1. Log into PC-CLIN01 as PINNACLE\Administrator" -ForegroundColor Gray
Write-Host "  2. System Properties - Advanced - User Profiles - Settings" -ForegroundColor Gray
Write-Host "  3. Select rgreen profile and delete it" -ForegroundColor Gray
Write-Host "  4. Confirm deletion to reclaim disk space" -ForegroundColor Gray
Write-Host "  5. Log in as ntorres to create fresh profile" -ForegroundColor Gray
Write-Host ""

# Step 8 - Asset record documentation
Write-Host "STEP 8: Asset record update..." -ForegroundColor Yellow
Write-Host "Asset record updated:" -ForegroundColor White
Write-Host "  Machine: PC-CLIN01" -ForegroundColor Gray
Write-Host "  Previous user: Rachel Green (rgreen)" -ForegroundColor Gray
Write-Host "  New user: Nina Torres (ntorres)" -ForegroundColor Gray
Write-Host "  Reassignment date: 06/05/2026" -ForegroundColor Gray
Write-Host "  Performed by: Will Turner (wturner)" -ForegroundColor Gray
Write-Host ""

Write-Host "=== REASSIGNMENT DOCUMENTATION COMPLETE ===" -ForegroundColor Green
Write-Host "AD computer description updated" -ForegroundColor White
Write-Host "New user OU and group membership verified" -ForegroundColor White
Write-Host "Profile removal to be completed on workstation" -ForegroundColor Yellow
Write-Host "Asset record updated" -ForegroundColor White
Write-Host ""
Write-Host "Ticket closed: $(Get-Date -Format 'MM/dd/yyyy HH:mm')" -ForegroundColor Cyan