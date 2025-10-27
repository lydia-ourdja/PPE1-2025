#!/bin/bash

if [ $# -eq 0 ]; then
    echo "erreur :il faut faire  $0 <fichier_urls>"
    exit 1
fi

fichiertxt=$1
sortie="../tableaux/tableau-fr.tsv"
printf "num\tURL\tHTTP_Code\tEncodage\tnb_mots\n" > "$sortie"
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

    printf "%s\t%s\t%s\t%s\t%s\n" "$num" "$url" "$http_code" "$encodage" "$nb_mots" >> "$sortie"
done < "$fichiertxt"

echo "Résultats enregistrés dans $sortie"
