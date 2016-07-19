#!/system/bin/sh
#Author: xSilas43 and frap129
#Credits: Ideas - SoniCron, Awesome Scripts - Alcolawl, Configuration - xSilas43
#Device: angler
#Codename: ChillSide
#Build: stable
#Version: R1
#Updated 30/03/2016

echo 1024 > /sys/block/mmcblk0/queue/read_ahead_kb

#turn on all cores
chmod 644 /sys/devices/system/cpu/online
echo 0-7 > /sys/devices/system/cpu/online
chmod 444 /sys/devices/system/cpu/online
echo 1 > /sys/devices/system/cpu/cpu0/online
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online
echo 1 > /sys/devices/system/cpu/cpu4/online
echo 1 > /sys/devices/system/cpu/cpu5/online

#Little Settings
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo chill > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 384000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 1708000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
#Tweak Chill Governor
echo 50 > /sys/devices/system/cpu/cpu0/cpufreq/chill/down_threshold
echo 2000 > /sys/devices/system/cpu/cpu0/cpufreq/chill/sampling_rate
echo 95 > /sys/devices/system/cpu/cpu0/cpufreq/chill/up_threshold
echo 10 > /sys/devices/system/cpu/cpu0/cpufreq/chill/sleep_depth
echo 5 > /sys/devices/system/cpu/cpu0/cpufreq/chill/freq_step
echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/chill/ignore_nice_load
#Big Settings
chmod 644 /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo chill > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
chmod 444 /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
chmod 644 /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo 633000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
chmod 444 /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
chmod 644 /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
echo 1958400 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
#Tweak Chill Governor
echo 65 > /sys/devices/system/cpu/cpu4/cpufreq/chill/down_threshold
echo 20000 > /sys/devices/system/cpu/cpu4/cpufreq/chill/sampling_rate
echo 95 > /sys/devices/system/cpu/cpu4/cpufreq/chill/up_threshold
echo 3 > /sys/devices/system/cpu/cpu4/cpufreq/chill/sleep_depth
echo 5 > /sys/devices/system/cpu/cpu4/cpufreq/chill/freq_step
echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/chill/ignore_nice_load
echo 0:960000 1:960000 2:960000 3:960000 4:0 5:0 6:0 7:0 > /sys/module/cpu_boost/parameters/input_boost_freq
echo 0 > /sys/module/cpu_boost/parameters/boost_ms
echo 40 > /sys/module/cpu_boost/parameters/input_boost_ms
echo 1 > /sys/module/cpu_boost/parameters/input_boost_enabled
echo 0 > /sys/module/msm_thermal/core_control/enabled
echo N > /sys/module/msm_thermal/parameters/enabled
