#!/bin/bash
#####################################################################################################################
lockfile=/var/tmp/check_vfstab.lock
if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null; then
        trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT

umask 0022
/bin/clear
COUNTER=0
todayDate=`/bin/date +'%m-%d-%Y'`
logdir=/suptools/CAM_ESM_GBL_CLOUD_AZR/scripts_logs/$todayDate/fstab/
logfile=$logdir/check_vfstab_`hostname`_$RANDOM.out
mkdir -p $logdir


df -h | egrep -v "^Filesystem|^tmpfs|^devtmpfs|sda2|sda1|sdb1" | awk '{print $6}' > /tmp/mount_points
df -h | egrep -v "^Filesystem|^tmpfs|^devtmpfs|sda2|sda1|sdb1" | awk '{print $1}' > /tmp/device_to_mount
echo "copying fstab to /tmp/fstab to perform checks"
cat /etc/fstab  | egrep -v "^#|^$" > /tmp/fstab
for mount_point in `cat /tmp/mount_points`
do
grep $mount_point /tmp/fstab > /dev/null
if [ $? -ne 0 ]
then
echo `hostname` "$mount_point is currently mounted,But does not have entry in fstab, Please update fstab and rerun the script" >> $logfile
fi
done

for device in `cat /tmp/device_to_mount`
do
grep $device /tmp/fstab > /dev/null
if [ $? -ne 0 ]
then
echo `hostname` "$device entry in fstab does not exist or incorrect, Please update fstab and rerun the script" >> $logfile
fi
done


while read LINE
do
COUNTER=$(expr $COUNTER + 1)
NumbeOfColumnsInFile=`echo $LINE | awk -F' ' '{print NF; exit}'`
if [ $NumbeOfColumnsInFile -ne 6 ]
then
echo `hostname` "$COUNTER Line in fstab is incorrect" >> $logfile
fi
done </tmp/fstab




rm -f "$lockfile"
        trap - INT TERM EXIT
else
        echo "Lock Exists: $lockfile owned by $(cat $lockfile)"
fi
