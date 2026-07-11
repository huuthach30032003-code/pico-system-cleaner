# --- ĐOẠN XIN QUYỀN ADMIN CHUẨN ENCODED (CHỐNG ĐỨNG IM) ---
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $url = 'https://raw.githubusercontent.com/huuthach30032003-code/pico-system-cleaner/refs/heads/main/optimize.ps1'
    
    # Đoạn lệnh tải sạch sẽ
    $rawCmd = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex (iwr '$url' -UseBasicParsing).Content"
    
    # Chuyển lệnh thành Base64 để Windows truyền đi một cách an toàn tuyệt đối
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($rawCmd)
    $encodedCmd = [Convert]::ToBase64String($bytes)
    
    # Gọi PowerShell Admin và ép thực thi lệnh mã hóa
    Start-Process powershell.exe -ArgumentList "-NoP", "-Exec", "Bypass", "-NoExit", "-EncodedCommand", $encodedCmd -Verb RunAs
    exit
}

$host.UI.RawUI.WindowTitle = "CYBER-CLEANER: AI Module"
[console]::CursorVisible = $false
Clear-Host

# =========================================================
# CẤU HÌNH WEB API ĐỂ NHẬN LOG (THAY URL WEBSITE CỦA BẠN VÀO ĐÂY)
# =========================================================
$WebAPI = "http://localhost/cyber-cleaner/api.php" 

function Send-LogWeb {
    param(
        [string]$Text,
        [string]$Status = "info"
    )
    
    # Hiển thị song song trên Console để debug nếu cần
    if ($Status -eq "success") {
        Write-Host $Text -ForegroundColor Green
    } elseif ($Status -eq "warning") {
        Write-Host $Text -ForegroundColor Yellow
    } else {
        Write-Host $Text -ForegroundColor Gray
    }

    # Đóng gói dữ liệu log đẩy lên Web cá nhân
    $Body = @{
        text = $Text
        status = $Status
        time = (Get-Date -Format "HH:mm:ss")
    } | ConvertTo-Json -Compress

    try {
        Invoke-RestMethod -Uri $WebAPI -Method Post -Body $Body -ContentType "application/json; charset=utf-8" -TimeoutSec 2 -ErrorAction SilentlyContinue
    } catch {
        # Bỏ qua nếu website không phản hồi để tiến trình dọn dẹp không bị ngắt
    }
}

# 1. HIỆU ỨNG MÀN HÌNH OLED ESP32 (ANIMATION ĐÔI MẮT)
$eyeFrames = @(
    "  O   O  ", 
    "  -   -  ", 
    "  O   O  ", 
    " O   O   ", 
    "  O   O  ", 
    "   O   O ", 
    "  O   O  ", 
    "  -   -  ", 
    "  ^   ^  "  
)

Write-Host "`n"
foreach ($frame in $eyeFrames) {
    [console]::SetCursorPosition(0, 2)
    Write-Host "       .───────────────.       " -ForegroundColor Cyan
    Write-Host "       │$frame│       " -ForegroundColor Cyan
    Write-Host "       '───────────────'       " -ForegroundColor Cyan
    Write-Host "    [ Đang khởi động AI Core... ]" -ForegroundColor DarkGray
    
    [System.Console]::Beep(500, 5)
    Start-Sleep -Milliseconds 300
}
Start-Sleep -Milliseconds 2
Clear-Host

# 2. CHẠY HIỆU ỨNG VÀ DỌN DẸP THỰC TẾ CHI TIẾT
Write-Host "`n       .───────────────.       " -ForegroundColor Cyan
Write-Host "       │  ^   ^  │       " -ForegroundColor Cyan
Write-Host "       '───────────────'       " -ForegroundColor Cyan
Write-Host "         CYBER-CLEANER v3.5`n" -ForegroundColor Yellow

Send-LogWeb "[-] Ket noi den he thong loi... THANH CONG." "info"
Start-Sleep -Milliseconds 200

# Hàm tối ưu xóa file nhanh và hiển thị chi tiết
function Clean-Folder-Detailed ($FolderPath) {
    if (Test-Path $FolderPath) {
        Send-LogWeb "[*] Dang quet: $FolderPath" "warning"
        $files = Get-ChildItem -Path $FolderPath -Recurse -ErrorAction SilentlyContinue
        
        foreach ($file in $files) {
            # Bắn log chi tiết tên từng file đang xóa lên Web
            Send-LogWeb " -> DELETING: $($file.FullName)" "info"
            Remove-Item -Path $file.FullName -Force -Recurse -ErrorAction SilentlyContinue
        }
    }
}

Send-LogWeb "`n[!] TIEN HANH XOA TAP TIN TAM THOI:" "warning"
Clean-Folder-Detailed -FolderPath "$env:TEMP\*"
Clean-Folder-Detailed -FolderPath "C:\Windows\Temp\*"

Send-LogWeb "`n[!] TIEN HANH TIEU HUY THUNG RAC:" "warning"
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Send-LogWeb " -> Thung rac da duoc don sach se!" "success"

Send-LogWeb "`n[!] TOI UU HE THONG:" "warning"
Send-LogWeb "[-] Ep xung hieu nang & Toi uu Registry..." "info"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 0
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

Send-LogWeb "[-] Giai phong khong gian WinSxS (Vui long doi)..." "info"
dism /online /cleanup-image /startcomponentcleanup /resetbase | Out-Null

# 3. ĐOẠN XÓA DẤU VẾT LỊCH SỬ HỘP THOẠI RUN
Send-LogWeb "`n[!] Dang xoa dau vet lich su hop thoai Run..." "warning"

# Thực hiện xóa sạch Registry trước khi can thiệp Explorer
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name * -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU\*" -Force -ErrorAction SilentlyContinue

Send-LogWeb " -> Dang lam moi he thong de xoa lich su RunMRU..." "info"
Stop-Process -Name explorer -Force

# 4. HOÀN TẤT & BÁO CÁO CỰC NGẦU LÊN WEB
Send-LogWeb "`n[=========================================]" "success"
Send-LogWeb "[+] TOI UU HOA HOAN TAT! HE THONG DA SACH." "success"
Send-LogWeb "[=========================================]" "success"

[System.Console]::Beep(1000, 100)
[System.Console]::Beep(1200, 100)
[System.Console]::Beep(1500, 300)

Write-Host "`nNhan phim bat ky de rut lui..." -ForegroundColor DarkGray
[console]::CursorVisible = $true
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
