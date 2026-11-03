
#!/bin/bash
set -Eeuo pipefail

URL="${1:-}"

if [ -z "$URL" ]; then
    echo "Usage : ./ci.sh URL_DU_DEPOT" >&2
    exit 1
fi

LOG="ci.log"

journaliser() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

REPERTOIRE="projet-ci"

if [ -d "$REPERTOIRE/.git" ]; then
    journaliser "Mise a jour du depot"
    git -C "$REPERTOIRE" pull
else
    journaliser "Clonage du depot"
    git clone "$URL" "$REPERTOIRE"
fi

journaliser "Execution des tests"

# Test de demonstration : verifier que le depot contient des fichiers
if [ -n "$(find "$REPERTOIRE" -type f -not -path '*/.git/*' -print -quit)" ]; then
    journaliser "Tests reussis"
    exit 0
else
    journaliser "Echec : aucun fichier trouve"
    exit 1
fi
