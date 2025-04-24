# Definiere den Schriftarten-Ordner
$fontFolder = "C:\Windows\Fonts"

# Definiere den Pfad für die Ausgabe in eine Textdatei
$outputFile = "C:\Users\ciena\Documents\DefekteFonts\DefekteFontsList\DefekteFontsList.txt"

# Erstelle den Ordner für die Ausgabe, falls er nicht existiert
$outputDir = "C:\Users\ciena\Documents\DefekteFonts\DefekteFontsList"
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force
}

# Finde alle TTF- und OTF-Dateien im Schriftarten-Ordner
$fonts = Get-ChildItem -Path $fontFolder -Include *.ttf,*.otf -Recurse

# Prüfe jede Schriftart und zeige fehlerhafte an
foreach ($font in $fonts) {
    try {
        $shell = New-Object -ComObject Shell.Application
        $folder = $shell.Namespace($fontFolder)
        $item = $folder.ParseName($font.Name)
        if ($item -eq $null) {
            $message = "Defekte Schriftart gefunden: $($font.FullName)"
            Write-Output $message
            # Schreibe die Ausgabe in eine Textdatei
            $message | Out-File -FilePath $outputFile -Append
        }
    }
    catch {
        $message = "Fehler beim Laden: $($font.FullName) - Wahrscheinlich defekt"
        Write-Output $message
        # Schreibe die Ausgabe in eine Textdatei
        $message | Out-File -FilePath $outputFile -Append
    }
}

Write-Output "Prüfung abgeschlossen. Defekte Schriftarten (falls vorhanden) wurden in $outputFile gespeichert."