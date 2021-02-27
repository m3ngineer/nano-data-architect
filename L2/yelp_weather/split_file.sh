#!/bin/bash

FILENAME=~/Downloads/yelp_dataset/yelp_academic_dataset_business.json

NEW_FILENAME=`echo $FILENAME | awk -F/ '{print $NF}' | awk -F. '{print $1}'`

HDR=$(head -1 $FILENAME)

split -b 50m $FILENAME xyz

n=1

for f in xyz*

do

     if [ $n -gt 1 ]; then

          echo $HDR > $NEW_FILENAME_${n}.json

     fi
     cat $f >> ${NEW_FILENAME}_${n}.json

     rm $f

     ((n++))

done
