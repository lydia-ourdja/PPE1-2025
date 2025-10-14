
#!/bin/bash
echo " classement des lieux "

grep "Location " ./$1/$2*.ann  | cut -d ' ' -f3-| sort  | uniq -c | sort -nr | head -n$3

