 #!/usr/bin/bash
#$1 c'est l'année ,et $2 c'est l'entitée nommée
 grep "$1" "$2"/*.ann | wc -l
