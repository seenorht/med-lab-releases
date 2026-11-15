# ==============================================================================
# منظومة المختبر الطبي - أداة التحديث السحابي التلقائي الفوري (V3.3.0 Cloud Updater)
# ==============================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls

Write-Host ""
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "   🏥 منظومة المختبر الطبي المتقدمة - التحديث السحابي الفوري V3.3.0     " -ForegroundColor Yellow
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host ""

$downloadUrl = "https://github.com/seenorht/med-lab-releases/releases/download/v3.3.0/MedicalLabSystem_V3.exe"
$desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop), "MedicalLabSystem_V3.exe")
$currentDirExe = [System.IO.Path]::Combine($PSScriptRoot, "MedicalLabSystem_V3.exe")

# 1. تحديد مسار تثبيت المنظومة الحالي
$targetExe = $desktopPath
$procs = Get-Process -Name "MedicalLabSystem_V3" -ErrorAction SilentlyContinue
if ($procs) {
    try {
        $firstProcPath = $procs[0].MainModule.FileName
        if ($firstProcPath -and (Test-Path $firstProcPath)) {
            $targetExe = $firstProcPath
        }
    } catch {}
} elseif (Test-Path $currentDirExe) {
    $targetExe = $currentDirExe
}

Write-Host "🎯 مسار المنظومة المستهدف: $targetExe" -ForegroundColor White

# 2. إيقاف أي نسخة قيد التشغيل حالياً
if ($procs) {
    Write-Host "⏳ جاري إغلاق النسخة المفتوحة حالياً لتطبيق التحديث..." -ForegroundColor Yellow
    Stop-Process -Name "MedicalLabSystem_V3" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
}

# 3. تنزيل الإصدار V3.3.0 السحابي مباشرة
$tempExe = "$targetExe.cloud_new"
Write-Host "🌐 جاري الاتصال بالسحابة وتنزيل الإصدار V3.3.0 (8.45 MB)..." -ForegroundColor Cyan

try {
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("User-Agent", "MedicalLabSystem-CloudUpdater/3.3.0")
    $wc.DownloadFile($downloadUrl, $tempExe)
} catch {
    Write-Host "❌ فشل التنزيل من السحابة: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى." -ForegroundColor Yellow
    Exit 1
}

# 4. فحص سلامة الملف المُنزّل
if (Test-Path $tempExe) {
    $fileSize = (Get-Item $tempExe).Length
    if ($fileSize -lt 7000000) {
        Write-Host "❌ حجم الملف غير مكتمل ($fileSize بايت). تم إلغاء الاستبدال حفاظاً على النظام." -ForegroundColor Red
        Remove-Item $tempExe -Force -ErrorAction SilentlyContinue
        Exit 1
    }
} else {
    Write-Host "❌ لم يتم العثور على الملف المُنزّل." -ForegroundColor Red
    Exit 1
}

# 5. استبدال الملف القديم بالإصدار الجديد مع الحفاظ على ملف الترخيص
try {
    if (Test-Path $targetExe) {
        Remove-Item $targetExe -Force -ErrorAction SilentlyContinue
    }
    Move-Item -Path $tempExe -Destination $targetExe -Force
    Write-Host "✅ تم استبدال وتثبيت الإصدار V3.3.0 بنجاح تام!" -ForegroundColor Green
} catch {
    Write-Host "❌ تعذر استبدال الملف: $($_.Exception.Message)" -ForegroundColor Red
    Exit 1
}

# 6. إعادة تشغيل المنظومة المحدثة
Write-Host "🚀 جاري تشغيل منظومة المختبر الطبي V3.3.0..." -ForegroundColor Cyan
Start-Process -FilePath $targetExe

Write-Host ""
Write-Host "========================================================================" -ForegroundColor Green
Write-Host "  ✨ اكتمل التحديث السحابي بنجاح! المنظومة تعمل الآن بالإصدار V3.3.0   " -ForegroundColor Green
Write-Host "  - نظام الشيتات المخصصة المتعددة والطباعة المجمعة                     " -ForegroundColor White
Write-Host "  - مكتبة التحاليل الطبية الشاملة (80+ تحليل) والباقات الجاهزة          " -ForegroundColor White
Write-Host "  - قالب طباعة CBC مع إزالة العنوان ورقم الهاتف من التذييل              " -ForegroundColor White
Write-Host "  - ترخيص النظام وملف license.lic محفوظ بالكامل دون أي تعديل            " -ForegroundColor White
Write-Host "========================================================================" -ForegroundColor Green
Write-Host ""
