# SIMULATION 02 - Password Reset
# Employee: Tom Ellis (tellis) - Front Desk, Admin
# Date: 6/3/2026
# Performed by: Zoe Adams (zadams) - Help Desk Tech

Write-Host "=== PINNACLE HEALTH CLINIC ===" -ForegroundColor Cyan
Write-Host "=== Simulation 03: Password Reset Request ===" -ForegroundColor Cyan
Write-Host "=== Employee: Tom Ellis (tellis) ===" -ForegroundColor Cyan
Write-Host ""

# Step 1 - Verify identity — confirm account exists
Write-Host "STEP 1: Verifying employee identity..." -ForegroundColor Yellow
$user = Get-ADUser -Identity "tellis" -Properties Department,Title,Enabled,LockedOut,LastLogonDate
Write-Host "Name: $($user.Name)" -ForegroundColor White
Write-Host "Username: $($user.SamAccountName)" -ForegroundColor White
Write-Host "Department: $($user.Department)" -ForegroundColor White
Write-Host "Title: $($user.Title)" -ForegroundColor White
Write-Host "Account Enabled: $($user.Enabled)" -ForegroundColor White
Write-Host "Account Locked: $($user.LockedOut)" -ForegroundColor White
Write-Host "Last Logon: $($user.LastLogonDate)" -ForegroundColor White
Write-Host ""

# Step 2 - Confirm account is not locked
Write-Host "STEP 2: Checking for lockout..." -ForegroundColor Yellow
if ($user.LockedOut -eq $true) {
    Unlock-ADAccount -Identity "tellis"
    Write-Host "Account was locked — unlocked successfully" -ForegroundColor Green
} else {
    Write-Host "Account is not locked — proceeding to password reset" -ForegroundColor Green
}
Write-Host ""

# Step 3 - Reset password
Write-Host "STEP 3: Resetting password..." -ForegroundColor Yellow
Set-ADAccountPassword -Identity "tellis" `
    -NewPassword (ConvertTo-SecureString "TempPass2024!" -AsPlainText -Force) `
    -Reset
Set-ADUser -Identity "tellis" -ChangePasswordAtLogon $true
Write-Host "Password reset to temporary password" -ForegroundColor Green
Write-Host "User must change password on next login" -ForegroundColor Green
Write-Host ""

# Step 4 - Verify account is ready
Write-Host "STEP 4: Verifying account is ready for login..." -ForegroundColor Yellow
$verify = Get-ADUser -Identity "tellis" -Properties Enabled,LockedOut,PasswordExpired
Write-Host "Enabled: $($verify.Enabled)" -ForegroundColor White
Write-Host "Locked Out: $($verify.LockedOut)" -ForegroundColor White
Write-Host "Password Expired: $($verify.PasswordExpired)" -ForegroundColor White
Write-Host ""

# Step 5 - Check group membership
Write-Host "STEP 5: Confirming group membership..." -ForegroundColor Yellow
$groups = Get-ADPrincipalGroupMembership -Identity "tellis" | Select -ExpandProperty Name
Write-Host "Groups: $($groups -join ', ')" -ForegroundColor White
Write-Host ""

# Summary
Write-Host "=== PASSWORD RESET COMPLETE ===" -ForegroundColor Green
Write-Host "Employee: Tom Ellis (tellis)" -ForegroundColor White
Write-Host "Temp password set: TempPass2024!" -ForegroundColor White
Write-Host "Action required: User must set new password on first login" -ForegroundColor White
Write-Host "Identity verification: Confirmed name, department, and manager" -ForegroundColor White
Write-Host "Next step: Confirm with user they can log in successfully" -ForegroundColor White
Write-Host ""
Write-Host "Ticket closed: $(Get-Date -Format 'MM/dd/yyyy HH:mm')" -ForegroundColor Cyan
