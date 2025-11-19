#!/bin/bash

if [ $# -eq 0 ]; then
    echo "erreur :il faut faire  $0 <fichier_urls>"
    exit 1
fi

fichiertxt=$1
sortie="../tableaux/tableau-fr.html"

# Début du HTML
echo "<!DOCTYPE html>" > "$sortie"
echo "<html lang='fr'>" >> "$sortie"
echo "<head>" >> "$sortie"
echo "  <meta charset='UTF-8'>" >> "$sortie"
echo "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>" >> "$sortie"
echo "  <title>Résultats des URLs</title>" >> "$sortie"
echo "  <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css'>" >> "$sortie"
echo "</head>" >> "$sortie"
echo "<body>" >> "$sortie"
echo "<section class='section'>" >> "$sortie"
echo "<div class='container'>" >> "$sortie"
echo "<h1 class='title is-2 has-text-centered'>Mini projet: </h1>">>"$sortie"
echo "<h2 class='title is-4'>Analyse des URLs</h2>" >> "$sortie"
echo "<table class='table is-striped is-hoverable is-fullwidth is-bordered is-narrow'>" >> "$sortie"
echo "<tr><th>Num</th><th>URL</th><th>HTTP Code</th><th>Encodage</th><th>Nombre de mots</th></tr>" >> "$sortie"


num=0
while read -r url; do

    num=$((num+1))

    # En-têtes HTTP, nettoyage des \r( pour eviter le décalage dans le fichier tsv )
    http_info=$(curl -sI "$url" | tr -d '\r')

    # Code HTTP
    http_code=$(echo "$http_info" | grep -i "HTTP/" | tail -1 | awk '{print $2}')
    [ -z "$http_code" ] && http_code="inconnu"

    # Charset dans headers
    encodage=$(echo "$http_info" | grep -i "charset=" | grep -o -E 'charset=([^ ;"]+)' | cut -d= -f2 | head -n1)

    #  charset dans <meta>
    if [ -z "$encodage" ]; then
        encodage=$(curl -s "$url" | tr -d '\r' | grep -i "<meta" | grep -i "charset=" \ | grep -o -E 'charset=([^ ;">]+)' | cut -d= -f2 | head -n1)
    fi
    #rendre inconnu si il trouve nulpart l'encodage
    [ -z "$encodage" ] && encodage="inconnu"

    # Nombre de mots ( sed ici permet d'enlever toutes les balises HTML et de pas les comptabiliser dans le nombre de mots  )
    nb_mots=$(curl -s "$url" | sed 's/<[^>]*>//g' | wc -w)

    # Affichage

printf "<tr><td>%s</td><td><a href='%s' target='_blank'>%s</a></td><td>%s</td><td>%s</td><td>%s</td></tr>\n" \
        "$num" "$url" "$url" "$http_code" "$encodage" "$nb_mots" >> "$sortie"


done < "$fichiertxt"

# Fin du HTML

echo "</table>" >> "$sortie"
echo "</div>" >> "$sortie"   # fermeture du container
echo "</section>" >> "$sortie"   # fermeture de la section
echo "</body>" >> "$sortie"
echo "</html>" >> "$sortie"


echo "Résultats enregistrés dans $sortie"
