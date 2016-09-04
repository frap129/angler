#!/system/bin/sh
# Author: frap129
# Credits: Ideas - SoniCron, Awesome Scripts - Alcolawl, Configuration - xSilas43

#Wait for ramdisk and other processes to finish asserting changes
sleep 45;

#Set I/O sched
echo maple > /sys/block/mmcblk0/queue/scheduler
echo 1024 > /sys/block/mmcblk0/queue/read_ahead_kb
