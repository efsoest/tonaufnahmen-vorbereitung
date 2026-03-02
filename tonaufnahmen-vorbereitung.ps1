# --- KONFIGURATION ---
[console]::OutputEncoding = [System.Text.Encoding]::UTF8
[console]::InputEncoding = [System.Text.Encoding]::UTF8

$TemplateStandard = "C:\Pfad\Zu\Standard_Vorlage"
$TemplateVSC      = "C:\Pfad\Zu\VirtualSoundcheck_Vorlage"
$DestinationBase  = "C:\Pfad\Zu\Aufnahmen"

Clear-Host
Write-Host "--- Tonaufnahmen-Vorbereitung ---" -ForegroundColor Cyan

# 1. VORLAGE AUSWÄHLEN
Write-Host "Welche Vorlage soll verwendet werden?"
Write-Host "1: Standard-Veranstaltung"
Write-Host "2: Virtual Soundcheck"
$TypeChoice = Read-Host "Auswahl (Enter für Standard: 1)"

$IsVSC = ($TypeChoice -eq "2")
$TemplatePath = if ($IsVSC) { $TemplateVSC } else { $TemplateStandard }

# 2. DATUM ABFRAGEN
$Today = Get-Date -Format "dd.MM.yyyy"
$FinalDate = $null

do {
    $DateInput = Read-Host "`nDatum [TT.MM.JJJJ] (Enter für heute: $Today)"
    if ([string]::IsNullOrWhiteSpace($DateInput)) { $DateInput = $Today }

    try {
        $ParsedDate = [datetime]::ParseExact($DateInput, "dd.MM.yyyy", $null)
        $FolderDate = $ParsedDate.ToString("yyyy_MM_dd")
        $FinalDate = $DateInput
    } catch {
        Write-Host "Fehler: '$DateInput' ist kein gültiges Format!" -ForegroundColor Red
    }
} while ($null -eq $FinalDate)

# 3. VERANSTALTUNG ABFRAGEN
$DefaultEvent = "Gottesdienst"
$EventName = Read-Host "Name der Veranstaltung (Enter für Standard: $DefaultEvent)"
if ([string]::IsNullOrWhiteSpace($EventName)) { $EventName = $DefaultEvent }

# 4. ORDNERNAME ZUSAMMENBAUEN (mit Suffix-Logik)
if ($IsVSC) {
    $NewFolderName = "$FolderDate ($EventName - Virtual Soundcheck)"
} else {
    $NewFolderName = "$FolderDate ($EventName)"
}

$TargetFull = Join-Path $DestinationBase $NewFolderName

# 5. PRÜFUNG & KONFLIKT-MANAGEMENT
if (Test-Path $TargetFull) {
    Write-Host "`nACHTUNG: Ordner '$NewFolderName' existiert bereits!" -ForegroundColor Yellow
    $Choice = Read-Host "1: Abbrechen | 2: Löschen & Neu erstellen"
    if ($Choice -eq "2") {
        Remove-Item -Path $TargetFull -Recurse -Force
    } else {
        exit
    }
}

# 6. KOPIEREN & DATEI UMBENENNEN
Write-Host "`nErstelle Projekt..." -ForegroundColor Cyan
Copy-Item -Path $TemplatePath -Destination $TargetFull -Recurse

$AudioDir = Join-Path $TargetFull "Tonaufnahme"
$ProjectFile = Get-ChildItem -Path $AudioDir | Where-Object { $_.Name -like "*JJJJ_MM_TT*" } | Select-Object -First 1

if ($ProjectFile) {
    $NewFileName = "$FolderDate$($ProjectFile.Extension)"
    $NewFilePath = Join-Path $AudioDir $NewFileName
    Rename-Item -Path $ProjectFile.FullName -NewName $NewFileName
}

# 7. ABSCHLUSS & START
Write-Host "`nFertig! Ordner erstellt: $NewFolderName" -ForegroundColor Green
Write-Host "------------------------------------------------"
Write-Host "Beliebige Taste: Cubase JETZT ÖFFNEN"
Write-Host "ESC:             Nur BEENDEN"

$Key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

if ($Key.VirtualKeyCode -ne 27) {
    if (Test-Path $NewFilePath) {
        Invoke-Item $NewFilePath
    } else {
        Write-Host "Datei nicht gefunden." -ForegroundColor Red
        pause
    }
}