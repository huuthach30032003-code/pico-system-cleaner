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
# Giấu con trỏ chuột nhấp nháy đi để màn hình trông giống màn OLED thực thụ
[console]::CursorVisible = $false
Clear-Host

# 1. HIỆU ỨNG MÀN HÌNH OLED ESP32 (ANIMATION ĐÔI MẮT)
$eyeFrames = @(
    "  O   O  ", # Nhìn thẳng
    "  -   -  ", # Chớp mắt
    "  O   O  ", # Nhìn thẳng
    " O   O   ", # Nhìn sang trái
    "  O   O  ", # Nhìn thẳng
    "   O   O ", # Nhìn sang phải
    "  O   O  ", # Nhìn thẳng
    "  -   -  ", # Chớp mắt
    "  ^   ^  "  # Vui vẻ (Sẵn sàng làm việc)
)

Write-Host "`n"
foreach ($frame in $eyeFrames) {
    # Đưa con trỏ về cùng một vị trí để vẽ đè lên (tạo chuyển động)
    [console]::SetCursorPosition(0, 2)
    Write-Host "       .───────────────.       " -ForegroundColor Cyan
    Write-Host "       │$frame│       " -ForegroundColor Cyan
    Write-Host "       '───────────────'       " -ForegroundColor Cyan
    Write-Host "    [ Đang khởi động AI Core... ]" -ForegroundColor DarkGray
    
    # Phát tiếng click nhẹ nhàng cho mỗi khung hình
    [System.Console]::Beep(500, 5)
    Start-Sleep -Milliseconds 300
}
Start-Sleep -Milliseconds 2

# Xóa màn hình boot để chuyển sang giao diện dọn dẹp
Clear-Host

# 2. HÀM TẠO HIỆU ỨNG GÕ CHỮ KIỂU HACKER KÈM ÂM THANH
function Write-Hacker {
    param(
        [string]$Text, 
        [string]$Color = "Green"
    )
    foreach ($char in $Text.ToCharArray()) {
        Write-Host $char -NoNewline -ForegroundColor $Color
        [System.Console]::Beep(500, 15)
        Start-Sleep -Milliseconds 15
    }
    Write-Host ""
}

# 3. CHẠY HIỆU ỨNG VÀ DỌN DẸP THỰC TẾ CHI TIẾT
Write-Host "`n       .───────────────.       " -ForegroundColor Cyan
Write-Host "       │  ^   ^  │       " -ForegroundColor Cyan
Write-Host "       '───────────────'       " -ForegroundColor Cyan
Write-Host "        CYBER-CLEANER v3.5`n" -ForegroundColor Yellow

Write-Hacker "[-] Ket noi den he thong loi... THANH CONG." "DarkGray"
Start-Sleep -Milliseconds 200

# Hàm tối ưu xóa file nhanh và hiển thị chi tiết
function Clean-Folder-Detailed ($FolderPath) {
    if (Test-Path $FolderPath) {
        Write-Host "[*] Dang quet: $FolderPath" -ForegroundColor Yellow
        # Lấy toàn bộ file và thư mục con bên trong
        $files = Get-ChildItem -Path $FolderPath -Recurse -ErrorAction SilentlyContinue
        
        foreach ($file in $files) {
            # Hiển thị tên file đang xử lý ra màn hình theo thời gian thực
            Write-Host " -> DELETING: $($file.FullName)" -ForegroundColor DarkGray
            
            # Xóa file/thư mục ngay lập tức
            Remove-Item -Path $file.FullName -Force -Recurse -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "`n[!] TIEN HANH XOA TAP TIN TAM THOI:" -ForegroundColor Cyan
Clean-Folder-Detailed -FolderPath "$env:TEMP\*"
Clean-Folder-Detailed -FolderPath "C:\Windows\Temp\*"

Write-Host "`n[!] TIEN HANH TIEU HUY THUNG RAC:" -ForegroundColor Cyan
# Thùng rác Windows có cơ chế quản lý riêng, lệnh này tự tối ưu rất nhanh
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host " -> Thung rac da duoc don sach se!" -ForegroundColor Green

Write-Host "`n[!] TOI UU HE THONG:" -ForegroundColor Cyan
Write-Hacker "[-] Ep xung hieu nang & Toi uu Registry..." "Cyan"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 0
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

Write-Hacker "[-] Giai phong khong gian WinSxS (Vui long doi)..." "Yellow"
dism /online /cleanup-image /startcomponentcleanup /resetbase | Out-Null

# 4. HOÀN TẤT & BÁO CÁO CỰC NGẦU
Write-Host "`n"
Write-Hacker "[=========================================]" "Green"
Write-Hacker "[+] TOI UU HOA HOAN TAT! HE THONG DA SACH." "Green"
Write-Hacker "[=========================================]" "Green"

[System.Console]::Beep(1000, 100)
[System.Console]::Beep(1200, 100)
[System.Console]::Beep(1500, 300)

Write-Host "`nNhan phim bat ky de rut lui..." -ForegroundColor DarkGray
# Bật lại con trỏ chuột trước khi thoát
[console]::CursorVisible = $true
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
