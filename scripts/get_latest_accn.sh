#!/bin/bash
DaySuffix() {
#  case `date +%d` in
  x="$*"
  case $x in
    1|21|31) echo "st";;
    2|22)    echo "nd";;
    3|23)    echo "rd";;
    *)       echo "th";;
  esac
}
#for (( i = 1; i <= 31; i++))
#do
#	echo $i`DaySuffix "$i"`
#done
date "+%d`DaySuffix date +%d` %B %Y" -d "last Sun"
jq '.services[0]' services.json | jq '.["morningRecording"]'
jq '.services[0]' services.json | jq '.["afternoonRecording"]'
