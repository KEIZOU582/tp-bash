
#!/bin/bash
set -Eeuo pipefail

DOSSIER="${1:-data}"
DESTINATION="backups"

if [ ! -d "$DOSSIER" ]; then
    echo "Erreur : le dossier '$DOSSIER' n'existe pas." >&2
    exit 1
fi

mkdir -p "$DESTINATION"

DATE=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE="$DESTINATION/backup_$DATE.tar.gz"

tar -czf "$ARCHIVE" "$DOSSIER"

echo "Sauvegarde créée : $ARCHIVE"

for fichier in "$DESTINATION"/*.tar.gz; do
    [ -f "$fichier" ] || continue

    if find "$fichier" -maxdepth 0 -mtime +7 -print -quit | grep -q .; then
        rm -- "$fichier"
        echo "Ancienne sauvegarde supprimée : $fichier"
    fi
done

