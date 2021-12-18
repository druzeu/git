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

if [[ $2 != '' ]]
then
  jq ".services[${Record}]" services.json
  exit
fi
Current=`pwd`
cd /var/lib/minidlna/movies/Other/Church/Services/2021tillNow
serviceDate=`jq ".services[${Record}]" $Current/services.json | jq '.["serviceDate"]' | sed 's/st//g;s/nd//g;s/rd//g;s/th//g;s/\"//g'`
Date=`date "+%Y-%m-%d" -d "$serviceDate"`
DateYear=`date "+%Y" -d "$serviceDate"`
morningRecording=`jq ".services[${Record}]" $Current/services.json | jq '.["morningRecording"]' | sed 's/\"//g'`
morningMinisters=`jq ".services[${Record}]" $Current/services.json | jq '.["morningMinisters"]' | sed 's/\((.*)\)//g;s/,/_/g;s/\"//g;s/\ //g'`
afternoonRecording=`jq ".services[${Record}]" $Current/services.json | jq '.["afternoonRecording"]' | sed 's/\"//g'`
afternoonMinisters=`jq ".services[${Record}]" $Current/services.json | jq '.["afternoonMinisters"]' | sed 's/\((.*)\)//g' | sed 's/,/_/g' | sed 's/\ //g' | sed 's/\"//g'`
eveningRecording=`jq ".services[${Record}]" $Current/services.json | jq '.["eveningRecording"]' | sed 's/\"//g'`
FilenameAM="ACCN-$morningMinisters-$Date AM"
FilenamePM="ACCN-$afternoonMinisters-$Date PM"
FilenameSinging="ACCN-Singing-$Date"
#echo $Date
#echo $serviceDate
#echo $morningRecording
#echo $morningMinisters
#echo $afternoonRecording
#echo $afternoonMinisters
#echo $eveningRecording
#echo $FilenameAM
#echo $FilenamePM
#echo $FilenameSinging
#echo wget $morningRecording -O $FilenameAM.mp3
#echo id3tool -t "$FilenameAM" -r "$morningMinisters" -y `date "+%Y"` "$FilenameAM.mp3"
#echo wget $afternoonRecording -O $FilenamePM.mp3
#echo id3tool -t "$FilenamePM" -r "$afternoonMinisters" -y `date "+%Y"` "$FilenamePM.mp3"
wget -c -O "$FilenameAM.mp3" $morningRecording
id3tool -t "$FilenameAM" -r "$morningMinisters" -y `date "+%Y"` "$FilenameAM.mp3"
wget -c -O "$FilenamePM.mp3" $afternoonRecording
id3tool -t "$FilenamePM" -r "$afternoonMinisters" -y `date "+%Y"` "$FilenamePM.mp3"
wget -c -O "$FilenameSinging.mp3" $eveningRecording
id3tool -t "$FilenameSinging" -r "Singing" -y $DateYear "$FilenameSinging.mp3"
rm $Current/services.json
