# --- THIET LAP GIAO DIEN ---
$host.UI.RawUI.WindowTitle = "System Maintenance - Admin Process"
$host.UI.RawUI.BackgroundColor = "Black"
$host.UI.RawUI.ForegroundColor = "White"
Clear-Host

# 1. Hộp thoại hỏi quyền Admin (Tạo độ tin cậy)
Add-Type -AssemblyName System.Windows.Forms
$result = [System.Windows.Forms.MessageBox]::Show("He thong can don dep file rac de duy tri toc do. Ban cho phep tiep tuc?", "System Optimizer", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Information)

if ($result -eq 'No') { exit }

# 2. Nâng quyền Admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 3. Giao diện thực thi (Trông như phần mềm chuyên nghiệp)
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "                SYSTEM MAINTENANCE RUNNING                " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

function Step-Log($message) {
    Write-Host "[*] $message..." -ForegroundColor Green
    Start-Sleep -Milliseconds 800
}

Step-Log "Dang quet file tam (Temp Files)"
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

Step-Log "Dang toi uu bo nho Cache Windows"
Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

Step-Log "Dang don dep WinSxS (Cleanup Image)"
dism /online /cleanup-image /startcomponentcleanup /resetbase | Out-Null

Step-Log "Toi uu hoa CPU va Registry"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 0
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

Step-Log "Flush DNS Cache"
ipconfig /flushdns | Out-Null

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "               DON DEP HOAN TAT - HE THONG OK             " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Start-Sleep -Seconds 2