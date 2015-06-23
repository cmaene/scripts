#!/bin/bash

# acknowledgement:
# this was taken from "Open Source Geospatial Tools" book, p67
# authors: Daniel Mclnerney, Pieter Kempeneers

# cd to a directory with image files for which we want to check duplicates
# awk has a command line option "-F' with which we can specify the delimiter.

echo "${PWD##*/}"
echo "checking duplicates.."

for IMAGE in $(gdalmanage identify -r LE70400372007294EDC00 | awk -F : '{print $1}'); do
    gdalinfo -checksum $IMAGE | grep Checksum | awk -v IM=$IMAGE -F = '{print IM, $2}'
done | sort -nk2 > list.txt
sort -unk2 list.txt > list_unique.txt
diff list.txt list_unique.txt > duplicates.txt
echo "outputs are: list.txt, list_unique.txt, duplicates.txt"

#cat list.txt
#echo
#cat list_unique.txt
#echo
#cat duplicates.txt
