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
#date "+%d`DaySuffix date +%d` %B %Y" -d "last Sun"
Date=`date "+%Y-%m-%d" -d "last Sun"`
Record=0
morningRecording=`jq ".services[${Record}]" services.json | jq '.["morningRecording"]'`
morningMinisters=`jq ".services[${Record}]" services.json | jq '.["morningMinisters"]' | sed 's/\((.*)\)//g' | sed 's/,/_/g' | sed 's/\ //g' | sed 's/\"//g'`
afternoonRecording=`jq ".services[${Record}]" services.json | jq '.["afternoonRecording"]'`
afternoonMinisters=`jq ".services[${Record}]" services.json | jq '.["afternoonMinisters"]' | sed 's/\((.*)\)//g' | sed 's/,/_/g' | sed 's/\ //g' | sed 's/\"//g'`
eveningRecording=`jq ".services[${Record}]" services.json | jq '.["eveningRecording"]'`
FilenameAM="ACCN-$morningMinisters-$Date AM"
FilenamePM="ACCN-$afternoonMinisters-$Date PM"
FilenameSinging="ACCN-Singing-$Date"
echo $Date
echo $morningRecording
echo $morningMinisters
echo $afternoonRecording
echo $afternoonMinisters
echo $eveningRecording
echo $FilenameAM
echo $FilenamePM
echo $FilenameSinging
echo wget $morningRecording -O $FilenameAM.mp3
echo id3tool -t "$FilenameAM" -r "$morningMinisters" -y `date "+%Y"` "$FilenameAM.mp3"
echo wget $afternoonRecording -O $FilenamePM.mp3
echo id3tool -t "$FilenamePM" -r "$afternoonMinisters" -y `date "+%Y"` "$FilenamePM.mp3"
