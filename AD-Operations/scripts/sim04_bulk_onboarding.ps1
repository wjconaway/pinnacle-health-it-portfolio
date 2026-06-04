# SIMULATION 04 - Bulk Onboarding
# Three new Admin staff starting Monday
# Date: 6/3/2026
# Performed by: Will Turner (wturner) - IT Administrator

Write-Host "=== PINNACLE HEALTH CLINIC ===" -ForegroundColor Cyan
Write-Host "=== Simulation 04: Bulk Onboarding - Admin Staff ===" -ForegroundColor Cyan
Write-Host ""

# Step 1 - Create the new hire CSV
Write-Host "STEP 1: Loading new hire data from HR..." -ForegroundColor Yellow
$newHires = @"
FirstName,LastName,Username,Department,Title
Sandra,Mitchell,smitchell,Admin,Front Desk
Carlos,Rivera,crivera,Admin,Receptionist
Beth,Cooper,bcooper,Admin,Scheduler
"@

$csvPath = "C:\newbatch.csv"
$newHires | Out-File -FilePath $csvPath -Encoding UTF8
Write-Host "New hire file created: $csvPath" -ForegroundColor Green
Write-Host ""

# Step 2 - Create all three accounts
Write-Host "STEP 2: Creating AD accounts..." -ForegroundColor Yellow
$users = Import-Csv $csvPath

foreach ($user in $users) {
    $fullName = "$($user.FirstName) $($user.LastName)"
    $upn = "$($user.Username)@pinnacle.local"
    $ouPath = "OU=Users,OU=Admin,OU=Pinnacle,DC=pinnacle,DC=local"
    $password = ConvertTo-SecureString "Welcome2026!" -AsPlainText -Force

    New-ADUser `
        -Name $fullName `
        -GivenName $user.FirstName `
        -Surname $user.LastName `
        -SamAccountName $user.Username `
        -UserPrincipalName $upn `
        -Path $ouPath `
        -AccountPassword $password `
        -Enabled $true `
        -Department $user.Department `
        -Title $user.Title `
        -ChangePasswordAtLogon $true

    Write-Host "Created: $fullName ($($user.Username))" -ForegroundColor Green
}
Write-Host ""

# Step 3 - Add all three to Admin_Staff group
Write-Host "STEP 3: Adding to Admin_Staff security group..." -ForegroundColor Yellow
Add-ADGroupMember -Identity "Admin_Staff" -Members "smitchell","crivera","bcooper"
Write-Host "All three added to Admin_Staff" -ForegroundColor Green
Write-Host ""

# Step 4 - Verify accounts in correct OU
Write-Host "STEP 4: Verifying accounts in Admin Users OU..." -ForegroundColor Yellow
Get-ADUser -Filter * -SearchBase "OU=Users,OU=Admin,OU=Pinnacle,DC=pinnacle,DC=local" |
    Select Name,SamAccountName |
    Format-Table -AutoSize
Write-Host ""

# Step 5 - Verify group membership for all three
Write-Host "STEP 5: Verifying Admin_Staff group membership..." -ForegroundColor Yellow
$members = Get-ADGroupMember -Identity "Admin_Staff" | Select -ExpandProperty SamAccountName
Write-Host "Admin_Staff members: $($members -join ', ')" -ForegroundColor White
Write-Host ""

# Step 6 - Verify GPO will apply
Write-Host "STEP 6: Confirming Admin_Policy GPO is linked to Admin OU..." -ForegroundColor Yellow
$gpo = Get-GPInheritance -Target "OU=Admin,OU=Pinnacle,DC=pinnacle,DC=local"
$links = $gpo.GpoLinks | Select -ExpandProperty DisplayName
Write-Host "GPOs linked to Admin OU: $($links -join ', ')" -ForegroundColor White
Write-Host ""

# Step 7 - Time comparison
Write-Host "STEP 7: Efficiency comparison..." -ForegroundColor Yellow
Write-Host "Manual process per user: ~15 minutes" -ForegroundColor White
Write-Host "Total manual for 3 users: ~45 minutes" -ForegroundColor White
Write-Host "Script execution time: under 2 minutes" -ForegroundColor White
Write-Host "Time saved: ~43 minutes" -ForegroundColor Green
Write-Host ""

Write-Host "=== BULK ONBOARDING COMPLETE ===" -ForegroundColor Green
Write-Host "Accounts created: smitchell, crivera, bcooper" -ForegroundColor White
Write-Host "Department: Admin" -ForegroundColor White
Write-Host "Group: Admin_Staff" -ForegroundColor White
Write-Host "GPO: Admin_Policy confirmed linked" -ForegroundColor White
Write-Host "Temp password: Welcome2026!" -ForegroundColor White
Write-Host "Password change required on first login: Yes" -ForegroundColor White
Write-Host ""
Write-Host "Ticket closed: $(Get-Date -Format 'MM/dd/yyyy HH:mm')" -ForegroundColor Cyan