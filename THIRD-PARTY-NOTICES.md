# Hinweise zu Drittinhalten

Dieses Repository enthält Inhalte, die auf Arbeiten anderer beruhen oder deren Code enthalten. Die Lizenztexte stehen hier, wie es die jeweiligen Lizenzen verlangen.

| Bestandteil | Verwendet in | Lizenz |
|---|---|---|
| Power Apps Design Toolkit (Material Design component library) | Themes.json-Anpassungen im Tool und in der Dokumentation | MIT |
| JSZip 3.10.1 | eingebettet in `tool/PowerApps-Personalisierung.html` | MIT oder GPLv3, hier unter MIT genutzt |
| pako (Teil von JSZip) | eingebettet in JSZip | MIT und zlib |

## 1. Power Apps Design Toolkit

- **Quelle:** <https://github.com/pnp/powerapps-designtoolkit>
- **Urheber:** Das Material-Design-Template wurde von Luise Freese und Robin Rosengrün gebaut. Das Repository steht unter der MIT-Lizenz, Copyright Microsoft 365 Community.
- **Was daraus stammt:**
  - Die Anpassungen der Themes.json, die das Tool vornimmt: 34 Palette-Einträge und 128 Style-Werte. Sie sind aus dem Vergleich des Templates `MD_Template v1.2` mit dem unveränderten Standard-Theme abgeleitet. Drei Stellen weichen bewusst vom Original ab, sie stehen in `docs/Themes-json_Zusammenfassung.md`.
  - Das Muster mit dem Record `defaults` und den Hex-Feldern über `Match(JSON(…))`, nach dem der OnStart-Block aufgebaut ist.
- **Änderungen:** Das Tool wendet die Anpassungen auf die Themes.json einer beliebigen App an und ergänzt eigene Funktionen. Es ist kein Teil des Toolkits und wird von dessen Urhebern nicht unterstützt.

```text
MIT License

Copyright (c) 2022 Microsoft 365 Community

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 2. JSZip

- **Quelle:** <https://github.com/Stuk/jszip>, Version 3.10.1
- **Lizenz:** JSZip ist doppelt lizenziert, wahlweise unter der MIT-Lizenz oder der GPLv3. Das Tool nutzt es unter der **MIT-Lizenz**.
- **Verwendung:** Die Bibliothek steckt unverändert in `tool/PowerApps-Personalisierung.html`. Sie liest und schreibt dort die ZIP-Dateien im Browser.

```text
The MIT License

Copyright (c) 2009-2016 Stuart Knightley, David Duponchel, Franz Buchinger, António Afonso

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

## 3. pako

- **Quelle:** <https://github.com/nodeca/pako> (zlib für JavaScript)
- **Verwendung:** JSZip enthält pako. Es steckt damit mittelbar in `tool/PowerApps-Personalisierung.html`.
- **Lizenz:** `(MIT AND Zlib)`. Das gilt für beide Teile gleichzeitig: den MIT-Teil von pako und den zlib-Teil des portierten Codes.

```text
(The MIT License)

Copyright (C) 2014-2017 by Vitaly Puzrin and Andrei Tuputcyn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

Der zlib-Teil steht unter der üblichen zlib-Lizenz:

```text
ZLib License

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
```

Die Copyright-Zeile des zlib-Anteils steht in der Original-Lizenzdatei: <https://github.com/nodeca/pako/blob/main/LICENSE>. Ich konnte sie nicht vollständig prüfen. Wenn du ganz genau sein willst, übernimm sie von dort in diese Datei.
