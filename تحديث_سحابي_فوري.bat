@echo off
chcp 65001 > nul
title منظومة المختبر الطبي - التحديث السحابي V3.3.0
color 0B
echo =======================================================================
echo          🏥 منظومة المختبر الطبي - التحديث السحابي المباشر V3.3.0
echo =======================================================================
echo.
echo جاري فحص الاتصال وتطبيق التحديث السحابي عبر الإنترنت...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; & ([ScriptBlock]::Create((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/seenorht/med-lab-releases/main/update.ps1')))"
if errorlevel 1 (
    echo.
    echo [خطأ] حدث خطأ أثناء التحديث السحابي. اضغط أي مفتاح للإغلاق...
    pause > nul
)
