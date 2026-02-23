# Tonaufnahmen Vorbereitung

Ein PowerShell-Skript zur Automatisierung der Vorbereitung von Audio-Aufnahme-Ordnern für Kirchengemeinden (speziell optimiert für **Steinberg Cubase**).

## 1. Projekt-Überblick

Dieses Skript ersetzt den manuellen und fehleranfälligen Kopierprozess von Projekt-Vorlagen durch einen geführten Assistenten (Wizard). Es richtet sich primär an ehrenamtliche Mitarbeiter ohne technisches Vorwissen. 

Das Skript fragt ein Datum ab, kopiert den Vorlage-Ordner, benennt ihn um in einen einheitlich benannten Zielordner (`JJJJ_MM_TT (Veranstaltungsname[ - Virtual Soundcheck])`) und benennt die darin enthaltene Cubase-Session passend um, bevor es diese direkt öffnet.

---

## 2. Benutzung

Der Assistent führt schrittweise durch den Prozess:

1. **Skript starten:** Skript über die Verknüpfung ausführen.
2. **Vorlage wählen:**
   ```text
   Bitte Vorlage wählen:
   [1] Standard Gottesdienst
   [2] Virtual Soundcheck
   ```
3. **Datum eingeben:**
   ```text
   Bitte Datum für die Aufnahme eingeben (TT.MM.JJJJ):
   14.05.2023
   ```
4. **Abschluss:**
   Das Skript erstellt den Zielordner (z.B. `2023_05_14 (Standard Gottesdienst)`) inkl. der umbenannten Projektdaten.
   Durch Drücken einer beliebigen Taste wird die vorbereitete Cubase-Session direkt geöffnet.

---

## 3. Einrichtung

Zur initialen Einrichtung müssen die Pfade im Skript an die lokale Umgebung angepasst werden.

1. **Konfiguration anpassen:** 
   Öffne `tonaufnahmen-vorbereitung.ps1` in einem Texteditor und passe die definierten Umgebungsvariablen für **Quellpfade** (Wo liegen die Templates?) und **Zielpfade** (Wo sollen Aufnahmen gespeichert werden?) an.
2. **Ausführungsrichtlinien anpassen (Windows):** 
   Damit das Skript lokal ausgeführt werden darf, muss in einer administrativen PowerShell folgender Befehl ausgeführt werden:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
3. **Verknüpfung erstellen:** 
   Für die Nutzer empfiehlt sich eine Desktop-Verknüpfung mit folgendem Ziel: 
   `powershell.exe -File "C:\Pfad\Zu\tonaufnahmen-vorbereitung.ps1"`

---

## 4. Entwicklung & Technische Details

Für Wartung und Weiterentwicklung sind folgende Details relevant:

* **Sprache:** Nativ Windows PowerShell. Keine zusätzlichen Laufzeitumgebungen nötig.
* **Dateierkennung:** Nutzt Wildcards (`*JJJJ_MM_TT*`), um Projektdateien unabhängig von der Dateiendung zu identifizieren. So lässt sich das Skript leicht für andere DAWs (Logic, Studio One, etc.) adaptieren.
* **Workflow / Algorithmus:**
  1. Abfrage & Validierung der Eingaben (Loop bei falschem Datumsformat).
  2. Konstruktion der Pfade inkl. Namenskonvention (Datumskonvertierung zu `JJJJ_MM_TT` für bessere Sortierung).
  3. Prüfung auf Ordner-Konflikte (Überschreiben/Abbrechen).
  4. Dateiverarbeitung (`Copy-Item` gefolgt von `Rename-Item`).
  5. Starten der Anwendung via `Invoke-Item`.
