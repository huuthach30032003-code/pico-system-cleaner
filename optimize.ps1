# --- ĐOẠN XIN QUYỀN ADMIN (DÀNH RIÊNG CHO CHẠY TỪ WEB) ---
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Khai báo lại link tải code để PowerShell Admin biết đường chạy tiếp
    $url = 'https://bit.ly/4yblONn'
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -NoExit -Command `"iex (iwr '$url' -UseBasicParsing).Content`"" -Verb RunAs
    exit
}

$host.UI.RawUI.WindowTitle = "System Optimization Log - Admin Process"
Clear-Host
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "      HE THONG DANG DON DEP VA TOI UU PRO        " -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Cyan

$log = New-Object System.Collections.Generic.List[string]

function Add-Log($msg) {
    Write-Host "[*] $msg" -ForegroundColor Cyan
    $log.Add("[$(Get-Date -Format 'HH:mm:ss')] $msg")
}

# ---------------------------------------------------------
# 1. DỌN RÁC Ổ CỨNG (Giải phóng hàng GB SSD)
# ---------------------------------------------------------
Add-Log "Dang xoa file tam (Temp)..."
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

Add-Log "Dang xoa Prefetch (Tang toc do khoi dong phan mem)..."
Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

Add-Log "Dang don sach Thung rac (Recycle Bin)..."
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Add-Log "Dang xoa Cache Windows Update (Giai phong bo nho)..."
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service -Name wuauserv -ErrorAction SilentlyContinue

# ---------------------------------------------------------
# 2. TỐI ƯU HIỆU NĂNG & ĐIỆN NĂNG (CPU/RAM)
# ---------------------------------------------------------
Add-Log "Dang tat Ngu dong (Hibernation) de xoa file hiberfil.sys..."
powercfg -h off

Add-Log "Dang bat che do Hieu nang cao (High Performance)..."
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# ---------------------------------------------------------
# 3. TỐI ƯU REGISTRY 
# ---------------------------------------------------------
Add-Log "Dang toi uu Registry (Giam do tre Menu, tu dong nha RAM)..."
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "AlwaysUnloadDLL" -Value 1 -ErrorAction SilentlyContinue

# ---------------------------------------------------------
# 4. TỐI ƯU MẠNG
# ---------------------------------------------------------
Add-Log "Dang Flush DNS Cache (Giam lag ket noi mang)..."
ipconfig /flushdns | Out-Null

# ---------------------------------------------------------
# 5. DỌN DẸP SÂU WINSXS (Làm cuối cùng vì hơi lâu)
# ---------------------------------------------------------
Add-Log "Dang don dep WinSxS (Buoc nay co the mat 1-2 phut)..."
dism /online /cleanup-image /startcomponentcleanup /resetbase | Out-Null

# ---------------------------------------------------------
# KẾT THÚC & HIỂN THỊ LOG
# ---------------------------------------------------------
Write-Host "`n=================================================" -ForegroundColor Cyan
Write-Host "           TONG KET CONG VIEC DA LAM             " -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan
foreach ($item in $log) { Write-Host $item -ForegroundColor White }

Write-Host "`n[HOAN TAT] Nhan phim bat ky de thoat..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
