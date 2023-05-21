#
# Copyright (C) 2023 StatiXOS
# SPDX-License-Identifier: Apache-2.0
#

# Custom tuning for Yupik SoC

# Runtime fs tuning
echo 128 > /sys/block/sda/queue/read_ahead_kb
echo 128 > /sys/block/sda/queue/nr_requests
echo 1 > /sys/block/sda/queue/iostats
echo 128 > /sys/block/dm-0/queue/read_ahead_kb
echo 128 > /sys/block/dm-1/queue/read_ahead_kb
echo 128 > /sys/block/dm-2/queue/read_ahead_kb
echo 128 > /sys/block/dm-3/queue/read_ahead_kb
echo 128 > /sys/block/dm-4/queue/read_ahead_kb
echo 128 > /sys/block/dm-5/queue/read_ahead_kb
echo 128 > /sys/block/dm-6/queue/read_ahead_kb
echo 128 > /sys/block/dm-7/queue/read_ahead_kb
echo 128 > /sys/block/dm-8/queue/read_ahead_kb
echo 128 > /sys/block/dm-9/queue/read_ahead_kb

# Governor (up/down) rate_limit configuration
echo 20000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
echo 500 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
echo 10000 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us
echo 500 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us
echo 5000 > /sys/devices/system/cpu/cpufreq/policy7/schedutil/down_rate_limit_us
echo 500 > /sys/devices/system/cpu/cpufreq/policy7/schedutil/up_rate_limit_us

# Scheduler configuration
echo 65 85 > /proc/sys/kernel/sched_upmigrate
echo 60 75 > /proc/sys/kernel/sched_downmigrate
echo 95 > /proc/sys/kernel/sched_group_upmigrate
echo 75 > /proc/sys/kernel/sched_group_downmigrate

# Runtime cpusets
echo 0-7 > /dev/cpuset/top-app/cpus
echo 0-1 > /dev/cpuset/background/cpus
echo 0-3 > /dev/cpuset/system-background/cpus

# UCLamp tuning
echo 1 > /dev/cpuctl/top-app/cpu.uclamp.latency_sensitive
echo 50 > /dev/cpuctl/background/cpu.uclamp.max
echo 50 > /dev/cpuctl/system-background/cpu.uclamp.max
echo 60 > /dev/cpuctl/dex2oat/cpu.uclamp.max

# Setup cpu.shares to throttle background groups (bg ~ 5% sysbg ~ 5% dex2oat ~2.5%)
echo 1024 > /dev/cpuctl/background/cpu.shares
echo 1024 > /dev/cpuctl/system-background/cpu.shares
echo 512 > /dev/cpuctl/dex2oat/cpu.shares
echo 20480 > /dev/cpuctl/system/cpu.shares

# We only have system and background groups holding tasks and the groups below are empty
echo 20480 > /dev/cpuctl/camera-daemon/cpu.shares
echo 20480 > /dev/cpuctl/foreground/cpu.shares
echo 20480 > /dev/cpuctl/nnapi-hal/cpu.shares
echo 20480 > /dev/cpuctl/rt/cpu.shares
echo 20480 > /dev/cpuctl/top-app/cpu.shares

# Thread count after setup wizard
device_provisioned=`getprop persist.sys.device_provisioned`

if [ "$device_provisioned" == "1" ]; then
    setprop dalvik.vm.dex2oat-cpu-set 0,1,2,3,4,5,6
    setprop dalvik.vm.dex2oat-threads 6
fi

# Enable suspend to RAM
echo deep > /sys/power/mem_sleep

# CPU Input boost
echo "0:1324800" > /sys/devices/system/cpu/cpu_boost/input_boost_freq
echo 150 > /sys/devices/system/cpu/cpu_boost/input_boost_ms