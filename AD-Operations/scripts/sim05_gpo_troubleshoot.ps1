# SIMULATION 05 - GPO Troubleshooting
# Employee: Dr. Maria Lopez (mlopez) - Physician, Clinical
# Issue: Clinical_Policy GPO not applying
# Date: 6/3/2026
# Performed by: Zoe Adams (zadams) - Help Desk Tech

Write-Host "=== PINNACLE HEALTH CLINIC ===" -ForegroundColor Cyan
Write-Host "=== Simulation 05: GPO Troubleshooting ===" -ForegroundColor Cyan
Write-Host "=== Employee: Dr. Maria Lopez (mlopez) ===" -ForegroundColor Cyan
Write-Host ""

# Step 1 - Document the complaint
Write-Host "STEP 1: Documenting reported issue..." -ForegroundColor Yellow
Write-Host "User reports: Can access Control Panel on PC-CLIN01" -ForegroundColor White
Write-Host "Expected behavior: Clinical_Policy should block Control Panel access" -ForegroundColor White
Write-Host "Impact: HIPAA concern - unrestricted system access on clinical workstation" -ForegroundColor White
Write-Host ""

# Step 2 - Check current OU placement
Write-Host "STEP 2: Checking OU placement for mlopez..." -ForegroundColor Yellow
$user = Get-ADUser -Identity "mlopez" -Properties DistinguishedName,Department
Write-Host "Current OU: $($user.DistinguishedName)" -ForegroundColor White
Write-Host "Department: $($user.Department)" -ForegroundColor White
Write-Host ""

# Step 3 - Check what GPOs are linked to current OU
Write-Host "STEP 3: Checking GPOs linked to current OU location..." -ForegroundColor Yellow
$ouPath = ($user.DistinguishedName -split ",",2)[1]
Write-Host "Checking inheritance at: $ouPath" -ForegroundColor White
$inheritance = Get-GPInheritance -Target $ouPath
$links = $inheritance.GpoLinks | Select -ExpandProperty DisplayName
if ($links) {
    Write-Host "GPOs at current location: $($links -join ', ')" -ForegroundColor White
} else {
    Write-Host "No GPOs linked at current OU location" -ForegroundColor Red
    Write-Host "ROOT CAUSE IDENTIFIED: mlopez is not in the Clinical OU" -ForegroundColor Red
}
Write-Host ""

# Step 4 - Confirm correct OU
Write-Host "STEP 4: Confirming correct OU for Clinical staff..." -ForegroundColor Yellow
$clinicalOU = "OU=Users,OU=Clinical,OU=Pinnacle,DC=pinnacle,DC=local"
Write-Host "Correct OU: $clinicalOU" -ForegroundColor White
$clinicalGPO = Get-GPInheritance -Target "OU=Clinical,OU=Pinnacle,DC=pinnacle,DC=local"
$clinicalLinks = $clinicalGPO.GpoLinks | Select -ExpandProperty DisplayName
Write-Host "GPOs linked to Clinical OU: $($clinicalLinks -join ', ')" -ForegroundColor Green
Write-Host ""

# Step 5 - Fix - move mlopez back to correct OU
Write-Host "STEP 5: Moving mlopez to correct Clinical Users OU..." -ForegroundColor Yellow
Move-ADObject `
    -Identity "CN=Maria Lopez,OU=Pinnacle,DC=pinnacle,DC=local" `
    -TargetPath $clinicalOU
Write-Host "mlopez moved to Clinical Users OU" -ForegroundColor Green
Write-Host ""

# Step 6 - Verify new OU placement
Write-Host "STEP 6: Verifying corrected OU placement..." -ForegroundColor Yellow
$verify = Get-ADUser -Identity "mlopez" -Properties DistinguishedName
Write-Host "New OU: $($verify.DistinguishedName)" -ForegroundColor White
if ($verify.DistinguishedName -like "*OU=Clinical*") {
    Write-Host "OU placement confirmed correct" -ForegroundColor Green
}
Write-Host ""

# Step 7 - Instruct gpupdate on client
Write-Host "STEP 7: Policy refresh required on PC-CLIN01..." -ForegroundColor Yellow
Write-Host "Action: Log into PC-CLIN01 as mlopez and run: gpupdate /force" -ForegroundColor White
Write-Host "Then verify with: gpresult /r" -ForegroundColor White
Write-Host "Confirm Clinical_Policy appears under Applied GPOs" -ForegroundColor White
Write-Host ""

# Summary
Write-Host "=== GPO TROUBLESHOOTING COMPLETE ===" -ForegroundColor Green
Write-Host "Root cause: mlopez was in wrong OU - Clinical_Policy did not apply" -ForegroundColor White
Write-Host "Fix: Moved mlopez to OU=Users,OU=Clinical,OU=Pinnacle" -ForegroundColor White
Write-Host "Verification: gpupdate /force on PC-CLIN01 required to confirm" -ForegroundColor White
Write-Host "HIPAA note: Clinical workstation was unrestricted during the gap period" -ForegroundColor Yellow
Write-Host ""
Write-Host "Ticket closed: $(Get-Date -Format 'MM/dd/yyyy HH:mm')" -ForegroundColor Cyan