# --- ĐOẠN XIN QUYỀN ADMIN CHUẨN ENCODED (CHỐNG ĐỨNG IM) ---
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $url = 'https://raw.githubusercontent.com/huuthach30032003-code/pico-system-cleaner/refs/heads/main/optimize.ps1'
    $rawCmd = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex (iwr '$url' -UseBasicParsing).Content"
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($rawCmd)
    $encodedCmd = [Convert]::ToBase64String($bytes)
    Start-Process powershell.exe -ArgumentList "-NoP", "-Exec", "Bypass", "-NoExit", "-EncodedCommand", $encodedCmd -Verb RunAs
    exit
}

# Đường dẫn lưu file HTML tĩnh cục bộ trên máy
$htmlPath = "$env:TEMP\cyber_cleaner_ui.html"

# TẠO FILE GIAO DIỆN HTML CỰC ĐẸP VỚI MẶT ROBOT HOẠT HỌA & CSS NEON
$htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>CYBER-CLEANER AI INTERFACE</title>
    <style>
        body { background: #0a0a12; color: #00ffcc; font-family: 'Courier New', monospace; margin: 0; padding: 20px; display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 90vh; overflow: hidden; }
        .robot-face { width: 200px; height: 120px; border: 4px solid #00ffcc; border-radius: 20px; display: flex; justify-content: space-around; align-items: center; background: #111122; box-shadow: 0 0 20px #00ffcc; margin-bottom: 30px; position: relative; }
        .eye { width: 35px; height: 35px; background: #00ffcc; border-radius: 50%; box-shadow: 0 0 15px #00ffcc; transition: all 0.2s ease; }
        .eye.blink { height: 4px; }
        .eye.look-left { transform: translateX(-10px); }
        .eye.look-right { transform: translateX(10px); }
        .eye.success-mood { border-radius: 50% 50% 0 0; height: 20px; transform: scaleY(-1); }
        .console { width: 80%; max-width: 700px; height: 300px; background: #05050d; border: 2px solid #ff0055; border-radius: 10px; padding: 15px; overflow-y: auto; box-shadow: 0 0 15px #ff0055; }
        .log-line { margin: 5px 0; font-size: 14px; border-left: 3px solid #00ffcc; padding-left: 10px; animation: fadeIn 0.3s ease; }
        .info { color: #00ffcc; }
        .warning { color: #ffcc00; border-color: #ffcc00; }
        .success { color: #ff0055; border-color: #ff0055; font-weight: bold; }
        @keyframes fadeIn { from { opacity: 0; transform: translateX(-10px); } to { opacity: 1; transform: translateX(0); } }
    </style>
</head>
<body>
    <div class="robot-face">
        <div id="left-eye" class="eye"></div>
        <div id="right-eye" class="eye"></div>
    </div>
    <div class="console" id="console">
        <div class="log-line info">====== KẾT NỐI HỆ THỐNG AI THÀ THÀNH CÔNG ======</div>
    </div>

    <script>
        const leftEye = document.getElementById('left-eye');
        const rightEye = document.getElementById('right-eye');
        const con = document.getElementById('console');

        function setRobot(mood) {
            leftEye.className = 'eye ' + mood;
            rightEye.className = 'eye ' + mood;
        }

        setInterval(() => {
            leftEye.classList.add('blink'); rightEye.classList.add('blink');
            setTimeout(() => { leftEye.classList.remove('blink'); rightEye.classList.remove('blink'); }, 150);
        }, 4000);

        function addLog(text, type) {
            let d = document.createElement('div');
            d.className = 'log-line ' + type;
            d.innerText = '[' + new Date().toLocaleTimeString() + '] ' + text;
            con.appendChild(d);
            con.scrollTop = con.scrollHeight;
        }
    </script>
</body>
</html>
"@

# Xuất nội dung ra file HTML cục bộ
Out-File -FilePath $htmlPath -InputObject $htmlContent -Encoding utf8 -Force

# Mở trực tiếp file cục bộ bằng trình duyệt mặc định (Không qua localhost nữa)
Start-Process "file:///$htmlPath"
Start-Sleep -Seconds 2

# Hàm tương tác thời gian thực bằng cách đẩy script trực tiếp vào DOM của file HTML
function Update-WebUI {
    param([string]$Text, [string]$Status = "info", [string]$EyeMood = "")
    $logScript = "<script>addLog('$Text', '$Status'); if('$EyeMood') setRobot('$EyeMood');</script></body></html>"
    (Get-Content $htmlPath) -replace "</body></html>", $logScript | Set-Content $htmlPath -Force
}

# --- BẮT ĐẦU TIÊN TRÌNH DỌN DẸP CHI TIẾT ---
Update-WebUI "Đang quét phân vùng dữ liệu tạm..." "warning" "look-left"
Start-Sleep -Milliseconds 500

function Clean-Folder-Detailed ($FolderPath) {
    if (Test-Path $FolderPath) {
        $files = Get-ChildItem -Path $FolderPath -Recurse -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            Update-WebUI "Đang xóa: $($file.Name)" "info"
            Remove-Item -Path $file.FullName -Force -Recurse -ErrorAction SilentlyContinue
        }
    }
}
Clean-Folder-Detailed -FolderPath "$env:TEMP\*"
Clean-Folder-Detailed -FolderPath "C:\Windows\Temp\*"

Update-WebUI "Bắt đầu dọn dẹp và giải phóng Thùng rác hệ thống..." "warning" "look-right"
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Update-WebUI "Thùng rác đã giải phóng thành công." "success"

Update-WebUI "Đang dọn dẹp phân vùng Registry lỗi và tối ưu hiệu suất..." "info"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 0
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

Update-WebUI "Đang giải phóng không gian lưu trữ hệ thống nâng cao (WinSxS)..." "warning"
dism /online /cleanup-image /startcomponentcleanup /resetbase | Out-Null

# XÓA LỊCH SỬ HỘP THOẠI RUN VÀ RESET EXPLORER
Update-WebUI "Đang tiến hành xóa sạch dấu vết RunMRU trên hệ thống..." "warning"
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name * -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU\*" -Force -ErrorAction SilentlyContinue

Update-WebUI "Hệ thống chuẩn bị làm mới Windows Explorer..." "info"
Stop-Process -Name explorer -Force

# HOÀN TẤT
Update-WebUI "HỆ THỐNG ĐÃ ĐƯỢC TỐI ƯU HÓA HOÀN TOÀN!" "success" "success-mood"
[System.Console]::Beep(1000, 100)
[System.Console]::Beep(1500, 300)

Start-Sleep -Seconds 5
Remove-Item $htmlPath -Force -ErrorAction SilentlyContinue
exit
