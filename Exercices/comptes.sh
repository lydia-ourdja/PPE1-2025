#!/usr/bin/bash

echo "nombre de ligne avec le mot Location en 2016:$(cat 2016/*.ann | grep "Location" | wc -l)"
echo "nombre de ligne avec le mot Location en 2017:$(cat 2017/*.ann | grep "Location" | wc -l)"
echo "nombre de ligne avec le mot Location en 2018:$(cat 2018/*.ann | grep "Location" | wc -l)"
