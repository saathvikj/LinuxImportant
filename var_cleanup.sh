#!/bin/bash
#####################################################################################################################
# ScriptName :  var_cleanup.sh
# LocationOfScript : /suptools/CAM_ESM_GBL_CLOUD_AZR/scripts
# Author : Amit Suneja
# Purpose :   to clear space from /var file system . specifically from /var/cache/yum  and /var/log/audit
# OutputLogFile : /suptools/CAM_ESM_GBL_CLOUD_AZR/scripts_logs/var_cleanup_`hostname`_$todayDate_$RANDOM.log
# note : Please schedule it only once to run via cron in 24 Hours.
#####################################################################################################################
# Create a lock file when u start a script
lockfile=/var/tmp/var_cleanup.lock
if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null; then
        trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT



umask 0022
myNumber=5
todayDate=`/bin/date +'%m-%d-%Y'`
currentTime=`date +'%r'|sed "s/ /-/"`
logDir=/suptools/CAM_ESM_GBL_CLOUD_AZR/scripts_logs/$todayDate/var_check/
logFile=/suptools/CAM_ESM_GBL_CLOUD_AZR/scripts_logs/$todayDate/var_check/var_cleanup_`hostname`_$RANDOM.log
mkdir -p $logDir
myDir1=/var/log/audit/
myDir2=/var/lib/rsyslog/

if [ -s logFile ]
then
    rm logFile
fi

echo "Script Started at $todayDate at $currentTime" > $logFile
echo "current utilization of /var is as below" >> $logFile
df -h /var >> $logFile
echo "current utilization of $myDir1 is as below" >> $logFile
df -h $myDir1 >> $logFile
echo " " >> $logFile

NumberOfFiles=`ls -ltr $myDir1 | wc -l`
NumberofUncompressedFiles=`ls -ltr $myDir1 | egrep -v "total|.gz|imjournal.state|lad_mdsd_queue_syslog.qi" | wc -l`
if [ $NumberofUncompressedFiles -gt $myNumber ]
then
NumberOfHead=`expr $NumberofUncompressedFiles - 5`
echo "Total Number of Files in $myDir1: $NumberOfFiles" >> $logFile
echo "Number OF Files i am going to Compress in $myDir1: $NumberOfHead out of $NumberofUncompressedFiles" >> $logFile
ls -ltr $myDir1 | egrep -v "total|.gz|imjournal.state|lad_mdsd_queue_syslog.qi" | head -$NumberOfHead | awk '{print "gzip -f -9 /var/log/audit/"$9}' > /tmp/auditcleanup.sh
sh -x /tmp/auditcleanup.sh >> $logFile
echo " " >> $logFile
echo " " >> $logFile
else
echo "no file to compress " >> $logFile
fi

NumberOfFiles=`ls -ltr $myDir2 | wc -l`
NumberofUncompressedFiles=`ls -ltr $myDir2 | egrep -v "total|.gz|imjournal.state|lad_mdsd_queue_syslog.qi" | wc -l`
if [ $NumberofUncompressedFiles -gt $myNumber ]
then
NumberOfHead=`expr $NumberofUncompressedFiles - 5`
echo "Total Number of Files in $myDir2: $NumberOfFiles" >> $logFile
echo "Number OF Files i am going to Compress in $myDir2: $NumberOfHead out of $NumberofUncompressedFiles" >> $logFile
ls -ltr $myDir2 | egrep -v "total|.gz|imjournal.state|lad_mdsd_queue_syslog.qi" | head -$NumberOfHead | awk '{print "gzip -f -9 /var/lib/rsyslog/"$9}' > /tmp/auditcleanup.sh
sh -x /tmp/auditcleanup.sh >> $logFile
echo " " >> $logFile
echo " " >> $logFile
else
echo "no file to compress " >> $logFile
fi

echo "cleaning up /var/cache/yum by executing yum clean all" >> $logFile
yum clean all > /dev/null
echo " " >> $logFile
echo " " >> $logFile

todayDate=`/bin/date +'%m-%d-%Y'`
currentTime=`date +'%r'|sed "s/ /-/"`
echo "Script Ended at $todayDate at $currentTime" >> $logFile
df -h /var >> $logFile
df -h $myDir1 >> $logFile

rm -f "$lockfile"
        trap - INT TERM EXIT
else
        echo "Lock Exists: $lockfile owned by $(cat $lockfile)"
fi
