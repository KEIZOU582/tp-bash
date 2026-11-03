
#!/bin/bash

SEUIL=${1:-80}

UTILISATION=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$UTILISATION" -ge "$SEUIL" ]; then
    echo "ALERTE : espace disque utilise a ${UTILISATION}%"
    exit 1
else
    echo "OK : espace disque utilise a ${UTILISATION}%"
    exit 0
fi
