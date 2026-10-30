#!/bin/sh
# Bereitet einen Release vor: prüft main auf verbotene Namen und legt einen Schnappschuss-Commit auf "public" an.
# Gepusht wird nichts. Die Namensliste liegt bewusst außerhalb des Repos.
set -e
LIST="$HOME/.config/powerapps-personalization/verboten.txt"
[ -f "$LIST" ] || { echo "Namensliste fehlt: $LIST" >&2; exit 1; }
[ "$(git rev-parse --abbrev-ref HEAD)" = main ] && [ -z "$(git status --porcelain)" ] || { echo "Bitte auf einem sauberen main starten." >&2; exit 1; }
if git grep -n -I -i -F -f "$LIST" main --; then echo "Verbotener Name im Dateistand, Abbruch." >&2; exit 1; fi
tree=$(git rev-parse 'main^{tree}')
parent=$(git rev-parse -q --verify refs/heads/public || true)
new=$(git commit-tree "$tree" ${parent:+-p "$parent"} -m "${1:-Release}")
git update-ref refs/heads/public "$new"
echo "public steht auf $new. Prüfen, dann: git push community public:main"
