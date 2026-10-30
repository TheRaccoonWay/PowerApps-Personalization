# Themes.json für klassische Controls: Was wir ändern und wie

Stand: 22.10.2026. Grundlage ist das Material-Design-Toolkit von Luise Freese (MD_Template v1.2) und die Themes.json der aktuellen Studio-Version.

## 1. Kurzfassung

- Klassische Controls holen ihr Aussehen aus den **Styles** der Datei `Themes.json`. Dort steht zum Beispiel, welche Farbe ein Button hat.
- Im Standard sind das feste Farben und Größen. Wir ersetzen die wichtigsten durch Verweise auf den Record **`defaults`**, den der OnStart setzt (`defaults.primaryColor`, `defaults.textColor`, …).
- Ändert sich ein Wert im OnStart, ändern sich alle klassischen Controls mit. Ein Markenwechsel besteht damit aus einem anderen OnStart-Block, nicht aus Änderungen an Controls.
- Moderne Controls laufen **nicht** über diese Datei, sondern über das Modern-Theme (`App.Theme`, siehe Abschnitt 10).

## 2. Wo die Datei liegt und wie sie aufgebaut ist

Die Themes.json steckt in der `.msapp`-Datei der App unter `References\Themes.json`. In einem Export-Paket liegt die `.msapp` unter `Microsoft.PowerApps/apps/<Nummer>/…-document.msapp`. Eine `.msapp` ist ein ZIP-Archiv.

```json
{
  "CurrentTheme": "defaultTheme",
  "CustomThemes": [
    {
      "name": "defaultTheme",
      "palette": [ { "name": "...", "value": "...", "type": "..." } ],
      "styles":  [ { "name": "...", "controlTemplateName": "...", "propertyValuesMap": [ { "property": "...", "value": "..." } ] } ]
    }
  ]
}
```

| Teil | Bedeutung |
|---|---|
| `CurrentTheme` | Name des Themes, das für klassische Controls gilt. **Wichtig:** Zeigt er auf ein anderes Theme, werden unsere Änderungen nicht gelesen. |
| `palette` | Benannte Werte (Farben, Größen, Schrift). `type` ist `c` (Farbkonstante), `x` (Formel), `n` (Zahl), `e` (Aufzählung) oder `![]` (Tabelle). Einige Einträge haben zusätzlich `phoneValue` für Telefone. |
| `styles` | Pro Control-Art eine Liste von Eigenschaften. Die Werte verweisen meist auf die Palette (`%Palette.PrimaryColor1%`). |

Der aktuelle Standard hat **71 Palette-Einträge** und **116 Styles**. Unsere erzeugte Datei hat dieselbe Anzahl, es werden nur Werte ersetzt.

## 3. So sieht die Standard-Themes.json aus (Auszug)

```json
{ "name": "ScreenBkgColor",    "value": "%Color.RESERVED%.White",      "type": "c" }
{ "name": "PrimaryColor1",     "value": "RGBA(56, 96, 178, 1)",         "type": "c" }
{ "name": "TextMainColor",     "value": "RGBA(0, 0, 0, 1)",             "type": "c" }
{ "name": "InputBkgColor",     "value": "RGBA(255, 255, 255, 1)",       "type": "c" }
{ "name": "TextBodyFontSize",  "value": "13", "phoneValue": "21",       "type": "n" }
{ "name": "TextBodyFontFace",  "value": "%Font.RESERVED%.'Open Sans'",  "type": "e" }
```

Ein Style verweist auf die Palette:

```json
{
  "name": "defaultButtonStyle",
  "controlTemplateName": "button",
  "propertyValuesMap": [
    { "property": "Color",       "value": "%Palette.TextMainColorInverted%" },
    { "property": "Fill",        "value": "%Palette.PrimaryColor1%" },
    { "property": "HoverFill",   "value": "%Palette.HoverButtonBkgColor%" },
    { "property": "RadiusTopLeft", "value": "10" }
  ]
}
```

## 4. So sieht unsere Themes.json aus (dieselben Stellen)

```json
{ "name": "ScreenBkgColor",    "value": "defaults.backgroundColor",   "type": "x" }
{ "name": "PrimaryColor1",     "value": "defaults.primaryColor",      "type": "x" }
{ "name": "TextMainColor",     "value": "defaults.textColor",         "type": "x" }
{ "name": "InputBkgColor",     "value": "defaults.elementBackgroundColor", "type": "x" }
{ "name": "TextBodyFontSize",  "value": "defaults.fontSize", "phoneValue": "21", "type": "n" }
{ "name": "TextBodyFontFace",  "value": "defaults.font",              "type": "e" }
```

`defaultButtonStyle` im Vergleich (Auszug):

| Eigenschaft | Standard | Unsere Datei |
|---|---|---|
| `Color` (Schrift) | `%Palette.TextMainColorInverted%` | `defaults.backgroundColor` |
| `Fill` | `%Palette.PrimaryColor1%` | `defaults.primaryColor` |
| `HoverFill` | `%Palette.HoverButtonBkgColor%` | `ColorFade(defaults.primaryColor, -10%)` |
| `Size` | `%Palette.TextEmphasisFontSize%` | `defaults.fontSize+6` |
| `RadiusTopLeft` (und die drei anderen Ecken) | `10` | `defaults.borderRadius` |
| `HoverColor` | `%Palette.TextMainColorInverted%` | `Self.Color` |
| `PressedFill` | `Self.Color` | `ColorFade(Self.Fill, 50%)` |
| `Width` / `Height` | nicht gesetzt | `260` / `50` |

## 5. Was genau geändert wird

Die Änderungen sind aus dem Vergleich von Luises Theme mit dem **unveränderten Standard** abgeleitet und werden auf die Themes.json der jeweiligen App angewendet:

- **34 Palette-Einträge**: 22 Formeln (Typ `x`, zum Beispiel `PrimaryColor1`, `TextMainColor`, `ScreenBkgColor`), 10 Schriftgrößen (Typ `n`, auf `defaults.fontSize` gesetzt, Überschriften `+4`, Button-Schrift `+6`), die Schrift (`TextBodyFontFace`, Typ `e`) und eine geänderte feste Farbe (`ReservedBlackColor`).
- **128 Style-Werte** in 32 Styles (Button, Textfeld, Dropdown, Combobox, DatePicker, Listbox, Lookup, Checkbox, Radio, Toggle, Slider, Rating, Icons, Charts, Import, Export, Barcode-Scanner, Tabellen und einige Label-Styles).
- **`CurrentTheme`** wird auf das eigene Theme (`defaultTheme`) gesetzt.

Die Änderungen fallen in drei Gruppen:

1. **Verweise auf `defaults.*`:** Farben, Schriftgröße (`defaults.fontSize`, Überschriften `+4`, Button-Schrift `+6`), Schrift, Radius, Eingabefüllung und Rahmendicke.
2. **Flacher Material-Stil:** Hover und Gedrückt zeigen oft auf die Fläche selbst (`Self.Fill`, `Self.Color`) statt auf eigene Farbtöne.
3. **Feste Größen:** zum Beispiel Button 260 × 50.

**Vom Original weichen wir an drei Stellen bewusst ab:**

| Stelle | Original (Luise) | Bei uns |
|---|---|---|
| `ReservedWhiteColor` | `Color.Red` (sieht nach Test-Rest aus) | bleibt Standard-Weiß |
| `TextLinkColor` | `Color.Blue` (sieht nach Test-Rest aus) | bleibt Standard |
| `DatePickerSelectedColor` | Typ `c` mit einer Formel | Typ `x` |

Neuere Standard-Einträge, die es in Luises älterer Datei noch nicht gibt (16 Palette-Einträge, 11 Styles), bleiben unverändert. Die `checksum.json` in der `.msapp` wird beim Ändern entfernt, Studio erzeugt sie neu.

## 6. Welche `defaults`-Felder gelesen werden

Die erzeugte Themes.json liest diese Felder des Records `defaults`:

`primaryColor`, `backgroundColor`, `textColor`, `elementBackgroundColor`, `disabledColor`, `inputFill`, `borderColor`, `inputBorderThickness`, `borderRadius`, `font`, `fontSize` und `primaryColorTransparentHex`.

Das letzte Feld entsteht im zweiten Block des OnStart (Hex-Patch). Nicht gelesen werden `secondaryColor`, `errorColor`, `elementBorderColor`, `elementBorderFokusColor` und `textColorGedimmt`. Sie dürfen im OnStart stehen, wirken aber bei klassischen Controls nicht.

Ohne einen ausgeführten OnStart zeigen die klassischen Controls Fehler, weil `defaults` dann nicht existiert.

Werte aus `defaults` können beim Start überschrieben werden, etwa durch die optionale SharePoint-Übernahme (Abschnitt 11). Weil `primaryColorTransparentHex` erst im zweiten Block entsteht, steht der Hex-Patch im erzeugten OnStart immer nach dieser Übernahme.

## 7. Manueller Weg (ohne das Tool)

Eine Oberfläche in Studio zum Bearbeiten der Themes.json gibt es nicht. Die Datei muss in der `.msapp` geändert werden.

**Variante A: mit der Power Platform CLI (empfohlen)**

1. App in Studio speichern und als `.msapp` herunterladen (Datei → Speichern unter → Dieser Computer) oder als Paket exportieren und die `.msapp` aus dem ZIP nehmen.
2. Auspacken: `pac canvas unpack --msapp App.msapp --sources .\src`
3. Die Datei `Themes.json` im Quellordner öffnen (bei Luise liegt sie unter `Src\Themes.json`).
4. Ändern:
   - `CurrentTheme` auf `defaultTheme` setzen.
   - Bei den Palette-Einträgen aus Abschnitt 5 `value` auf die Formel setzen und `type` auf `x` (bei Zahlen und Schrift den Typ lassen).
   - Bei den Styles aus Abschnitt 5 die Werte ersetzen oder die Eigenschaft ergänzen.
5. Packen: `pac canvas pack --sources .\src --msapp App_neu.msapp`
6. In Studio öffnen (Öffnen → Dateien durchsuchen) und in der Umgebung speichern.

**Variante B: ZIP von Hand**

1. `.msapp` in `.zip` umbenennen und entpacken.
2. `References\Themes.json` ändern und `checksum.json` löschen.
3. Wieder zippen, ohne zusätzlichen Ordner, und zurück in `.msapp` umbenennen.

Variante B ist riskanter: Die Einträge in der `.msapp` heißen mit Backslash (`References\Themes.json`), und manche ZIP-Programme schreiben sie anders. Ob Studio das annimmt, ist ungeprüft.

**In jedem Fall zusätzlich:** den OnStart-Block mit dem Record `defaults` und dem Hex-Patch einfügen (liefert das Tool als Text).

## 8. Stolpersteine

| Situation | Folge | Abhilfe |
|---|---|---|
| In Studio auf ein Theme in der Themes-Leiste klicken | Das Modern-Theme wird auf die klassischen Controls angewendet: `CurrentTheme` springt auf `modernesqueTheme`, ihre Farben zeigen `App.Theme.Colors.…`. `App.Theme` wird auf den Theme-Namen gesetzt und ersetzt dabei die Variable `vTheme`. | Bereich „Classic-Themes zurücksetzen“ im Tool (setzt `CurrentTheme` und auf Wunsch `App.Theme` zurück). Alternativ in Studio „Rückgängig machen“. |
| Neue App mit aktiven modernen Steuerelementen | Studio setzt `CurrentTheme` auf `v9WebLightTheme`. Dann wäre das eigene Theme wirkungslos. | Das Tool setzt `CurrentTheme` bei jedem Lauf auf `defaultTheme`. |
| Bereits bearbeitete App noch einmal durch das Tool schicken | Einzelne alte Werte bleiben stehen, weil der Patch sie nicht überschreibt. | Immer eine unveränderte Studio-Themes.json als Ausgang nehmen. |
| Deutsche Oberfläche in Power Apps | Der OnStart-Block mit Kommas funktioniert nicht, dort gelten `;` und `;;`. | Im Tool „Deutsch“ wählen. Funktionsnamen bleiben englisch. |
| Import eines Pakets mit gleichem App-Namen | Namenskonflikt beim Import. | Mit „Aktualisieren“ importieren oder die App umbenennen. |

## 9. Was geprüft ist und was nicht

**Geprüft:**
- Die erzeugte Datei entspricht Luises Original in allen 128 Style-Werten und in der Palette bis auf die drei bewussten Abweichungen.
- Das Format von Modern-Themes, `App.Theme` und der Variable ist identisch mit dem, was Studio in eigenen Exporten schreibt.
- Der Import eines Pakets mit erzeugter Themes.json, die klassischen Buttons mit `defaults.primaryColor` und der Reset haben im Test funktioniert.

**Nicht geprüft:**
- Der manuelle Weg mit der CLI (Pfad der Datei nach dem Auspacken aus Luises Quellcode abgeleitet, nicht selbst ausgeführt).
- Das Verhalten von Studio bei einer von Hand gezippten `.msapp`.
- Dark- und Light-Themes mit Palette-Überschreibungen (geparkt, kommt später).
- Solutions mit mehreren Apps und die Option „Nur diese App ändern“ (Logik vorhanden, nicht mit einem echten Import geprüft).
- Der SharePoint-Teil des OnStart-Blocks (Abschnitt 11) mit echter Liste und Umgebungsvariablen.

## 10. Was das Tool sonst noch in der `.msapp` ändert

Neben der Themes.json berührt das Tool je nach Auswahl diese Dateien:

| Datei in der `.msapp` | Änderung | Auswahl im Tool |
|---|---|---|
| `Properties.json` | `fluentv9controlspreview` wird auf `true` gesetzt (Moderne Steuerelemente). Fehlt der Schalter, wird er ergänzt. | Moderne Steuerelemente aktivieren |
| `References\ModernThemes.json` | Eintrag pro Theme: `BasePaletteColor`, `HueTorsion`, `Vibrancy`, optional `ColorOverrides` (16 Slots von `Darker70` bis `Lighter80`) und `Font`. Ein gleichnamiges Theme wird ersetzt. | Start-Theme anlegen oder eigene YAML-Themes |
| `Controls\1.json` und `Src\App.pa.yaml` | `App.Theme` wird auf den Theme-Namen oder, mit Variable, auf `vTheme` gesetzt. Bei der Variable trägt `ControlPropertyState` den Theme-Namen als Rückfallwert. | Start-Theme, Variable, Reset |
| `Properties.json`, `Resources\PublishInfo.json` sowie `manifest.json` und die App-JSON im Paket | Neuer App-Anzeigename (nur bei App-Paketen). | App umbenennen |
| `checksum.json` | wird entfernt, sobald die Themes.json ersetzt wurde. | automatisch |
| `Solution.xml`, `customizations.xml` | Solution-Version +1 (letzte Stelle) und neuer `AppVersion`-Zeitstempel. | automatisch bei Solutions |

Der OnStart-Block (Abschnitt 6) wird nie in die App geschrieben, er steht nur als Text im Tool.

## 11. Optional: CI aus SharePoint im OnStart

Die Themes.json ändert sich dadurch nicht, nur der OnStart-Block wird länger. Aufbau des Blocks in dieser Reihenfolge:

1. `Set(defaults, {…})` mit den Marken-Defaults.
2. Liste laden: `IfError(ClearCollect(colCI, ForAll('<Datenquelle>', {k: Trim(Title), v: Trim(Value)})); Set(ciListOk, true), Clear(colCI); Set(ciListOk, false))`.
3. `Set(defaults, Patch(defaults, {primaryColor: …, secondaryColor: …}))`. Pro Farbe gilt: Wert zum Schlüssel aus `colCI` holen, bei `#RRGGBB` mit `ColorValue` übernehmen, sonst den Default behalten.
4. Hex-Patch (`primaryColorHex`, `primaryColorTransparentHex` usw.), jetzt auf Basis der übernommenen Farben.
5. `Set(ciSource, …)` als Debug-Wert (`SharePoint` oder `Default`).
6. Optional `Set(vTheme, …)`.

| Punkt | Verhalten |
|---|---|
| Steuerbare Felder | nur `primaryColor` und `secondaryColor` |
| Ungültiger oder fehlender Wert | Default bleibt |
| Liste nicht erreichbar | `IfError` fängt es ab, `ciListOk = false`, alle Defaults gelten |
| Datenquellenname | immer in Hochkommas, enthaltene `'` werden verdoppelt |
| Deutsche Oberfläche | Namen in Hochkommas bleiben bei der Umwandlung (`,` → `;`, `;` → `;;`) unverändert |
| Modern-Theme | wird **nicht** aus der Liste gesteuert, es nutzt die Farbe aus Bereich 1 |

Der letzte Punkt ist wichtig: Das Modern-Theme (`App.Theme`) wird beim Erzeugen der Datei festgeschrieben. Ändert die Liste die Primärfarbe, folgen die klassischen Controls, die modernen Controls nicht, bis ein neues Theme erzeugt wird.

**Einrichtung:** App aus der Solution heraus öffnen, SharePoint-Datenquelle über *Erweitert* mit Site und Liste je als Umgebungsvariable (Typ Datenquelle) hinzufügen, den Anzeigenamen der Datenquelle im Tool eintragen. Liste mit den Spalten `Title` (Schlüssel) und `Value` (Einzelne Textzeile) und den zwei Einträgen `primaryColor`, `secondaryColor`. Leserechte für alle App-Nutzer. Änderungen am Wert der Umgebungsvariable können bis zu einer Stunde zwischengespeichert sein.
