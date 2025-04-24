# Definiere den Schriftarten-Ordner und den Backup-Ordner
$fontFolder = "C:\Windows\Fonts"
$backupFolder = "C:\Users\ciena\Documents\DefekteFonts\DefekteFontsBackup"

# Erstelle den Backup-Ordner, falls er nicht existiert
if (-not (Test-Path $backupFolder)) {
    New-Item -Path $backupFolder -ItemType Directory -Force
}

# Finde alle TTF- und OTF-Dateien im Schriftarten-Ordner
$fonts = Get-ChildItem -Path $fontFolder -Include *.ttf,*.otf -Recurse

# Prüfe jede Schriftart und lösche fehlerhafte
foreach ($font in $fonts) {
    try {
        $shell = New-Object -ComObject Shell.Application
        $folder = $shell.Namespace($fontFolder)
        $item = $folder.ParseName($font.Name)
        if ($item -eq $null) {
            Write-Output "Defekte Schriftart gefunden: $($font.FullName)"
            # Kopiere die Schriftart in den Backup-Ordner
            Copy-Item -Path $font.FullName -Destination $backupFolder -Force
            # Lösche die Schriftart aus dem Fonts-Ordner
            Remove-Item -Path $font.FullName -Force
            Write-Output "Gelöscht: $($font.FullName) (Sicherungskopie in $backupFolder)"
        }
    }
    catch {
        Write-Output "Fehler beim Laden: $($font.FullName) - Wahrscheinlich defekt"
        # Kopiere die Schriftart in den Backup-Ordner
        Copy-Item -Path $font.FullName -Destination $backupFolder -Force
        # Lösche die Schriftart aus dem Fonts-Ordner
        Remove-Item -Path $font.FullName -Force
        Write-Output "Gelöscht: $($font.FullName) (Sicherungskopie in $backupFolder)"
    }
}

Write-Output "Prüfung abgeschlossen. Alle defekten Schriftarten wurden gelöscht und in $backupFolder gesichert."