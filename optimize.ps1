# --- ĐOẠN XIN QUYỀN ADMIN CHUẨN ENCODED (CHỐNG ĐỨNG IM) ---
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $url = 'https://raw.githubusercontent.com/huuthach30032003-code/pico-system-cleaner/refs/heads/main/optimize.ps1'
    $rawCmd = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex (iwr '$url' -UseBasicParsing).Content"
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($rawCmd)
    $encodedCmd = [Convert]::ToBase64String($bytes)
    Start-Process powershell.exe -ArgumentList "-NoP", "-Exec", "Bypass", "-NoExit", "-EncodedCommand", $encodedCmd -Verb RunAs
    exit
}

# =========================================================
# CẤU HÌNH ĐƯỜNG DẪN WEBSITE CỦA BẠN
# =========================================================
$WebURL = "http://localhost/cyber-cleaner/index.html"  # Trang giao diện chính
$WebAPI = "http://localhost/cyber-cleaner/api.php"      # Nơi nhận dữ liệu log

# ÉP MỞ TRÌNH DUYỆT LÊN NGAY KHI CHẠY SCRIPT
Start-Process $WebURL

$host.UI.RawUI.WindowTitle = "CYBER-CLEANER: Web Sync Module"
Clear-Host

# Hàm gửi dữ liệu ngầm lên Website
function Send-LogWeb {
    param(
        [string]$Text,
        [string]$Status = "info"
    )
    
    $Body = @{
        text = $Text
        status = $Status
        time = (Get-Date -Format "HH:mm:ss")
    } | ConvertTo-Json -Compress

    try {
        Invoke-RestMethod -Uri $WebAPI -Method Post -Body $Body -ContentType "application/json; charset=utf-8" -TimeoutSec 2 -ErrorAction SilentlyContinue
    } catch {}
}

# Phát âm thanh khởi động nhẹ phối hợp với hiệu ứng web
[System.Console]::Beep(600, 100)
Start-Sleep -Milliseconds 500

# TIẾN HÀNH DỌN DẸP VÀ ĐẨY LOG LÊN WEB (ẨN TEXT TRÊN CONSOLE)
Send-LogWeb "[-] Kết nối hệ thống..." "info"
Start-Sleep -Milliseconds 500

function Clean-Folder-Detailed ($FolderPath) {
    if (Test-Path $FolderPath) {
        Send-LogWeb "[*] Đang quét phân vùng dữ liệu tạm..." "warning"
        $files = Get-ChildItem -Path $FolderPath -Recurse -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            # Gửi chi tiết tên tập tin lên giao diện web
            Send-LogWeb " -> ĐANG TIÊU HỦY: $($file.Name)" "info"
            Remove-Item -Path $file.FullName -Force -Recurse -ErrorAction SilentlyContinue
        }
    }
}

Clean-Folder-Detailed -FolderPath "$env:TEMP\*"
Clean-Folder-Detailed -FolderPath "C:\Windows\Temp\*"

Send-LogWeb "[!] Bắt đầu dọn dẹp bộ nhớ đệm Thùng rác..." "warning"
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Send-LogWeb "[+] Thùng rác đã được giải phóng hoàn toàn." "success"

Send-LogWeb "[!] Thực hiện cấu hình Registry hệ thống..." "warning"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 0
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

Send-LogWeb "[-] Đang tối ưu không gian lưu trữ hệ thống (WinSxS)..." "info"
dism /online /cleanup-image /startcomponentcleanup /resetbase | Out-Null

# XÓA LỊCH SỬ HỘP THOẠI RUN VÀ RESTART EXPLORER
Send-LogWeb "[!] Làm sạch dấu vết hoạt động hệ thống..." "warning"
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name * -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU\*" -Force -ErrorAction SilentlyContinue

Stop-Process -Name explorer -Force

# HOÀN TẤT VÀ THOÁT
Send-LogWeb "[============= HOÀN TẤT QUÁ TRÌNH TOÀN DIỆN =============]" "success"
[System.Console]::Beep(1000, 100)
[System.Console]::Beep(1500, 200)

exit
