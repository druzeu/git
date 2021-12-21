#!/bin/bash
if [[ ! -f services.json ]]
then
  wget https://www.dl.dropboxusercontent.com/s/6fx39oixavoqcgt/services.json
fi
if [[ $1 == '' ]]
then
  Record=0
else
  Record=$1
fi

Current=`pwd`
serviceDate=`jq ".services[${Record}]" $Current/services.json | jq '.["serviceDate"]' | sed 's/\([0-9]\)st/\1/g;s/nd//g;s/rd//g;s/th//g;s/\"//g'`
Date=`date "+%Y-%m-%d" -d "$serviceDate"`
DateYear=`date "+%Y" -d "$serviceDate"`
morningRecording=`jq ".services[${Record}]" $Current/services.json | jq '.["morningRecording"]' | sed 's/\"//g'`
morningMinisters=`jq ".services[${Record}]" $Current/services.json | jq '.["morningMinisters"]' | sed 's/\((.*)\)//g;s/,/_/g;s/\"//g;s/\ //g'`
afternoonRecording=`jq ".services[${Record}]" $Current/services.json | jq '.["afternoonRecording"]' | sed 's/\"//g'`
afternoonMinisters=`jq ".services[${Record}]" $Current/services.json | jq '.["afternoonMinisters"]' | sed 's/\((.*)\)//g' | sed 's/,/_/g' | sed 's/\ //g' | sed 's/\"//g'`
eveningRecording=`jq ".services[${Record}]" $Current/services.json | jq '.["eveningRecording"]' | sed 's/\"//g'`
FilenameAM="$morningMinisters-$Date AM"
FilenamePM="$afternoonMinisters-$Date PM"
FilenameSinging="Singing-$Date"

if [[ $2 != '' ]]
then
  jq ".services[${Record}]" services.json
  echo $Date
  echo $serviceDate
  echo $morningRecording
  echo $morningMinisters
  echo $afternoonRecording
  echo $afternoonMinisters
  echo $eveningRecording
  echo $FilenameAM
  echo $FilenamePM
  echo $FilenameSinging
  echo wget $morningRecording -O $FilenameAM.mp3
  echo id3tool -t "$FilenameAM" -r "$morningMinisters" -y $DateYear "$FilenameAM.mp3"
  echo wget $afternoonRecording -O $FilenamePM.mp3
  echo id3tool -t "$FilenamePM" -r "$afternoonMinisters" -y $DateYear "$FilenamePM.mp3"
  exit
fi
id3tool -t "$FilenameAM" -c "$morningReading"-r "$morningMinisters" -y $DateYear "$FilenameAM.mp3"
id3tool -t "$FilenamePM" -c "$afternoonReading" -r "$afternoonMinisters" -y $DateYear "$FilenamePM.mp3"
id3tool -t "$FilenameSinging" -r "Singing" -y $DateYear "$FilenameSinging.mp3"
