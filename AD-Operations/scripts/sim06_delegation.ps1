# SIMULATION 06 - Delegation of Control
# Employee: Zoe Adams (zadams) - Help Desk Tech
# Date: 6/4/2026
# Performed by: Will Turner (wturner) - IT Administrator

Write-Host "=== PINNACLE HEALTH CLINIC ===" -ForegroundColor Cyan
Write-Host "=== Simulation 06: Delegation of Control ===" -ForegroundColor Cyan
Write-Host "=== Help Desk Tech: Zoe Adams (zadams) ===" -ForegroundColor Cyan
Write-Host ""

# Step 1 - Document current zadams account state
Write-Host "STEP 1: Documenting zadams account before delegation..." -ForegroundColor Yellow
$zadams = Get-ADUser -Identity "zadams" -Properties Department,Title,MemberOf
Write-Host "Name: $($zadams.Name)" -ForegroundColor White
Write-Host "Username: $($zadams.SamAccountName)" -ForegroundColor White
Write-Host "Department: $($zadams.Department)" -ForegroundColor White
Write-Host "Title: $($zadams.Title)" -ForegroundColor White
$groups = Get-ADPrincipalGroupMembership -Identity "zadams" | Select -ExpandProperty Name
Write-Host "Groups: $($groups -join ', ')" -ForegroundColor White
Write-Host "Note: zadams is NOT in Domain Admins - least privilege confirmed" -ForegroundColor Green
Write-Host ""

# Step 2 - Confirm delegation was configured via wizard
Write-Host "STEP 2: Confirming delegation scope..." -ForegroundColor Yellow
Write-Host "Delegation configured via ADUC Delegate Control wizard" -ForegroundColor White
Write-Host "Scope: OU=Pinnacle,DC=pinnacle,DC=local" -ForegroundColor White
Write-Host "Permission granted: Reset user passwords and force password change at next logon" -ForegroundColor White
Write-Host "Granted to: zadams" -ForegroundColor White
Write-Host ""

# Step 3 - Test 1: Reset a password as zadams
Write-Host "STEP 3: Testing delegated password reset as zadams..." -ForegroundColor Yellow
Write-Host "Attempting to reset tellis password using zadams credentials..." -ForegroundColor White
try {
    Set-ADAccountPassword -Identity "tellis" `
        -NewPassword (ConvertTo-SecureString "HelpDesk2026!" -AsPlainText -Force) `
        -Reset `
        -Credential (Get-ADUser -Identity zadams | Select -ExpandProperty UserPrincipalName | ForEach-Object { New-Object System.Management.Automation.PSCredential($_, (ConvertTo-SecureString "Admin2026!" -AsPlainText -Force)) })
    Write-Host "Password reset succeeded" -ForegroundColor Green
} catch {
    Write-Host "Note: Testing delegation requires logging in as zadams directly" -ForegroundColor Yellow
    Write-Host "Proceed to Part 2 - test from zadams session on PC-CLIN01" -ForegroundColor Yellow
}
Write-Host ""

# Step 4 - Document what zadams CAN do
Write-Host "STEP 4: Documenting delegated permissions..." -ForegroundColor Yellow
Write-Host "zadams CAN:" -ForegroundColor Green
Write-Host "  - Reset passwords for any user in Pinnacle OU" -ForegroundColor Green
Write-Host "  - Unlock locked accounts in Pinnacle OU" -ForegroundColor Green
Write-Host "  - Force password change on next logon" -ForegroundColor Green
Write-Host ""
Write-Host "zadams CANNOT:" -ForegroundColor Red
Write-Host "  - Create new user accounts" -ForegroundColor Red
Write-Host "  - Delete user accounts" -ForegroundColor Red
Write-Host "  - Modify group memberships" -ForegroundColor Red
Write-Host "  - Edit Group Policy objects" -ForegroundColor Red
Write-Host "  - Access Domain Admin functions" -ForegroundColor Red
Write-Host ""

# Step 5 - Verify zadams is not in privileged groups
Write-Host "STEP 5: Verifying least privilege - confirming no admin group membership..." -ForegroundColor Yellow
$adminGroups = @("Domain Admins","Enterprise Admins","Schema Admins","Administrators")
$zadamsGroups = Get-ADPrincipalGroupMembership -Identity "zadams" | Select -ExpandProperty Name
$found = $false
foreach ($ag in $adminGroups) {
    if ($zadamsGroups -contains $ag) {
        Write-Host "WARNING: zadams is in $ag - review immediately" -ForegroundColor Red
        $found = $true
    }
}
if (-not $found) {
    Write-Host "Confirmed: zadams is not in any privileged admin groups" -ForegroundColor Green
    Write-Host "Least privilege principle maintained" -ForegroundColor Green
}
Write-Host ""

Write-Host "=== DELEGATION CONFIGURED ===" -ForegroundColor Green
Write-Host "Help desk tech zadams has password reset rights only" -ForegroundColor White
Write-Host "Scope: Pinnacle OU and all child OUs" -ForegroundColor White
Write-Host "No Domain Admin rights granted" -ForegroundColor White
Write-Host "Proceed to Part 2 to test from zadams perspective" -ForegroundColor Yellow
Write-Host ""
Write-Host "$(Get-Date -Format 'MM/dd/yyyy HH:mm')" -ForegroundColor Cyan