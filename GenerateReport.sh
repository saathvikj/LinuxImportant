#!/bin/bash
#########################################################################################################################
#  ScriptName - GenerateReport.sh											#
#  Author     - AmitSuneja												#
#  Purpose    - To generate Rapid 7 Report										#
#########################################################################################################################
if [ $# -ne 1 ] 
then 
echo "Error - illegal number of parameters"
echo "Usage - GenerateReport.sh FileName.CSV (Comma Seperated file)"
exit
fi

RawFileName=$1
IpaddressList=IPaddressList_"$RawFileName"
VanarabilitiesList=VanarabilitiesList_"$RawFileName"
FinalReport=FinalReport_"$RawFileName"

echo "Please wait sytem is generating report for you ...."
echo
echo

if [ -s $IpaddressList ]
then
echo "removing old files ...."
rm $IpaddressList
fi
if [ -s $VanarabilitiesList ]
then
echo "removing old files ...."
rm $VanarabilitiesList
fi
if [ -s $FinalReport ]
then
echo "removing old files ...."
rm $FinalReport
fi


echo "Generating List of Ipaddresses..."
cat $RawFileName | awk -F "," '{print $1}'| sort -nr | uniq > $IpaddressList
dos2unix $IpaddressList
echo "Generating List of Venerabilties" 
cat $RawFileName | awk -F"," '{print $2","$3","$4","$5","$6","$7 }' |sort -nr | uniq > $VanarabilitiesList
dos2unix $VanarabilitiesList
i=1
for IP in `cat $IpaddressList`
do
myArray[i]=$IP","
((i++))
done
echo "Generating final Report"
echo "ServicePort,VulnerabilityTestResultCode,VulnerabilityID,VulnerabilityCVEIDs,VulnerabilitySeverityLevel,VulnerabilityTitle,${myArray[*]}" > $FinalReport

while read LINE 
do
i=1

for IP in `cat $IpaddressList`
do
LINETOTEST=`echo "$IP,$LINE"`
#echo $LINETOTEST
grep "$LINETOTEST" "$RawFileName" > /dev/null
if [ `echo $?` -eq 0 ]
then
myArray[i]="yes,"
else
myArray[i]="No,"
fi
((i++))
done

echo $LINE,${myArray[*]} >> $FinalReport

done < ./"$VanarabilitiesList"


if [ -s $IpaddressList ]
then
echo "removing old files ...."
rm $IpaddressList
fi
if [ -s $VanarabilitiesList ]
then
echo "removing old files ...."
rm $VanarabilitiesList
fi
