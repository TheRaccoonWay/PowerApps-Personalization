# PowerApps-Personalization

**Power Apps Personalisierung:** Ein kleines Werkzeug, das eine Canvas-App auf eine Marke einstellt: Farben, Schrift und Radius kommen einmal in einen OnStart-Block, die klassischen Controls folgen diesem Block, die modernen Controls folgen einem Modern-Theme. Das Tool läuft als einzelne HTML-Datei lokal im Browser.

## Was es macht

| Baustein | Was passiert |
|---|---|
| **Themes.json** | Erzeugt aus der Themes.json deiner App eine Fassung nach dem Material-Design-Template von Luise Freese und Robin Rosengrün: 34 Palette-Einträge und 128 Style-Werte verweisen auf `defaults.*`. Dadurch folgen klassische Controls dem Record `defaults`. |
| **Modern Controls** | Schaltet in den App-Einstellungen „Moderne Steuerelemente und Designs“ ein. |
| **Start-Theme** | Legt ein Modern-Theme aus Primärfarbe und Schrift an (mit `HueTorsion` und `Vibrancy` einstellbar) und setzt es als `App.Theme`, auf Wunsch über die Variable `vTheme`. Statt des erzeugten Themes lassen sich auch eigene Themes als YAML einfügen, mit Auswahl des aktiven Themes beim Start. |
| **YAML-Ausgabe** | Zeigt das Modern-Theme als YAML an (kopieren oder als `.yaml` speichern), im Ablauf „Marke eingeben“ immer dabei, zum Einfügen in Studio über *Themes → Add a theme → Paste theme*. |
| **OnStart-Block** | Erzeugt den Power-Fx-Text mit `defaults`, Hex-Patch und `Set(vTheme, …)`, wahlweise für die englische oder deutsche Power-Apps-Oberfläche. Der Block wird **nie** automatisch in die App geschrieben. |
| **CI aus SharePoint** | Optional: Primär- und Sekundärfarbe werden beim App-Start aus einer SharePoint-Liste gelesen und nur übernommen, wenn sie gültig sind. Sonst gelten die Marken-Defaults. |
| **Kontrastprüfung** | Warnt, wenn Text- und Flächenfarben zu nah beieinander liegen (WCAG, 4,5:1 für Text und 3:1 für Flächen). |
| **Marken** | Drei Marken sind fest eingebaut (in2success, Customer, The Raccoon Way), eigene lassen sich im Browser speichern, als JSON sichern und wieder importieren. |
| **Zurücksetzen** | Eigene Aufgabe: stellt das aktive klassische Theme und auf Wunsch `App.Theme` wieder auf die Variable, nachdem jemand in Studio ein Theme angeklickt hat. |

Wie die Themes.json aufgebaut ist, was genau geändert wird und wie der manuelle Weg aussieht, steht in [docs/Themes-json_Zusammenfassung.md](docs/Themes-json_Zusammenfassung.md).

## Schnellstart

1. `tool/PowerApps-Personalisierung.html` im Browser öffnen (Doppelklick). Es braucht keine Installation und keinen Internetzugang. Alle Dateien werden lokal verarbeitet, es wird nichts hochgeladen.
2. Auf der Startseite eine **Aufgabe** wählen (siehe unten). Das Tool führt dann Schritt für Schritt.
3. Bei „Marke eingeben“: Marke festlegen, das Theme in Studio einfügen (*Themes → Add a theme → Paste theme*) und den **OnStart-Block** am Anfang von `App.OnStart` einfügen. Die App einmal neu starten.
4. Bei „Marke direkt in eine App-Datei einbauen“: die App in make.powerapps.com als **Paket** oder **Solution** exportieren, die ZIP-Datei im Tool ablegen, **Datei erzeugen**, das Ergebnis (`…_marke.zip`) importieren (mit **Aktualisieren** oder als neue App) und den OnStart-Block einfügen.

Ist deine Power-Apps-Oberfläche auf Deutsch, wähle im Tool vor dem Kopieren **Deutsch** (Semikolon als Trenner, `;;` zum Verketten). Das Tool wählt die Sprache nach der Browsersprache vor, prüfe sie trotzdem. Funktionsnamen bleiben in jeder Sprache englisch.

## Aufgaben und Schritte

Die Startseite bietet Aufgaben an. Jede hat einen eigenen, kurzen Ablauf. Der Schalter „Erklärungen anzeigen“ blendet die erklärenden Texte aus (Warnungen und Anleitungen bleiben), die Wahl merkt sich der Browser.

| Aufgabe | Schritte |
|---|---|
| Marke eingeben und Text für den App-Start bekommen | Deine Marke → SharePoint (optional) → Theme und Text für den App-Start. Es wird keine Datei verändert. |
| Marke direkt in eine App-Datei einbauen | Deine Marke → App-Datei anpassen → SharePoint (optional) → Text für den App-Start |
| Classic-Themes zurücksetzen | ein Schritt |
| Steuerelemente nach Namensschema umbenennen | geplant, siehe Issues |

### Schritt „Deine Marke“
Name, Schrift, Radius und fünf Farben (Primär, Sekundär, Text, Hintergrund, Fehler). Unter „Feineinstellungen“ lassen sich abgeleitete Felder überschreiben und eigene Zusatzfelder ergänzen (`name: Wert`, eine Zeile pro Feld).

- **Schrift:** Die Vorschlagsliste enthält die 14 Schriften, die Power Apps kennt. Ein Font-Stack mit Fallback ist möglich, zum Beispiel `Roboto, 'Segoe UI'`. Das Tool hängt im OnStart-Block und im erzeugten Modern-Theme immer `Arial` als letzte Rückfallebene an, wenn es nicht schon im Stack steht (im Block mit Kommentar markiert).
- **Feineinstellungen:** Neun abgeleitete Felder lassen sich überschreiben: `elementBackgroundColor`, `elementBorderColor`, `elementBorderFokusColor`, `textColorGedimmt`, `disabledColor`, `borderColor`, `inputFill`, `inputBorderThickness` und `fontSize`. Leer gelassene Felder werden abgeleitet und im Block mit einem Kommentar markiert. Eigene Zusatzfelder stehen als `eigenes Feld` im Block.
- **Kontrast:** Eine Zeile fasst zusammen, darunter stehen nur die Paare mit Handlungsbedarf. Die Tabelle zeigt alle sechs geprüften Paare (Text auf Hintergrund, Text auf Primärfarbe, Button-Schrift auf Primärfarbe, Primärfarbe auf Hintergrund, Text auf Eingabefüllung, Text auf Elementhintergrund). Werte, die sich nicht in eine Farbe auflösen lassen (zum Beispiel `Color.Transparent`), gelten als „nicht prüfbar“.
- **Vorlagen speichern:** „Als Vorlage speichern“ legt die Marke im Browser ab. Unter „Vorlagen sichern oder auf einen anderen Rechner übertragen“ steht der JSON-Text, mit dem sich Marken auf einen anderen Rechner bringen lassen. Fest eingebaute Marken lassen sich nicht überschreiben.

### Schritt „App-Datei anpassen“
Paket oder Solution (ZIP) ablegen. Bei Solutions erhöht das Tool die Versionsnummer um eins (letzte Stelle) und setzt den App-Zeitstempel neu, damit der Import als Update erkannt wird. Optionen:

| Option | Standard | Wirkung |
|---|---|---|
| Moderne Steuerelemente aktivieren | an | setzt die App-Einstellung |
| Start-Theme anlegen und aktivieren | an | Modern-Theme aus Primärfarbe und Schrift |
| App.Theme über Variable steuern | an | Formel `vTheme` bei `Theme`, Set-Zeile im OnStart-Block |
| App umbenennen | leer | nur bei Paketen, vermeidet Namenskonflikte beim Import |
| Nur diese App ändern | leer | bei Solutions mit mehreren Apps |
| Eigene Themes.json | leer | ersetzt die erzeugte Themes.json durch eine eigene Datei (`.json`) oder liest sie aus einer Vorlagen-App (`.zip`, `.msapp`) |

Die Themes.json wird erzeugt, wenn keine eigene Datei angegeben ist. Beim Ändern der Themes.json entfernt das Tool die `checksum.json` der App, Studio legt sie neu an. Unter „Weitere Optionen“ stehen die Felder (dort auch „App umbenennen“, „Nur diese App ändern“ und „Eigene Themes.json“):

| Feld | Standard | Wirkung |
|---|---|---|
| Themes als YAML | leer | eigene Themes einfügen (in Studio: Theme kopieren), mehrere untereinander möglich; ersetzt das erzeugte Start-Theme |
| Aktives Theme beim Start | erstes Theme | welches Theme in `App.Theme` bzw. in `Set(vTheme, …)` landet |
| Variablenname | `vTheme` | Name der Variable für `App.Theme` (nur Buchstaben, Ziffern, `_`) |
| HueTorsion, Vibrancy | 0 | Feinabstimmung des erzeugten Modern-Themes |

Der Theme-Name wird aus dem Markennamen gebildet (Sonderzeichen werden zu `_`).

### Schritt „Firmenfarben aus SharePoint“ (optional)
Die Werte aus „Deine Marke“ bleiben die Defaults. Mit dem Schalter „SharePoint-Liste für die CI anbinden“ und dem Anzeigenamen der Datenquelle ergänzt das Tool den OnStart-Block um zwei Teile: das Laden der Liste in die Collection `colCI` (Spalten `k` = Schlüssel aus `Title`, `v` = Wert aus `Value`) und die geprüfte Übernahme in `defaults`.

- **Nur zwei Farben:** Aus der Liste kommen ausschließlich `primaryColor` und `secondaryColor`. Schrift, Größen und alle anderen Werte kommen immer aus dem OnStart.
- **Nur gültige Werte:** Ein Wert wird nur übernommen, wenn er `#RRGGBB` entspricht. Fehlt ein Eintrag oder ist er ungültig, bleibt der Default.
- **Fehlerfall:** Ist die Liste nicht erreichbar (Variable ohne Wert, Liste gelöscht, keine Rechte), fängt `IfError` das ab. `colCI` bleibt leer, `ciListOk` wird `false`, es gelten die Defaults.
- **Reihenfolge:** Der Hex-Patch steht bewusst *nach* der Übernahme, damit abgeleitete Felder wie `primaryColorTransparentHex` die Listenfarbe verwenden.
- **Debug:** `ciSource` zeigt `SharePoint` oder `Default`, zum Beispiel in einem Label.
- **Datenquelle:** Der Name steht im Block immer in Hochkommas (`'ev_…-CIList'`), damit Bindestriche und Leerzeichen funktionieren. Die deutsche Umwandlung lässt Namen in Hochkommas unverändert.

Einrichtung in Power Apps: App aus der Solution heraus öffnen, SharePoint-Datenquelle hinzufügen und unter *Erweitert* Site **und** Liste jeweils als Umgebungsvariable (Typ Datenquelle) wählen. Nur die Site als Variable reicht nicht. Änderungen am Wert der Variable können bis zu einer Stunde im Browser zwischengespeichert sein. Aufbau der Liste: Spalte `Title` = Schlüssel, Spalte `Value` (Einzelne Textzeile, nicht umbenennen) = Wert, zwei Einträge `primaryColor` und `secondaryColor`. Alle App-Nutzer brauchen mindestens Leserechte. Die Schritt-für-Schritt-Anleitung steht auch im Tool.

### Schritt „Theme und Text für den App-Start“
Beispiel (englische Fassung, gekürzt):

```powerfx
// BEGIN Branding (Beispiel)
Set(defaults,
    {
        primaryColor:    ColorValue("#7B2FBE"),
        backgroundColor: ColorValue("#0D0D1A"),
        textColor:       ColorValue("#F0F0FF"),
        font:            "Roboto, 'Segoe UI', Arial", // Arial als Rückfallebene ergänzt
        fontSize:        14,
        borderRadius:    5
        // …weitere Felder
    }
);

Set(defaults,
    Patch(defaults,
    {
        primaryColorHex: Match(JSON(defaults.primaryColor,JSONFormat.IgnoreUnsupportedTypes),"#[a-fA-F0-9]{6}").FullMatch
        // …weitere Hex-Felder
    }
    )
);

Set(vTheme, Beispiel);
// END Branding
```

Der Hex-Patch erzeugt Felder wie `primaryColorTransparentHex`, die die Themes.json liest. Beim Wechsel der Marke ersetzt du nur den Teil zwischen `BEGIN` und `END`.

### Aufgabe „Classic-Themes zurücksetzen“
Eigene Aufgabe auf der Startseite. Klickt jemand in Studio auf ein Theme, hängen die klassischen Controls am Modern-Theme, und `App.Theme` verliert die Variable. Die Aufgabe setzt beides zurück: App exportieren, im Tool ablegen, erzeugte Datei importieren. Das aktive klassische Theme wird auf das eigene Theme der Themes.json gesetzt. `App.Theme` wird nur angefasst, wenn dort ein einfacher Theme-Name steht. Eine eigene Formel bleibt unverändert. Variablenname und App-Filter lassen sich wie oben einstellen.

## Voraussetzungen

- Ein aktueller Browser (Chrome, Edge, Firefox, Safari).
- Eine Canvas-App, die als Paket exportiert werden kann.
- Die klassischen Controls müssen über `defaults.*` laufen. Das passt zu den Komponenten des [Power Apps Design Toolkits](https://github.com/pnp/powerapps-designtoolkit), ist aber auch für eigene Apps nutzbar.
- Berechtigung, Pakete oder Solutions zu importieren.

## Bekannte Grenzen

| Thema | Stand |
|---|---|
| Import der erzeugten Dateien | getestet mit einem Export-Paket einer frischen Canvas-App, Themes.json und Start-Theme, Zurücksetzen |
| Format von Modern-Themes, `App.Theme` und Variable | identisch mit dem, was Studio exportiert (verglichen mit eigenen Exporten) |
| Light/Dark mit Palette-Überschreibungen | im Tool nicht erzeugbar. Über YAML eingefügte `ColorOverrides` werden übernommen. |
| Manueller Weg mit der Power Platform CLI | in der Doku beschrieben, aber nicht selbst ausgeführt |
| Von Hand gezippte `.msapp` | ungeprüft, ob Studio sie annimmt |
| OnStart direkt in die App schreiben | bewusst nicht enthalten, nur Text zum Kopieren |
| Button-Schrift auf dunklen Designs | Luises Zuordnung nutzt die Hintergrundfarbe als Schrift auf Primärflächen, bei dunklem Hintergrund kann das schwach sein (die Kontrastprüfung weist darauf hin) |
| Schriften außerhalb der Power-Apps-Liste | funktionieren nur auf Geräten, die sie installiert haben, sonst greift die Rückfallebene (zuletzt Arial) |
| CI aus SharePoint | das Tool erzeugt nur den Power-Fx-Text. Nur Primär- und Sekundärfarbe sind aus der Liste steuerbar. |

## Häufige Fehler

| Beobachtung | Ursache und Abhilfe |
|---|---|
| Klassische Controls zeigen Fehler oder bleiben grau | `defaults` fehlt, weil der OnStart nicht gelaufen ist. Block einfügen und App neu starten. |
| Syntaxfehler beim Einfügen des Blocks | Deutsche Oberfläche: im Tool „Deutsch“ wählen. |
| Import bricht mit Namenskonflikt ab | „Aktualisieren“ wählen oder im Tool „App umbenennen“ nutzen. |
| Klassische Controls zeigen `App.Theme.Colors.…` | In Studio wurde ein Theme angeklickt. Aufgabe „Classic-Themes zurücksetzen“ nutzen. |
| Eigene Farbe kommt nicht an | Ein bereits eingefügtes Control kann feste Werte tragen. Control löschen und neu einfügen. |

## Repository-Aufbau

```text
.
├── .gitignore
├── README.md
├── LICENSE
├── THIRD-PARTY-NOTICES.md
├── tool/
│   └── PowerApps-Personalisierung.html
└── docs/
    └── Themes-json_Zusammenfassung.md
```

## Entwicklung

Das Tool ist eine einzelne HTML-Datei mit eingebettetem JavaScript. Die Bibliothek JSZip (Version 3.10.1) ist direkt enthalten, es gibt keinen Build-Schritt und keine Netzwerkaufrufe. Im Browser liegen gespeicherte Marken im `localStorage` unter dem Schlüssel `themes_einsetzen_marken`, die Wahl des Schalters „Erklärungen anzeigen“ unter `themes_einsetzen_hilfe`. Neue Aufgaben kommen als Panel, Eintrag in `TITLES` und `FLOWS` und Karte auf der Startseite dazu. Das Skript ist in drei Blöcke geteilt: JSZip, Kernlogik (ZIP-Verarbeitung, Themes.json, OnStart-Text, Kontrast) und Oberfläche. Automatisierte Tests gibt es im Repository bisher nicht. Die Themes.json-Änderungen sind aus dem Vergleich des Material-Design-Templates (MD_Template v1.2) mit dem unveränderten Standard abgeleitet und werden auf die Themes.json der jeweiligen App angewendet. Details und die drei bewussten Abweichungen vom Original stehen in der Zusammenfassung unter `docs/`. Die Herkunft der übernommenen Inhalte und die Lizenztexte stehen in `THIRD-PARTY-NOTICES.md`.

## Kontakt

Fragen, Fehler und Ideen gern über Issues in diesem Repository oder per Mail an daniela@theraccoonway.de.

## Lizenz und Danksagung

Dieses Repository steht unter der **MIT-Lizenz**, siehe [LICENSE](LICENSE).

Das Tool beruht zum Teil auf der Arbeit anderer:

- Die Themes.json-Anpassungen gehen auf das **Power Apps Design Toolkit** zurück, das [Luise Freese](https://twitter.com/LuiseFreese) und Robin Rosengrün gebaut haben ([pnp/powerapps-designtoolkit](https://github.com/pnp/powerapps-designtoolkit), MIT-Lizenz, © Microsoft 365 Community). Vielen Dank dafür.
- Enthalten ist [JSZip](https://github.com/Stuk/jszip) (MIT oder GPLv3, hier unter MIT genutzt). Es enthält wiederum pako (MIT und zlib).

Die vollständigen Lizenztexte und Hinweise stehen in [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

Dieses Projekt ist nicht von Microsoft.
