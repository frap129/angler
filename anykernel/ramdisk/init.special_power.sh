#!/system/bin/sh

################################################################################
# helper functions to allow Android init like script

function write() {
    echo -n $2 > $1
}

function copy() {
    cat $1 > $2
}

function get-set-forall() {
    for f in $1 ; do
        cat $f
        write $f $2
    done
}

################################################################################

# Setting B.L scheduler parameters
get-set-forall /sys/devices/system/cpu/cpu*/sched_mostly_idle_load 20
get-set-forall /sys/devices/system/cpu/cpu*/sched_mostly_idle_nr_run 3

# devfreq
get-set-forall /sys/class/devfreq/qcom,cpubw*/governor bw_hwmon
restorecon -R /sys/class/devfreq/qcom,cpubw*
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/sample_ms 4
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/io_percent 34
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/hist_memory 20
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/hyst_length 10
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/low_power_ceil_mbps 0
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/low_power_io_percent 34
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/low_power_delay 20
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/guard_band_mbps 0
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/up_scale 250
get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/idle_mbps 1600
get-set-forall /sys/class/devfreq/qcom,mincpubw*/governor cpufreq

# Apply fq pie packet sched
tc qdisc add dev wlan0 root fq_pie
tc qdisc add dev rmnet_data0 root fq_pie
